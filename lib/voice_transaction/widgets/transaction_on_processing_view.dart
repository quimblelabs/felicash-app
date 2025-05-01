part of 'voice_transaction_result_view.dart';

class _TransactionOnProcessingView extends StatelessWidget {
  const _TransactionOnProcessingView();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      reverse: true,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppRadius.xlg,
      ),
      child: Column(
        children: [
          _TransactionResultCard(),
          _RecognitionResultCard(),
        ],
      ),
    );
  }
}

class _RecognitionResultCard extends HookWidget {
  const _RecognitionResultCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextStyle = theme.textTheme.labelLarge ?? const TextStyle();
    final isVisible = context.select<SpeechRecognitionBloc, bool>(
      (bloc) {
        if (bloc.state case final SpeechRecognitionListeningInProgress state) {
          return state.recognizedText.isNotEmpty;
        }
        return false;
      },
    );
    return DefaultTextStyle(
      style: effectiveTextStyle,
      child: _AnimatedSlidingFade(
        isVisible: isVisible,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.xlg),
            boxShadow: [
              BoxShadow(
                blurRadius: 40,
                spreadRadius: 10,
                offset: const Offset(0, 1),
                color: theme.shadowColor.withValues(alpha: .015),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AnimatedSize(
            clipBehavior: Clip.none,
            duration: const Duration(milliseconds: 410),
            child: Builder(
              builder: (context) {
                final recognizedText = context.select(
                  (SpeechRecognitionBloc bloc) =>
                      (bloc.state as SpeechRecognitionListeningInProgress)
                          .recognizedText,
                );
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recognizedText),
                    const Center(child: _ImThinking()),
                    const _ProcessResponseText(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ImThinking extends StatelessWidget {
  const _ImThinking();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isProcessing = context.select<AiAssistantBloc, bool>(
      (bloc) => bloc.state is AiAssistantInProgress,
    );
    return Visibility(
      visible: isProcessing,
      child: Animate(
        effects: const [
          SlideEffect(
            begin: Offset(0, .1),
            duration: Duration(milliseconds: 210),
          ),
          FadeEffect(
            duration: Duration(milliseconds: 500),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: AppRadius.lg,
                child: Animate(
                  autoPlay: true,
                  onPlay: (controller) => controller.repeat(),
                  effects: const [
                    RotateEffect(
                      duration: Duration(seconds: 3),
                    ),
                  ],
                  child: Icon(
                    FeliCashIcons.magic,
                    size: AppRadius.lg,
                    color: theme.colorScheme.secondaryFixed,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                l10n.thinking,
                style: theme.textTheme.labelLarge,
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .shimmer(
                    duration: 2.seconds,
                    color: theme.colorScheme.secondaryFixed,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessResponseText extends StatelessWidget {
  const _ProcessResponseText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = context.select<AiAssistantBloc, bool>(
      (bloc) => bloc.state is AiAssistantCompleted,
    );
    final responseText = context.select<AiAssistantBloc, String?>(
      (bloc) => bloc.state is AiAssistantCompleted
          ? (bloc.state as AiAssistantCompleted).process.response?.responseText
          : null,
    );
    final length = responseText?.length ?? 0;
    Duration? duration;
    Duration? delay;
    // Use delay for short text and duration for long text
    if (length < 100) {
      delay = 15.ms;
    } else {
      duration = 3.seconds;
    }
    return Visibility(
      visible: isCompleted,
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.lg),
        child: TextStreamBuilder(
          input: responseText ?? '',
          duration: duration,
          delay: delay,
          builder: (context, text, untilNow) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      text: untilNow,
                      children: [
                        TextSpan(
                          text: text,
                          style: TextStyle(
                            color: theme.colorScheme.secondaryFixed,
                          ),
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.sm),
                            child: Icon(
                              FeliCashIcons.magic_symbol,
                              size: 24,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    style: DefaultTextStyle.of(context).style.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TransactionResultCard extends StatelessWidget {
  const _TransactionResultCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isVisible = context.select<AiAssistantBloc, bool>(
      (bloc) =>
          bloc.state is AiAssistantCompleted &&
          ((bloc.state as AiAssistantCompleted)
                  .process
                  .response
                  ?.transactions
                  .isNotEmpty ??
              false),
    );

    return _AnimatedSlidingFade(
      isVisible: isVisible,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.xlg),
          boxShadow: [
            BoxShadow(
              blurRadius: 40,
              spreadRadius: 10,
              offset: const Offset(0, 1),
              color: theme.shadowColor.withValues(alpha: .015),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Builder(
          builder: (context) {
            final l10n = context.l10n;
            final state = context.watch<AiAssistantBloc>().state;

            if (state is! AiAssistantCompleted) {
              return const SizedBox.shrink();
            }
            final transaction =
                state.process.response?.transactions.firstOrNull;
            if (transaction == null) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                TransactionItem(transaction: transaction),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: AppButtonSizes.smallMinimumSize,
                          maximumSize: AppButtonSizes.smallMaximumSize,
                        ),
                        onPressed: () {
                          // TODO(tuanhm): Implement this
                        },
                        child: Text(
                          l10n.transactionOnProcessingViewEditTransactionButtonLabel,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    IconButton(
                      onPressed: () {
                        // TODO(tuanhm): Implement this
                      },
                      color: theme.colorScheme.error,
                      icon: const Icon(IconsaxPlusLinear.trash),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.transactionOnProcessingViewCreateNextTransactionText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedSlidingFade extends HookWidget {
  const _AnimatedSlidingFade({
    required this.isVisible,
    required this.child,
  });

  final bool isVisible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final slidingAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 410),
    );
    final isShown = useState(false);
    useEffect(
      () {
        if (isVisible) {
          isShown.value = true;
          slidingAnimationController.forward();
        } else {
          slidingAnimationController
              .reverse()
              .then((_) => isShown.value = false);
        }
        return null;
      },
      [isVisible],
    );
    return Visibility(
      visible: isShown.value,
      child: Animate(
        controller: slidingAnimationController,
        effects: const [
          SlideEffect(
            begin: Offset(0, .2),
            duration: Duration(milliseconds: 410),
          ),
          FadeEffect(
            begin: 0,
            end: 1,
            duration: Duration(milliseconds: 410),
          ),
        ],
        child: child,
      ),
    );
  }
}
