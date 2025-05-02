import 'package:category_repository/category_repository.dart';
import 'package:felicash/ai_assistant/bloc/ai_assistant_bloc.dart';
import 'package:felicash/category/categories/bloc/categories_bloc.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/voice_transaction/bloc/speech_recognition_bloc.dart';
import 'package:felicash/voice_transaction/cubit/speech_language_cubit.dart';
import 'package:felicash/voice_transaction/widgets/voice_transaction_bottom_buttons.dart';
import 'package:felicash/voice_transaction/widgets/voice_transaction_result_view.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceTransactionPage extends StatelessWidget {
  const VoiceTransactionPage({super.key});

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
          create: (context) => SpeechRecognitionBloc(
            speechToTextClient: context.read(),
            walletRepository: context.read(),
            categoryRepository: context.read(),
          )
            ..add(
              SpeechRecognitionLoadResourceRequested(
                walletsParameter: wallets.map((e) => e.wallet).toList(),
                categoriesParameter: categories,
              ),
            )
            ..add(SpeechRecognitionClientStarted()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => SpeechLanguageCubit(
            speechToTextClient: context.read(),
          )..loadLanguages(),
        ),
        BlocProvider(
          create: (context) => AiAssistantBloc(
            felicashStorageClient: context.read(),
            aiClient: context.read(),
            walletRepository: context.read(),
            categoryRepository: context.read(),
            transactionRepository: context.read(),
          )..add(
              AiAssistantLoadResourceRequested(
                walletsParameter: wallets.map((e) => e.wallet).toList(),
                categoriesParameter: categories,
              ),
            ),
        ),
      ],
      child: const _VoiceTransactionView(),
    );
  }
}

class _VoiceTransactionView extends StatelessWidget {
  const _VoiceTransactionView();

  @override
  Widget build(BuildContext context) {
    // TODO(tuanhm): Handle error state (e.g. client not ready
    // or errors when listening)
    return _ListenForSpeechClientReady(
      child: _ListenForUserSpeechCompleted(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Voice Transaction'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.history_rounded),
              ),
            ],
          ),
          body: const SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: VoiceTransactionResultView()),
                VoiceTransactionBottomButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListenForSpeechClientReady extends StatelessWidget {
  const _ListenForSpeechClientReady({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpeechRecognitionBloc, SpeechRecognitionState>(
      listenWhen: (previous, current) {
        if (previous == current) return false;
        return current is SpeechRecognitionReady;
      },
      listener: (context, state) {
        context
            .read<SpeechRecognitionBloc>()
            .add(const SpeechRecognitionStartListeningRequested());
      },
      child: child,
    );
  }
}

class _ListenForUserSpeechCompleted extends StatelessWidget {
  const _ListenForUserSpeechCompleted({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<SpeechRecognitionBloc, SpeechRecognitionState>(
      listenWhen: (previous, current) {
        if (previous == current) return false;
        if (current is! SpeechRecognitionListeningSuccess) return false;
        return current.recognizedText.isNotEmpty;
      },
      listener: (context, state) {
        final l10n = context.l10n;
        if (state case final SpeechRecognitionListeningSuccess successState) {
          final recognizedText = successState.recognizedText;
          if (recognizedText.isEmpty) return;
          context
              .read<SpeechRecognitionBloc>()
              .add(const SpeechRecognitionStopListeningRequested());
          // TODO(tuanhm): Get the source wallet from the current state
          const sourceWallet = null as WalletViewModel?;
          if (sourceWallet == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.voiceTransactionPageNoSourceWalletFoundErrorMessage,
                ),
              ),
            );
          }
          context.read<AiAssistantBloc>().add(
                AiAssistantStartProcessing(
                  requestMessage: recognizedText,
                  sourceWallet: sourceWallet!.wallet,
                ),
              );
        }
      },
      child: child,
    );
  }
}
