import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart'; // For debugPrint and kReleaseMode
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

// Status for the TTS Client
enum TTSStatus { idle, loading, playing, error }

enum TTSInstance { openai, elevenlabs }

enum TTSElevenLabsVoice {
  rachel('21m00Tcm4TlvDq8ikWAM'),
  tvcAiHanh('pGapy9MNHCukzJtjavF0');

  final String id;

  const TTSElevenLabsVoice(this.id);
}

enum TTSElevenLabsModel {
  elevenMultilingualV2('eleven_multilingual_v2'),
  elevenTurboV25('eleven_turbo_v2_5'),
  elevenFlashV25('eleven_flash_v2_5');

  final String id;

  const TTSElevenLabsModel(this.id);
}

// Feed your own stream of bytes into the player
class BytesAudioSource extends StreamAudioSource {
  final Uint8List bytes;
  BytesAudioSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}

class OpenAITextToSpeechClient {
  OpenAITextToSpeechClient({
    required String apiKey,
    String baseUrl = 'https://api.openai.com',
    bool enableDebug = false,
    String? organization,
    int requestsTimeout = 20000,
  }) {
    OpenAI.apiKey = apiKey;
    OpenAI.baseUrl = baseUrl;
    OpenAI.showLogs = enableDebug;
    OpenAI.showResponsesLogs = enableDebug;
    OpenAI.organization = organization;
    OpenAI.requestsTimeOut = Duration(milliseconds: requestsTimeout);
    _enableDebug = enableDebug;
    _updateStatus(TTSStatus.idle); // Initial status
    _listenToPlayerStates();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  TTSStatus _currentStatus = TTSStatus.idle;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _processingStateSubscription;
  final _statusController = StreamController<TTSStatus>.broadcast();

  Stream<TTSStatus> get statusStream => _statusController.stream;

  bool _enableDebug = false;

  Future<void> speak(
    String text, {
    String model = 'tts-1',
    String voice = 'alloy', // alloy, echo, fable, onyx, nova, shimmer
    OpenAIAudioSpeechResponseFormat responseFormat =
        OpenAIAudioSpeechResponseFormat.mp3,
    double speed = 1.0,
    required Directory? outputDirectory,
    required String outputFileName,
  }) async {
    if (text.isEmpty) {
      _log('TTS Speak: Input text is empty.');
      return;
    }
    if (_currentStatus == TTSStatus.loading ||
        _currentStatus == TTSStatus.playing) {
      _log('TTS Speak: Already loading or playing. Stopping previous.');
      await stop(); // Stop current playback before starting new
    }

    _updateStatus(TTSStatus.loading);

    try {
      _log('TTS Speak: Requesting speech for "$text"');
      final File speechDataFile = await OpenAI.instance.audio.createSpeech(
        model: model,
        input: text,
        voice: voice,
        responseFormat: responseFormat,
        speed: speed,
        outputDirectory: outputDirectory,
        outputFileName: outputFileName,
      );
      if (speechDataFile.existsSync()) {
        _log(
          'TTS Speak: Received ${speechDataFile.lengthSync()} bytes. Playing...',
        );
        await _audioPlayer.setFilePath(speechDataFile.path);
        await _audioPlayer.play();
        await speechDataFile.delete();
      } else {
        _log('TTS Speak: Error - Received empty audio data.');
        _updateStatus(TTSStatus.error);
      }
    } on RequestFailedException catch (e) {
      _log(
        'TTS Speak: OpenAI API Error - ${e.message} (Status Code: ${e.statusCode})',
      );
      _updateStatus(TTSStatus.error);
    } catch (e) {
      _log('TTS Speak: Unexpected error - $e');
      _updateStatus(TTSStatus.error);
      await _audioPlayer.stop(); // Ensure stop on unexpected error
    }
  }

  Future<void> stop() async {
    if (_audioPlayer.playing || _currentStatus == TTSStatus.loading) {
      _log('TTS Speak: Stopping playback.');
      await _audioPlayer.stop();
      _updateStatus(TTSStatus.idle); // Explicitly set to idle on manual stop
    }
  }

  void dispose() {
    _log('Disposing TextToSpeechClient...');
    _playerStateSubscription?.cancel();
    _processingStateSubscription?.cancel();
    _audioPlayer.dispose();
    _statusController.close();
  }

  void _listenToPlayerStates() {
    _playerStateSubscription?.cancel(); // Cancel previous subscription if any
    _processingStateSubscription?.cancel();

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (_currentStatus == TTSStatus.loading && state.playing) {
        _updateStatus(TTSStatus.playing);
      }
      // If it stops playing while it thought it was playing or loading
      else if ((_currentStatus == TTSStatus.playing ||
              _currentStatus == TTSStatus.loading) &&
          !state.playing) {
        // Check processing state to confirm it's not just buffering
        if (_audioPlayer.processingState == ProcessingState.completed ||
            _audioPlayer.processingState == ProcessingState.idle) {
          _updateStatus(TTSStatus.idle);
        }
      }
    });

