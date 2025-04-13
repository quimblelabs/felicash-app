import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text_client/speech_to_text_client.dart';

part 'speech_recognition_event.dart';
part 'speech_recognition_state.dart';

/// The delay for the final recognized text.
///
/// If in the duration the user does not speak, the final recognized.
const kDelayForFinalRecognizedText = Duration(seconds: 2, milliseconds: 500);

class SpeechRecognitionBloc
    extends Bloc<SpeechRecognitionEvent, SpeechRecognitionState> {
  SpeechRecognitionBloc({
    required SpeechToTextClient speechToTextClient,
    Duration delayForFinalRecognizedText = kDelayForFinalRecognizedText,
  })  : _sttClient = speechToTextClient,
        _delayForFinalRecognizedText = delayForFinalRecognizedText,
        super(const SpeechRecognitionInitial()) {
    _statusSubscription = _sttClient.statusStream.listen(_listenForClientError);
    on<SpeechRecognitionClientStarted>(
      _onClientStart,
      transformer: droppable(),
    );
    on<SpeechRecognitionStatusChanged>(_onStatusChanged);
    on<SpeechRecognitionStartListeningRequested>(_onStartListeningRequested);
    on<SpeechRecognitionPauseSessionRequested>(_onPauseSessionRequested);
    on<SpeechRecognitionStopListeningRequested>(_onStopListeningRequested);
    on<SpeechRecognitionRecognizedTextUpdated>(_onRecognizedTextUpdated);
  }

  final Duration _delayForFinalRecognizedText;
  final SpeechToTextClient _sttClient;
  late StreamSubscription<SpeechToTextStatus> _statusSubscription;

  /// The timer to stop listening when the user does not speak.
  Timer? _stopListeningDebouncer;

  void _listenForClientError(SpeechToTextStatus clientStatus) {
    debugPrint('Client status: $clientStatus');
    if (clientStatus == SpeechToTextStatus.error) {
      add(
        const SpeechRecognitionStatusChanged(
          SpeechRecognitionFailure(errorMessage: 'Speech recognition error'),
        ),
      );
    }
  }

  Future<void> _onClientStart(
    SpeechRecognitionClientStarted event,
    Emitter<SpeechRecognitionState> emit,
  ) async {
    try {
      final isInitialized = await _sttClient.initialize();
      if (!isInitialized) {
        emit(
          const SpeechRecognitionFailure(
            errorMessage: 'Error when initializing the speech to text client',
          ),
        );
        return;
      }
      emit(const SpeechRecognitionReady());
    } catch (e) {
      emit(
        SpeechRecognitionFailure(
          errorMessage: 'Error when initializing the speech to text client: $e',
        ),
      );
    }
  }

  void _onStatusChanged(
    SpeechRecognitionStatusChanged event,
    Emitter<SpeechRecognitionState> emit,
  ) {
    emit(event.state);
  }

  Future<void> _onStartListeningRequested(
    SpeechRecognitionStartListeningRequested event,
    Emitter<SpeechRecognitionState> emit,
  ) async {
    try {
      final language = event.language;
      await _sttClient.startListening(
        onResult: (result) {
          if (isClosed) return;
          if (state is! SpeechRecognitionListeningInProgress) return;
          add(SpeechRecognitionRecognizedTextUpdated(result));
        },
        language: language,
      );
      emit(const SpeechRecognitionListeningInProgress(recognizedText: ''));
    } catch (e) {
      emit(
        SpeechRecognitionFailure(
          errorMessage: 'Error when starting listening: $e',
        ),
      );
    }
  }

  Future<void> _onPauseSessionRequested(
    SpeechRecognitionPauseSessionRequested event,
    Emitter<SpeechRecognitionState> emit,
  ) async {
    try {
      await _sttClient.cancel();
      if (state is SpeechRecognitionListeningInProgress) {
        emit(const SpeechRecognitionPausedSuccess());
      }
    } catch (e) {
      emit(
        SpeechRecognitionFailure(
          errorMessage: 'Error when pausing the session: $e',
        ),
      );
    }
  }

  Future<void> _onStopListeningRequested(
    SpeechRecognitionStopListeningRequested event,
    Emitter<SpeechRecognitionState> emit,
  ) async {
    try {
      await _sttClient.stop();
      if (state case final SpeechRecognitionListeningInProgress currentState) {
        emit(
          SpeechRecognitionListeningSuccess(
            recognizedText: currentState.recognizedText,
          ),
        );
      }
    } catch (e) {
      emit(
        SpeechRecognitionFailure(
          errorMessage: 'Error when stopping listening: $e',
        ),
      );
    }
  }

  void _onRecognizedTextUpdated(
    SpeechRecognitionRecognizedTextUpdated event,
    Emitter<SpeechRecognitionState> emit,
  ) {
    if (state is SpeechRecognitionListeningInProgress) {
      emit(SpeechRecognitionListeningInProgress(recognizedText: event.text));
      // Handle for the final recognized text and
      // update the status for processing
      if (event.source == RecognizedTextSource.voice) {
        _stopListeningDebouncer?.cancel();
        _stopListeningDebouncer = Timer(
          _delayForFinalRecognizedText,
          () => add(
            const SpeechRecognitionStopListeningRequested(
              reason: StopListeningReason.noSpeechAfterDelay,
            ),
          ),
        );
      } else {
        // TODO(tuanhm): Handle for keyboard input
      }
    }
  }

  @override
  Future<void> close() async {
    _stopListeningDebouncer?.cancel();
    _stopListeningDebouncer = null;
    await _sttClient.cancel();
    await _statusSubscription.cancel();
    return super.close();
  }
}
