import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:permission_client/permission_client.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// The status of the speach to text service.
enum SpeechToTextStatus {
  /// The service is on idle and not initialized.
  uninitialized,

  /// The service is initialized and ready to use.
  ready,

  /// The service is listening for speech.
  listening,

  /// The service has finished listening for speech
  /// and the user has stopped speaking.
  done,

  /// The service is running but not listening for speech.
  ///
  /// when speech recognition is no longer listening to the
  /// microphone after a timeout, [SpeechToTextClient.cancel]
  /// or [SpeechToTextClient.stop] call.
  notListening,

  ///  An error has occurred during speech recognition.
  error,

  /// The service is not available.
  ///
  /// This can be due to the user denying permission to use the microphone
  /// or STT service being unavailable.
  ///
  /// Guide the user to open the settings and grant permission.
  unavailable,
}

/// The result of the speach to text service.
typedef OnSpeechResult = void Function(String text);

/// The callback on the sound level change when the user is speaking.
typedef OnSoundLevelChange = void Function(double level);

extension on LocaleName {
  Locale toLocale() {
    final parts = localeId.split('-');
    final languageCode = parts.first;
    final countryCode = parts.last;
    return Locale(languageCode, countryCode);
  }
}

/// {@template speech_language}
/// The language of the speach to text service.
/// {@endtemplate}
class SpeechLanguage extends Equatable {
  /// {@macro speech_language}
  const SpeechLanguage(this.locale, this.name);

  /// The locale of the language.
  final Locale locale;

  /// The name of the language.
  final String name;

  @override
  List<Object?> get props => [locale, name];

  @override
  bool? get stringify => true;
}

extension on SpeechLanguage {
  /// Converts the speach language to a locale name.
  LocaleName toLocaleName() {
    final localeId = '${locale.languageCode}-${locale.countryCode}';
    return LocaleName(
      localeId,
      name,
    );
  }
}

/// {@template speach_to_text_client}
/// A Speach to text client.
/// {@endtemplate}
class SpeechToTextClient {
  /// {@macro speach_to_text_client}
  SpeechToTextClient() {
    _statusStreamController.add(SpeechToTextStatus.uninitialized);
  }

  final _statusStreamController =
      StreamController<SpeechToTextStatus>.broadcast();

  /// The status streaming of the speach to text client.
  Stream<SpeechToTextStatus> get statusStream => _statusStreamController.stream;

  final SpeechToText _speech = SpeechToText();

  /// Initializes the speach to text client.
  Future<bool> initialize() async {
    final initialized = await _speech.initialize(
      onStatus: _onStatusChanged,
      onError: _onError,
    );
    return initialized;
  }

  void _onStatusChanged(String status) {
    debugPrint('Client status - RAW: $status');
    switch (status) {
      case 'listening':
        _statusStreamController.add(SpeechToTextStatus.listening);
      case 'notListening':
        _statusStreamController.add(SpeechToTextStatus.notListening);
      case 'done':
        _statusStreamController.add(SpeechToTextStatus.done);
    }
  }

  void _onError(SpeechRecognitionError error) {
    debugPrint('Client status - RAW (ERROR): ${error.errorMsg}');
    if (error.permanent) {
      _statusStreamController.add(SpeechToTextStatus.notListening);
    } else {
      _statusStreamController.add(SpeechToTextStatus.error);
    }
  }

  /// Get all available speech languages that are supported by the device.
  Future<List<SpeechLanguage>> getSpeechLanguages() async {
    final locales = await _speech.locales();
    return locales.map((e) => SpeechLanguage(e.toLocale(), e.name)).toList();
  }

  /// Starts a new speech recognition session.
  ///
  /// This will also start listening for speech.
  ///
  /// - `onResult` is called when the user stops speaking.
  /// - `onSoundLevelChanged` is called when the user is speaking.
  /// - `pauseFor` is the duration to pause for after the user stops speaking.
  /// - `language` is the language to use for speech recognition. If not
  /// provided, the default language will be used.
  Future<void> startListening({
    required OnSpeechResult onResult,
    OnSoundLevelChange? onSoundLevelChanged,
    Duration? pauseFor,
    SpeechLanguage? language,
  }) async {
    await _speech.listen(
      onResult: (res) => onResult(res.recognizedWords),
      onSoundLevelChange: onSoundLevelChanged,
      pauseFor: pauseFor,
      localeId: language?.toLocaleName().localeId,
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
      ),
    );
    _statusStreamController.add(SpeechToTextStatus.listening);
  }

  /// Stops listening for speech.
  ///
  /// This will also stop listening for speech.
  Future<void> stop() async {
    await _speech.stop();
  }

  /// Cancels the current speech recognition session. The last result will be
  /// an empty string `''`.
  ///
  /// This will also stop listening for speech like [stop].
  Future<void> cancel() async {
    await _speech.cancel();
  }
}
