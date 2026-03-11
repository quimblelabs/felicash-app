import 'package:app_ui/app_ui.dart';
import 'package:category_repository/category_repository.dart';
import 'package:felicash/ai_assistant/bloc/ai_assistant_bloc.dart';
import 'package:felicash/ai_assistant/bloc/text_to_speech_bloc.dart';
import 'package:felicash/ai_assistant/cubit/ai_assistant_view_cubit.dart';
import 'package:felicash/ai_assistant/widgets/chat_box.dart';
import 'package:felicash/ai_assistant/widgets/input_box.dart';
import 'package:felicash/category/categories/bloc/categories_bloc.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/voice_transaction/bloc/speech_recognition_bloc.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiAssistantPage extends StatelessWidget {
  const AiAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wallets = context.select<WalletsBloc, List<WalletViewModel>>(
      (bloc) => switch (bloc.state) {
        WalletLoadSuccess(:final wallets) => wallets,
        _ => [],
      },
    );
    final categories = context.select<CategoriesBloc, List<CategoryModel>>(
      (bloc) => switch (bloc.state) {
        CategoriesLoadSuccess(:final categories) => categories,
        _ => [],
      },
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AiAssistantViewCubit()..updateSourceWallet(wallets.firstOrNull),
        ),
        BlocProvider(
          create: (_) => AiAssistantBloc(
            aiClient: context.read(),
            felicashStorageClient: context.read(),
            categoryRepository: context.read(),
            walletRepository: context.read(),
            transactionRepository: context.read(),
          )..add(
              AiAssistantLoadResourceRequested(
                walletsParameter: wallets.map((e) => e.wallet).toList(),
                categoriesParameter: categories,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => SpeechRecognitionBloc(
            speechToTextClient: context.read(),
            walletRepository: context.read(),
            categoryRepository: context.read(),
          )..add(SpeechRecognitionClientStarted()),
        ),
        BlocProvider(
          create: (context) => TextToSpeechBloc(
            textToSpeechClient: context.read(),
          ),
        ),
      ],
      child: const _AiAssistantView(),
    );
  }
}

class _AiAssistantView extends StatelessWidget {
  const _AiAssistantView();

  @override
  Widget build(BuildContext context) {
    return _WalledLoadedSuccess(
      child: _ListenForUserSpeechDone(
        child: _AiAssistantProcessUpdated(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: AppBar(
                title: const _AiAssistantModeSelector(),
              ),
              body: const Column(
                children: [
                  Expanded(child: ChatBox()),
                  InputBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ListenForUserSpeechDone extends StatelessWidget {
  const _ListenForUserSpeechDone({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<SpeechRecognitionBloc, SpeechRecognitionState>(
      listenWhen: (previous, current) =>
          current is SpeechRecognitionListeningSuccess ||
          current is SpeechRecognitionPausedSuccess,
      listener: (context, state) {
        if (state is SpeechRecognitionListeningSuccess) {
          final text = state.recognizedText;
          if (text.trim().isEmpty) return;
          final sourceWallet =
              context.read<AiAssistantViewCubit>().state.sourceWallet;
          if (sourceWallet == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.aiAssistantPageNoSourceWalletFoundErrorMessage,
                ),
              ),
            );
          }
          context.read<AiAssistantBloc>().add(
                AiAssistantStartProcessing(
                  mode: context.read<AiAssistantViewCubit>().state.mode,
                  requestMessage: text,
                  sourceWallet: sourceWallet!.wallet,
                ),
              );
        }
      },
      child: child,
    );
  }
}

class _AiAssistantProcessUpdated extends StatelessWidget {
  const _AiAssistantProcessUpdated({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AiAssistantBloc, AiAssistantState>(
      listenWhen: (previous, current) =>
          current is AiAssistantCompleted || current is AiAssistantInProgress,
      listener: (context, state) {
        if (state is AiAssistantCompleted) {
          final text = state.process.response?.responseText;
          if (text == null) return;
          if (text.trim().isEmpty) return;
          context.read<TextToSpeechBloc>().add(SpeechToTextStarted(text: text));
        } else if (state is AiAssistantInProgress) {
          context.read<TextToSpeechBloc>().add(const SpeechToTextStopped());
        }
      },
      child: child,
    );
  }
}

class _WalledLoadedSuccess extends StatelessWidget {
  const _WalledLoadedSuccess({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletsBloc, WalletsState>(
      listenWhen: (previous, current) => current is WalletLoadSuccess,
      listener: (context, state) {
        if (state is WalletLoadSuccess) {
          final cubit = context.read<AiAssistantViewCubit>();
          if (cubit.state.sourceWallet == null) {
            cubit.updateSourceWallet(state.wallets.firstOrNull);
          }
        }
      },
      child: child,
    );
  }
}

class _AiAssistantModeSelector extends StatelessWidget {
  const _AiAssistantModeSelector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mode = context.select<AiAssistantViewCubit, AiAssistantMode>(
      (cubit) => cubit.state.mode,
    );

    return PopupMenuButton(
      clipBehavior: Clip.antiAlias,
      offset: const Offset(-24, 0),
      initialValue: mode,
      itemBuilder: (context) {
        return AiAssistantMode.values
            .map(
              (mode) => PopupMenuItem<AiAssistantMode>(
                value: mode,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mode.getLocalizedName(context),
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        mode.getIcon(),
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList();
      },
      onSelected: (mode) {
        context.read<AiAssistantViewCubit>().updateMode(mode);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            mode.getLocalizedName(context),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Icon(
            Icons.chevron_right,
            color: theme.hintColor,
          ),
        ],
      ),
    );
  }
}

extension on AiAssistantMode {
  String getLocalizedName(BuildContext context) {
    // final l10n = context.l10n;
    switch (this) {
      case AiAssistantMode.transaction:
        return 'Transaction'.hardCoded;
      // return context.l10n.aiAssistantPageTransactionMode;
      case AiAssistantMode.assistant:
        return 'Assistant'.hardCoded;
      // return context.l10n.aiAssistantPageCategoryMode;
    }
  }

  IconData getIcon() {
    switch (this) {
      case AiAssistantMode.transaction:
        return Icons.monetization_on;
      case AiAssistantMode.assistant:
        return Icons.chat;
    }
  }
}
