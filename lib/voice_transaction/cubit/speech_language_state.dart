part of 'speech_language_cubit.dart';

enum SpeechLanguageStatus { initial, loading, success, failure }

class SpeechLanguageState extends Equatable {
  const SpeechLanguageState({
    this.status = SpeechLanguageStatus.initial,
    this.availableLanguages = const [],
    this.selectedLanguage,
    this.errorMessage,
  });

  final SpeechLanguageStatus status;
  final List<SpeechLanguage> availableLanguages;
  final SpeechLanguage? selectedLanguage;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        availableLanguages,
        selectedLanguage,
        errorMessage,
      ];

  SpeechLanguageState copyWith({
    SpeechLanguageStatus? status,
    List<SpeechLanguage>? availableLanguages,
    SpeechLanguage? selectedLanguage,
    String? errorMessage,
  }) {
    return SpeechLanguageState(
      status: status ?? this.status,
      availableLanguages: availableLanguages ?? this.availableLanguages,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
