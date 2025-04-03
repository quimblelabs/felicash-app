part of 'voice_transaction_result_view.dart';

class _VoiceTransactionOnHoldView extends HookWidget {
  const _VoiceTransactionOnHoldView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final animationController = useAnimationController(duration: 410.ms);

    return BlocListener<SpeechRecognitionBloc, SpeechRecognitionState>(
      listenWhen: (previous, current) =>
          previous != current &&
          (current is SpeechRecognitionPausedSuccess ||
              previous is SpeechRecognitionPausedSuccess),
      listener: (context, state) {
        if (state is SpeechRecognitionPausedSuccess) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
      },
      child: Animate(
        controller: animationController,
        key: const Key('on_hold_view'),
        effects: [
          ScaleEffect(begin: const Offset(.8, .8), duration: 210.ms),
        ],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.pause_rounded,
                size: 64,
                color: theme.hintColor,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'On Hold'.hardCoded,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'To turn the mic on and continue, tap the play button.'
                    .hardCoded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
