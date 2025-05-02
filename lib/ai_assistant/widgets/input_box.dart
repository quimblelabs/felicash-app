import 'package:app_ui/app_ui.dart';
import 'package:felicash/ai_assistant/bloc/ai_assistant_bloc.dart';
import 'package:felicash/ai_assistant/cubit/ai_assistant_view_cubit.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/voice_transaction/bloc/speech_recognition_bloc.dart';
import 'package:felicash/voice_transaction/view/speech_recognition_permission_modal.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:felicash/wallet/view/wallet_selector/wallet_selector_modal.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:permission_client/permission_client.dart';
import 'package:wallet_repository/wallet_repository.dart';

class InputBox extends StatelessWidget {
  const InputBox({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 40,
            spreadRadius: 4,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.lg),
          topRight: Radius.circular(AppSpacing.lg),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SafeArea(
          top: false,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: const BorderRadius.all(
                Radius.circular(AppSpacing.lg),
              ),
            ),
            child: const AnimatedSize(
              duration: Duration(milliseconds: 210),
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TextInput(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      0,
                      AppSpacing.xxs,
                      AppSpacing.xxs,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _AttachmentSelector(),
                        _WalletSelector(),
                        Spacer(),
                        _ActionButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextInput extends HookWidget {
  const _TextInput();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final inputScrollController = useScrollController();
    final inputTextEditingController = useTextEditingController();
    final isListening = context.select<SpeechRecognitionBloc, bool>(
      (cubit) => cubit.state is SpeechRecognitionListeningInProgress,
    );
    final inProgressing = context.select<AiAssistantBloc, bool>(
      (bloc) => bloc.state is AiAssistantInProgress,
    );
    return MultiBlocListener(
      listeners: [
        BlocListener<AiAssistantBloc, AiAssistantState>(
          listenWhen: (previous, current) =>
              previous is! AiAssistantInProgress &&
              current is AiAssistantInProgress,
          listener: (context, state) {
            inputTextEditingController.text = '';
          },
        ),
        BlocListener<SpeechRecognitionBloc, SpeechRecognitionState>(
          listenWhen: (previous, current) =>
              current is SpeechRecognitionListeningInProgress ||
              current is SpeechRecognitionPausedSuccess,
          listener: (context, state) {
            if (state is SpeechRecognitionListeningInProgress) {
              inputTextEditingController.text = state.recognizedText;
              if (inputScrollController.hasClients) {
                inputScrollController.animateTo(
                  inputScrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 210),
                  curve: Curves.easeInOut,
                );
              }
            }
            if (state is SpeechRecognitionPausedSuccess) {
              inputTextEditingController.text = '';
            }
          },
        ),
      ],
      child: TextFormField(
        scrollController: inputScrollController,
        controller: inputTextEditingController,
        onChanged: context.read<AiAssistantViewCubit>().updateMessage,
        ignorePointers: isListening || inProgressing,
        readOnly: isListening || inProgressing,
        maxLines: 4,
        minLines: 1,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            0,
          ),
          hintText: isListening
              ? l10n.inputBoxListeningHintText
              : l10n.inputBoxDescribeTransactionHintText,
          filled: false,
        ),
      ),
    );
  }
}

class _AttachmentSelector extends StatelessWidget {
  const _AttachmentSelector();

  @override
  Widget build(BuildContext context) {
    final inProcessing = context.select(
      (AiAssistantBloc bloc) =>
          bloc.state is SpeechRecognitionListeningInProgress,
    );
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      child: ActionChip(
        // visualDensity: VisualDensity.compact,
        labelPadding: EdgeInsets.zero,
        onPressed: inProcessing
            ? null
            : () async {
                final sourceWallet =
                    context.read<AiAssistantViewCubit>().state.sourceWallet;
                if (sourceWallet == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.l10n
                            .aiAssistantPageNoSourceWalletFoundErrorMessage,
                      ),
                    ),
                  );
                  return;
                }
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  compressionQuality: 40,
                );
                if (result == null) return;
                if (result.files.isEmpty) return;
                final file = result.files.first;
                if (file.path == null) return;
                final filePath = file.path!;
                if (!context.mounted) return;
                context.read<AiAssistantBloc>().add(
                      AiAssistantStartProcessing(
                        requestMessage: '',
                        images: [filePath],
                        sourceWallet: sourceWallet.wallet,
                      ),
                    );
              },
        label: const Icon(
          IconsaxPlusLinear.add,
          size: 16,
        ),
      ),
    );
  }
}

class _WalletSelector extends StatelessWidget {
  const _WalletSelector();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final cubit = context.read<AiAssistantViewCubit>();
    final walletsBloc = context.read<WalletsBloc>();
    final sourceWallet = context.select<AiAssistantViewCubit, WalletViewModel?>(
      (cubit) => cubit.state.sourceWallet,
    );
    final state =
        context.select<WalletsBloc, WalletsState>((bloc) => bloc.state);
    final inProcessing = context.select(
      (AiAssistantBloc bloc) =>
          bloc.state is SpeechRecognitionListeningInProgress,
    );

