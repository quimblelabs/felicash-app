import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:text_to_speech_client/text_to_speech_client.dart';

part 'text_to_speech_bloc.freezed.dart';
part 'text_to_speech_event.dart';
part 'text_to_speech_state.dart';

class TextToSpeechBloc extends Bloc<TextToSpeechEvent, TextToSpeechState> {
  TextToSpeechBloc({
    required ElevenLabsTextToSpeechClient textToSpeechClient,
  })  : _textToSpeechClient = textToSpeechClient,
        super(const TextToSpeechState.initial()) {
    on<SpeechToTextStarted>(_onSpeechToTextStarted);
    on<SpeechToTextStopped>(_onSpeechToTextStopped);
  }

  final ElevenLabsTextToSpeechClient _textToSpeechClient;

  Future<void> _onSpeechToTextStarted(
    SpeechToTextStarted event,
    Emitter<TextToSpeechState> emit,
  ) async {
    emit(const TextToSpeechState.playing());
    try {
      await _textToSpeechClient.stop();
      await _textToSpeechClient.speak(
        event.text,
        voice: TTSElevenLabsVoice.tvcAiHanh,
        model: TTSElevenLabsModel.elevenTurboV25,
      );
      emit(const TextToSpeechState.completed());
    } catch (e, stackTrace) {
      log('Error during text-to-speech: $e', stackTrace: stackTrace);
      emit(TextToSpeechState.error(message: e.toString()));
    }
  }

  Future<void> _onSpeechToTextStopped(
    SpeechToTextStopped event,
    Emitter<TextToSpeechState> emit,
  ) async {
    emit(const TextToSpeechState.initial());
    try {
      await _textToSpeechClient.stop();
      emit(const TextToSpeechState.initial());
    } catch (e, stackTrace) {
      log('Error during text-to-speech stop: $e', stackTrace: stackTrace);
      emit(TextToSpeechState.error(message: e.toString()));
    }
  }
}
