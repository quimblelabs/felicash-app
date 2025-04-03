import 'package:app_ui/app_ui.dart';
import 'package:felicash/voice_transaction/bloc/speech_recognition_bloc.dart';
import 'package:felicash/voice_transaction/bloc/transaction_processing_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VoiceTransactionBottomButtons extends StatelessWidget {
  const VoiceTransactionBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButtonTheme(
      data: IconButtonThemeData(
        style: IconButton.styleFrom(
          enableFeedback: true,
          minimumSize: AppIconButtonSizes.largeMinimumSize,
          maximumSize: AppIconButtonSizes.largeMaximumSize,
        ),
      ),
      child: const Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _CloseButton(),
            _PlayPauseButton(),
          ],
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton.filled(
      onPressed: () {
        HapticFeedback.lightImpact();
        context.pop();
      },
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.error,
      ),
      icon: const Icon(Icons.close),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton();

  @override
  Widget build(BuildContext context) {
    final isSessionPaused = context.select<SpeechRecognitionBloc, bool>(
      (bloc) => bloc.state is SpeechRecognitionPausedSuccess,
    );
    final isProcessing = context.select<TransactionProcessingBloc, bool>(
      (bloc) => bloc.state is TransactionProcessingInProgress,
    );
    Widget icon = const Icon(Icons.pause_rounded);
    if (isSessionPaused) {
      icon = const Icon(Icons.play_arrow_rounded);
    } else if (isProcessing) {
      icon = const Icon(Icons.stop_rounded);
    }
    return IconButton.filled(
      onPressed: () {
        HapticFeedback.lightImpact();
        if (isSessionPaused) {
          context
              .read<SpeechRecognitionBloc>()
              .add(SpeechRecognitionStartListeningRequested());
        } else if (isProcessing) {
          context
              .read<TransactionProcessingBloc>()
              .add(TransactionProcessingCancelProcessing());
          context
              .read<SpeechRecognitionBloc>()
              .add(SpeechRecognitionStartListeningRequested());
        } else {
          context
              .read<SpeechRecognitionBloc>()
              .add(SpeechRecognitionPauseSessionRequested());
          final isProcessCompleted = context
              .read<TransactionProcessingBloc>()
              .state is TransactionProcessingCompleted;
          if (isProcessCompleted) {
            context
                .read<TransactionProcessingBloc>()
                .add(const TransactionProcessingReset(keepHistory: true));
          }
        }
      },
      icon: icon,
    );
  }
}