    return switch (state) {
      WalletInitial() => const SizedBox.shrink(),
      WalletLoadInProgress(:final messageText) => Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(messageText),
              const SizedBox(width: AppSpacing.md),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator.adaptive(),
              ),
            ],
          ),
        ),
      WalletLoadSuccess(:final wallets) => ActionChip(
          labelStyle: theme.textTheme.labelMedium,
          labelPadding: const EdgeInsets.only(left: AppSpacing.md),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(sourceWallet?.wallet.name ?? ''),
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(
                Icons.arrow_drop_down,
                size: 16,
              ),
            ],
          ),
          onPressed: inProcessing
              ? null
              : () async {
                  final result = await showModalBottomSheet<WalletViewModel?>(
                    context: context,
                    isScrollControlled: true,
                    useRootNavigator: true,
                    builder: (_) => WalletSelectorModal(
                      title: l10n.inputBoxSelectorModalTitle,
                      wallets: wallets.toList(),
                      initialWallet: sourceWallet,
                    ),
                  );
                  if (result != null) {
                    cubit.updateSourceWallet(result);
                  }
                },
        ),
      WalletLoadFailure(:final messageText, :final previousQuery) => Row(
          children: [
            Text(
              messageText,
            ),
            IconButton(
              onPressed: () {
                walletsBloc
                    .add(WalletsSubscriptionRequested(query: previousQuery));
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
    };
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    final messageNotEmpty = context.select(
      (AiAssistantViewCubit cubit) => cubit.state.message.isNotEmpty,
    );
    final isListening = context.select<SpeechRecognitionBloc, bool>(
      (cubit) => cubit.state is SpeechRecognitionListeningInProgress,
    );
    final inProgressing = context.select<AiAssistantBloc, bool>(
      (bloc) => bloc.state is AiAssistantInProgress,
    );
    var icon = IconsaxPlusBold.microphone_2;
    if (isListening || inProgressing) {
      icon = Icons.stop_rounded;
    } else if (messageNotEmpty) {
      icon = IconsaxPlusBold.send_1;
    }
    return AnimatedSwitcher(
      reverseDuration: const Duration(milliseconds: 210),
      duration: const Duration(milliseconds: 210),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
      child: IconButton.filled(
        key: ValueKey(icon),
        onPressed: () {
          HapticFeedback.lightImpact();
          final message = context.read<AiAssistantViewCubit>().state.message;
          if (isListening) {
            stopVoiceInput(context);
          } else if (inProgressing) {
            cancelProcessing(context);
          } else if (message.isNotEmpty) {
            submitMessage(context);
          } else {
            startVoiceInput(context);
          }
        },
        // icon: const Icon(IconsaxPlusBold.send_1),
        icon: Icon(icon),
      ),
    );
  }

  void stopVoiceInput(BuildContext context) {
    context
        .read<SpeechRecognitionBloc>()
        .add(const SpeechRecognitionStopListeningRequested());
  }

  void cancelProcessing(BuildContext context) {
    context.read<AiAssistantBloc>().add(AiAssistantCancelProcessing());
  }

  void submitMessage(
    BuildContext context,
  ) {
    final l10n = context.l10n;
    // Message
    final message = context.read<AiAssistantViewCubit>().state.message;

    // Wallets
    final wallets = switch (context.read<WalletsBloc>().state) {
      WalletLoadSuccess(:final wallets) => wallets,
      _ => <BaseWalletModel>[],
    };

    if (wallets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.inputBoxNoWalletFoundErrorMessage),
          showCloseIcon: true,
        ),
      );
      return;
    }

    // Source wallet
    final sourceWallet =
        context.read<AiAssistantViewCubit>().state.sourceWallet;
    if (sourceWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.inputBoxNoSourceWalletFoundErrorMessage),
          showCloseIcon: true,
        ),
      );
      return;
    }

    // Send message
    FocusScope.of(context).unfocus();
    context.read<AiAssistantBloc>().add(
          AiAssistantStartProcessing(
            requestMessage: message,
            sourceWallet: sourceWallet.wallet,
          ),
        );
    context.read<AiAssistantViewCubit>().updateMessage('');
  }

  Future<void> startVoiceInput(BuildContext context) async {
    const permissionClient = PermissionClient();
    final micPermission = await permissionClient.microphoneStatus();
    final speechRecognitionPermission =
        await permissionClient.speechRecognitionStatus();
    if (!context.mounted) return;
    if (!micPermission.isGranted || !speechRecognitionPermission.isGranted) {
      await showModalBottomSheet<bool?>(
        context: context,
        builder: (context) => const SpeechRecognitionPermissionModal(),
      );
    } else {
      context
          .read<SpeechRecognitionBloc>()
          .add(const SpeechRecognitionStartListeningRequested());
    }
  }
}
