import 'package:app_ui/app_ui.dart';
import 'package:felicash/ai_assistant/bloc/ai_assistant_bloc.dart';
import 'package:felicash/ai_assistant/bloc/ai_assistant_bloc.dart';
import 'package:felicash/ai_assistant/cubit/ai_assistant_view_cubit.dart';
import 'package:felicash/ai_assistant/models/ai_assistant_request_model.dart';
import 'package:felicash/transaction/view/transaction_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ChatBox extends HookWidget {
  const ChatBox({super.key});

  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final state = context.read<AiAssistantBloc>().state;
    final message = state.history[index];
    final isLastMessage = index == state.history.length - 1;
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, .01),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        ),
        child: _MessageItem(
          message: message,
          isLastMessage: isLastMessage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final listKey = useMemoized(GlobalKey<AnimatedListState>.new);

    void scrollToBottom() {
      if (!scrollController.hasClients) return;
      final maxScrollExtent = scrollController.position.maxScrollExtent;
      final currentScrollOffset = scrollController.offset;
      if (maxScrollExtent == currentScrollOffset) return;
      scrollController.animateTo(
        maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (size != context.read<AiAssistantViewCubit>().state.chatBoxSize) {
          context.read<AiAssistantViewCubit>().updateChatBoxSize(size);
        }
        return BlocConsumer<AiAssistantBloc, AiAssistantState>(
          listenWhen: (previous, current) =>
              previous.history.length != current.history.length,
          listener: (context, state) {
            final newItemIndex = state.history.length - 1;
            listKey.currentState?.insertItem(newItemIndex, duration: 210.ms);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(220.ms, scrollToBottom);
            });
          },
          builder: (context, state) {
            if (state.history.isEmpty) {
              return const _EmptyView();
            }
            return AnimatedList.separated(
              key: listKey,
              controller: scrollController,
              padding: EdgeInsets.zero,
              initialItemCount: state.history.length,
              removedSeparatorBuilder: (context, index, _) =>
                  const SizedBox(height: AppSpacing.md),
              separatorBuilder: (context, index, _) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: _buildItem,
            );
          },
        );
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dolarBill = AppColors.dollarBill.colorSchemeOf(context);
    final crimsionRed = AppColors.crimsionRed.colorSchemeOf(context);
    final tangerine = AppColors.tangerine.colorSchemeOf(context);

    return Center(
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            dolarBill.color,
            tangerine.color,
            dolarBill.color,
            crimsionRed.colorContainer,
          ],
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        child: Text(
          'Hello there!',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          .animate(
            onPlay: (controller) => controller.loop(),
          )
          .shimmer(
            delay: 3.seconds,
            duration: 5.seconds,
            curve: Curves.easeInOut,
            size: 8,
            color: theme.colorScheme.secondaryFixed,
          ),
    );
  }
}

class _MessageItem extends HookWidget {
  const _MessageItem({
    required this.message,
    required this.isLastMessage,
  });

  final AiAssistantRequestModel message;
  final bool isLastMessage;

  @override
  Widget build(BuildContext context) {
    final chatBoxSize = context.select(
      (AiAssistantViewCubit cubit) => cubit.state.chatBoxSize,
    );
    double minHeight = 0;
    if (isLastMessage) {
      minHeight = chatBoxSize.height;
    }

    return SizedBox(
      width: double.infinity,
      child: AnimatedSize(
        duration: 210.ms,
        alignment: Alignment.topRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.md,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: _UserMessage(message: message.source),
                ),
                AnimatedSwitcher(
                  duration: 310.ms,
                  layoutBuilder: (currentChild, previousChildren) => Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      if (currentChild != null) currentChild,
                      ...previousChildren,
                    ],
                  ),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: switch (message.status) {
                    AiProcessingStatus.initial => const SizedBox.shrink(),
                    AiProcessingStatus.processing => const _ImThinking(),
                    AiProcessingStatus.completed => _AssistantResponse(
                        response: message.response ??
                            ProcessingResponse(
                              responseText: 'Something went wrong'.hardCoded,
                            ),
                      ),
                    AiProcessingStatus.failed => _AssistantResponse(
                        response: ProcessingResponse(
                          responseText: 'Something went wrong'.hardCoded,
                        ),
                      ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserMessage extends StatelessWidget {
  const _UserMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final maxWidth = mediaQuery.size.width * 0.7;
    return CupertinoContextMenu(
      enableHapticFeedback: true,
      actions: [
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.pop(context);
            Clipboard.setData(ClipboardData(text: message));
          },
          trailingIcon: IconsaxPlusLinear.copy,
          child: Text(
            'Copy'.hardCoded,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
      child: FittedBox(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(AppSpacing.lg),
          ),
          child: Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _AssistantResponse extends HookWidget {
  const _AssistantResponse({
    required this.response,
  });
  final ProcessingResponse response;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedSize(
        alignment: Alignment.topLeft,
        duration: 410.ms,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.md,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _ImThinking.done(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    response.responseText,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              if (response.transactions.isNotEmpty)
                for (final transaction in response.transactions)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.lg),
                    ),
                    child: TransactionItem(
                      transaction: transaction,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImThinking extends StatelessWidget {
  const _ImThinking() : _isDone = false;
  const _ImThinking.done() : _isDone = true;

  final bool _isDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: AppRadius.lg,
          child: Animate(
            autoPlay: !_isDone,
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
        if (!_isDone) ...[
          const SizedBox(width: AppSpacing.md),
          Text(
            'Thinking...'.hardCoded,
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
      ],
    );
  }
}
