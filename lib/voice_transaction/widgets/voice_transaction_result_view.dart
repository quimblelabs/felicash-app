import 'package:app_ui/app_ui.dart';
import 'package:felicash/transaction/view/transaction_item.dart';
import 'package:felicash/voice_transaction/bloc/speech_recognition_bloc.dart';
import 'package:felicash/voice_transaction/bloc/transaction_processing_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

part 'transaction_on_processing_view.dart';
part 'voice_transaction_on_hold_view.dart';

class VoiceTransactionResultView extends StatelessWidget {
  const VoiceTransactionResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final isPaused = context.select(
      (SpeechRecognitionBloc bloc) =>
          bloc.state is SpeechRecognitionPausedSuccess,
    );
    final currentIndex = isPaused ? 1 : 0;
    return IndexedStackTransitionBuilder(
      sizing: StackFit.expand,
      index: currentIndex,
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return FadeTransition(
          opacity: primaryAnimation,
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 1,
              end: 0,
            ).animate(secondaryAnimation),
            child: child,
          ),
        );
      },
      children: const [
        _TransactionOnProcessingView(),
        _VoiceTransactionOnHoldView(),
      ],
    );
  }
}
