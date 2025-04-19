import 'package:app_ui/app_ui.dart';
import 'package:category_repository/category_repository.dart';
import 'package:felicash/ai_assistant/bloc/ai_assistant_bloc.dart';
import 'package:felicash/ai_assistant/cubit/ai_assistant_view_cubit.dart';
import 'package:felicash/voice_transaction/bloc/speech_recognition_bloc.dart';
import 'package:felicash/voice_transaction/view/speech_recognition_permission_modal.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:felicash/wallet_selector/view/wallet_selector_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:permission_client/permission_client.dart';
import 'package:shared_models/shared_models.dart';
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
                      AppSpacing.sm,
                      0,
                      AppSpacing.xxs,
                      AppSpacing.xxs,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
              current is SpeechRecognitionListeningInProgress,
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
              ? 'Listening'.hardCoded
              : 'Describe your transaction'.hardCoded,
          filled: false,
        ),
      ),
    );
  }
}

class _WalletSelector extends StatelessWidget {
  const _WalletSelector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inProcessing = context.select(
      (AiAssistantBloc bloc) =>
          bloc.state is SpeechRecognitionListeningInProgress,
    );

    final onPressed = inProcessing ? null : () => _onPressed(context);

    return ActionChip(
      labelStyle: theme.textTheme.labelMedium,
      labelPadding: const EdgeInsets.only(left: AppSpacing.md),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text('Wallet 1'.hardCoded),
          ),
          const SizedBox(width: AppSpacing.md),
          const Icon(
            Icons.arrow_drop_down,
            size: 16,
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }

  void _onPressed(BuildContext context) {
    final result = showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => const WalletSelectorModal(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    final messageNotEmpty = context.select(
      (AiAssistantViewCubit cubit) => cubit.state.message.isNotEmpty,
    );
    final voiceInputEnabled = context.select<SpeechRecognitionBloc, bool>(
      (cubit) => cubit.state is SpeechRecognitionListeningInProgress,
    );
    final inProgressing = context.select<AiAssistantBloc, bool>(
      (bloc) => bloc.state is AiAssistantInProgress,
    );
    var icon = IconsaxPlusBold.microphone_2;
    if (voiceInputEnabled) {
      icon = Icons.stop_rounded;
    } else if (inProgressing) {
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
          if (voiceInputEnabled) {
            _stopVoiceInput(context);
          } else if (inProgressing) {
            _cancelProcessing(context);
          } else if (message.isNotEmpty) {
            _submitMessage(context);
          } else {
            _startVoiceInput(context);
          }
        },
        // icon: const Icon(IconsaxPlusBold.send_1),
        icon: Icon(icon),
      ),
    );
  }

  void _stopVoiceInput(BuildContext context) {
    context
        .read<SpeechRecognitionBloc>()
        .add(const SpeechRecognitionStopListeningRequested());
  }

  void _cancelProcessing(BuildContext context) {
    context.read<AiAssistantBloc>().add(AiAssistantCancelProcessing());
  }

  void _submitMessage(BuildContext context) {
    final message = context.read<AiAssistantViewCubit>().state.message;
    final wallets = context.select<WalletsBloc, List<BaseWalletModel>>(
      (bloc) => switch (bloc.state) {
        WalletLoadSuccess(:final wallets) => wallets,
        _ => [],
      },
    );
    if (wallets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No wallets found'.hardCoded),
        ),
      );
      return;
    }
    // TODO(dangddt): Get categories,
    final categories = <CategoryModel>[];
    // TODO(dangddt): Get transaction types,
    final transactionTypes = <TransactionTypeEnum>[];
    // TODO(dangddt): Get source wallet,
    const sourceWallet = null as BaseWalletModel?;
    if (sourceWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No source wallet found'.hardCoded),
        ),
      );
    }
    // Send message
    FocusScope.of(context).unfocus();
    context.read<AiAssistantBloc>().add(
          AiAssistantStartProcessing(
            requestMessage: message,
            walletsParameter: wallets,
            categoriesParameter: categories,
            transactionTypesParameter: transactionTypes,
            sourceWallet: sourceWallet!,
          ),
        );
    context.read<AiAssistantViewCubit>().updateMessage('');
  }

  Future<void> _startVoiceInput(BuildContext context) async {
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
