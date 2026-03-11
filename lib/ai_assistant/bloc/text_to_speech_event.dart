part of 'text_to_speech_bloc.dart';

@freezed
abstract class TextToSpeechEvent with _$TextToSpeechEvent {
  const factory TextToSpeechEvent.started({
    required String text,
  }) = SpeechToTextStarted;

  const factory TextToSpeechEvent.stopped() = SpeechToTextStopped;
}
