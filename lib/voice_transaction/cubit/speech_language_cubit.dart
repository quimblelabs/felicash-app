import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text_client/speech_to_text_client.dart';

part 'speech_language_state.dart';

class SpeechLanguageCubit extends Cubit<SpeechLanguageState> {
  SpeechLanguageCubit({
    required SpeechToTextClient speechToTextClient,
  })  : _sttClient = speechToTextClient,
        super(const SpeechLanguageState());

  final SpeechToTextClient _sttClient;

  /// Load available languages from the speech to text client
  Future<void> loadLanguages() async {
    emit(state.copyWith(status: SpeechLanguageStatus.loading));

    try {
      final languages = await _sttClient.getSpeechLanguages();
      emit(
        state.copyWith(
          status: SpeechLanguageStatus.success,
          availableLanguages: languages,
          // Set Vietnamese as default if available
          selectedLanguage: languages.firstWhere(
            (lang) => lang.locale.languageCode == 'vi',
            orElse: () => languages.first,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SpeechLanguageStatus.failure,
          errorMessage: 'Failed to load languages: $e',
        ),
      );
    }
  }

  /// Select a language
  void selectLanguage(SpeechLanguage language) {
    emit(state.copyWith(selectedLanguage: language));
  }

  /// Get the current selected language or fallback to Vietnamese
  SpeechLanguage getSelectedLanguage() {
    return state.selectedLanguage ??
        const SpeechLanguage(Locale('vi', 'VN'), 'Vietnamese');
  }
}
