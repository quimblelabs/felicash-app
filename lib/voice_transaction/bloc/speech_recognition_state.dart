part of 'speech_recognition_bloc.dart';

sealed class SpeechRecognitionState extends Equatable {
  const SpeechRecognitionState();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

class SpeechRecognitionInitial extends SpeechRecognitionState {
  const SpeechRecognitionInitial();
}

class SpeechRecognitionReady extends SpeechRecognitionState {
  const SpeechRecognitionReady();
}

class SpeechRecognitionListeningInProgress extends SpeechRecognitionState {
  const SpeechRecognitionListeningInProgress({required this.recognizedText});

  final String recognizedText;

  @override
  List<Object?> get props => [recognizedText];
}

class SpeechRecognitionListeningSuccess extends SpeechRecognitionState {
  const SpeechRecognitionListeningSuccess({required this.recognizedText});

  final String recognizedText;

  @override
  List<Object?> get props => [recognizedText, ...super.props];
}

class SpeechRecognitionPausedSuccess extends SpeechRecognitionState {
  const SpeechRecognitionPausedSuccess();
}

class SpeechRecognitionFailure extends SpeechRecognitionState {
  const SpeechRecognitionFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
