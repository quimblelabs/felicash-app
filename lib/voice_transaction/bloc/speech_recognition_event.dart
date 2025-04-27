// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'speech_recognition_bloc.dart';

/// The source of the recognized text.
enum RecognizedTextSource {
  voice,
  keyboard,
}

enum StopListeningReason {
  /// The process stopped manually by user or the system.
  ///
  /// This will stop listen and trigger `notListening` status.
  manual,

  /// The user did not speak anything after delay time.
  ///
  /// This will stop listen and trigger `done` status.
  noSpeechAfterDelay,
}

sealed class SpeechRecognitionEvent extends Equatable {
  const SpeechRecognitionEvent();

  @override
  List<Object?> get props => [];
}

/// Initial event to initialize the speech recognition session.
class SpeechRecognitionClientStarted extends SpeechRecognitionEvent {}

class SpeechRecognitionLoadResourceRequested extends SpeechRecognitionEvent {
  const SpeechRecognitionLoadResourceRequested({
    this.walletsParameter = const [],
    this.categoriesParameter = const [],
  });

  final List<BaseWalletModel> walletsParameter;
  final List<CategoryModel> categoriesParameter;

  @override
  List<Object?> get props => [
        ...super.props,
        walletsParameter,
        categoriesParameter,
      ];
}

class SpeechRecognitionStartListeningRequested extends SpeechRecognitionEvent {
  const SpeechRecognitionStartListeningRequested({
    this.language,
  });

  /// The language to recognize.
  ///
  /// If not provided, the default language will be used.
  final SpeechLanguage? language;

  @override
  List<Object?> get props => [language, ...super.props];
}

class SpeechRecognitionStopListeningRequested extends SpeechRecognitionEvent {
  const SpeechRecognitionStopListeningRequested({
    this.reason = StopListeningReason.manual,
  });
  final StopListeningReason reason;

  @override
  List<Object?> get props => [reason, ...super.props];
}

class SpeechRecognitionPauseSessionRequested extends SpeechRecognitionEvent {}

class SpeechRecognitionStatusChanged extends SpeechRecognitionEvent {
  const SpeechRecognitionStatusChanged(this.state);
  final SpeechRecognitionState state;
  @override
  List<Object?> get props => [state, ...super.props];
}

class SpeechRecognitionRecognizedTextUpdated extends SpeechRecognitionEvent {
  const SpeechRecognitionRecognizedTextUpdated(
    this.text, {
    this.source = RecognizedTextSource.voice,
  });
  final String text;
  final RecognizedTextSource source;
  @override
  List<Object?> get props => [text, source];
}