    _processingStateSubscription = _audioPlayer.processingStateStream.listen((
      state,
    ) {
      // If processing completes or goes idle, ensure status is idle
      if (state == ProcessingState.completed || state == ProcessingState.idle) {
        if (_currentStatus != TTSStatus.idle &&
            _currentStatus != TTSStatus.error) {
          _updateStatus(TTSStatus.idle);
        }
      }
    });
  }

  void _updateStatus(TTSStatus newStatus) {
    if (_currentStatus != newStatus) {
      _currentStatus = newStatus;
      _statusController.add(newStatus);
      if (!kReleaseMode) {
        // Avoid printing in release builds
        _log('OpenAITTSClient Status: $newStatus');
      }
    }
  }

  void _log(String message) {
    if (_enableDebug) {
      debugPrint('OpenAITTSClient: $message');
    }
  }
}

class ElevenLabsTextToSpeechClient {
  ElevenLabsTextToSpeechClient({
    required String apiKey,
    required String baseUrl,
    bool enableDebug = false,
  }) : _enableDebug = enableDebug,
       _apiKey = apiKey,
       _baseUrl = baseUrl {
    _updateStatus(TTSStatus.idle); // Initial status
    _listenToPlayerStates();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  TTSStatus _currentStatus = TTSStatus.idle;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _processingStateSubscription;
  final _statusController = StreamController<TTSStatus>.broadcast();

  Stream<TTSStatus> get statusStream => _statusController.stream;

  final bool _enableDebug;
  final String _apiKey;
  final String _baseUrl;

  Future<void> speak(
    String text, {
    required TTSElevenLabsVoice voice,
    required TTSElevenLabsModel model,
  }) async {
    if (text.isEmpty) {
      _log('TTS Speak: Input text is empty.');
      return;
    }
    if (_currentStatus == TTSStatus.loading ||
        _currentStatus == TTSStatus.playing) {
      _log('TTS Speak: Already loading or playing. Stopping previous.');
      await stop(); // Stop current playback before starting new
    }

    _updateStatus(TTSStatus.loading);

    try {
      _log('TTS Speak: Requesting speech for "$text"');
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/text-to-speech/${voice.id}'),
        headers: {'xi-api-key': _apiKey, 'Content-Type': 'application/json'},
        body: json.encode({
          "text": text,
          "model_id": model.id,
          "voice_settings": {"stability": .30, "similarity_boost": .75},
        }),
      );

      if (response.statusCode == 200) {
        _log('TTS Speak: Received ${response.body.length} bytes. Playing...');
        await _audioPlayer.setAudioSource(BytesAudioSource(response.bodyBytes));
        await _audioPlayer.play();
      } else {
        _log('TTS Speak: Error - Received empty audio data.');
        _updateStatus(TTSStatus.error);
      }
    } on RequestFailedException catch (e) {
      _log(
        'TTS Speak: OpenAI API Error - ${e.message} (Status Code: ${e.statusCode})',
      );
      _updateStatus(TTSStatus.error);
    } catch (e) {
      _log('TTS Speak: Unexpected error - $e');
      _updateStatus(TTSStatus.error);
      await _audioPlayer.stop(); // Ensure stop on unexpected error
    }
  }

  Future<void> stop() async {
    if (_audioPlayer.playing || _currentStatus == TTSStatus.loading) {
      _log('TTS Speak: Stopping playback.');
      await _audioPlayer.stop();
      _updateStatus(TTSStatus.idle); // Explicitly set to idle on manual stop
    }
  }

  void dispose() {
    _log('Disposing TextToSpeechClient...');
    _playerStateSubscription?.cancel();
    _processingStateSubscription?.cancel();
    _audioPlayer.dispose();
    _statusController.close();
  }

  void _listenToPlayerStates() {
    _playerStateSubscription?.cancel(); // Cancel previous subscription if any
    _processingStateSubscription?.cancel();

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (_currentStatus == TTSStatus.loading && state.playing) {
        _updateStatus(TTSStatus.playing);
      }
      // If it stops playing while it thought it was playing or loading
      else if ((_currentStatus == TTSStatus.playing ||
              _currentStatus == TTSStatus.loading) &&
          !state.playing) {
        // Check processing state to confirm it's not just buffering
        if (_audioPlayer.processingState == ProcessingState.completed ||
            _audioPlayer.processingState == ProcessingState.idle) {
          _updateStatus(TTSStatus.idle);
        }
      }
    });

    _processingStateSubscription = _audioPlayer.processingStateStream.listen((
      state,
    ) {
      // If processing completes or goes idle, ensure status is idle
      if (state == ProcessingState.completed || state == ProcessingState.idle) {
        if (_currentStatus != TTSStatus.idle &&
            _currentStatus != TTSStatus.error) {
          _updateStatus(TTSStatus.idle);
        }
      }
    });
  }

  void _updateStatus(TTSStatus newStatus) {
    if (_currentStatus != newStatus) {
      _currentStatus = newStatus;
      _statusController.add(newStatus);
      if (!kReleaseMode) {
        // Avoid printing in release builds
        _log('OpenAITTSClient Status: $newStatus');
      }
    }
  }

  void _log(String message) {
    if (_enableDebug) {
      debugPrint('OpenAITTSClient: $message');
    }
  }
}
