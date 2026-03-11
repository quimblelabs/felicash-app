part of 'text_to_speech_bloc.dart';

@freezed
class TextToSpeechState with _$TextToSpeechState {
  const factory TextToSpeechState.initial() = _Initial;

  const factory TextToSpeechState.playing() = _SpeechPlaying;

  const factory TextToSpeechState.completed() = _Completed;

  const factory TextToSpeechState.error({
    required String message,
  }) = _SpeechError;
}
