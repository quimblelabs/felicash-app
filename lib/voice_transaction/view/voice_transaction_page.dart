import 'package:app_ui/app_ui.dart';
import 'package:category_repository/category_repository.dart';
import 'package:felicash/ai_assistant/bloc/ai_assistant_bloc.dart';
import 'package:felicash/voice_transaction/bloc/speech_recognition_bloc.dart';
import 'package:felicash/voice_transaction/cubit/speech_language_cubit.dart';
import 'package:felicash/voice_transaction/widgets/voice_transaction_bottom_buttons.dart';
import 'package:felicash/voice_transaction/widgets/voice_transaction_result_view.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

class VoiceTransactionPage extends StatelessWidget {
  const VoiceTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SpeechRecognitionBloc(
            speechToTextClient: context.read(),
          )..add(SpeechRecognitionClientStarted()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => SpeechLanguageCubit(
            speechToTextClient: context.read(),
          )..loadLanguages(),
        ),
        BlocProvider(
          create: (context) => AiAssistantBloc(
            aiClient: context.read(),
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
        if (state case final SpeechRecognitionListeningSuccess successState) {
          final recognizedText = successState.recognizedText;
          if (recognizedText.isEmpty) return;
          context
              .read<SpeechRecognitionBloc>()
              .add(const SpeechRecognitionStopListeningRequested());
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
          context.read<AiAssistantBloc>().add(
                AiAssistantStartProcessing(
                  requestMessage: recognizedText,
                  walletsParameter: wallets,
                  categoriesParameter: categories,
                  transactionTypesParameter: transactionTypes,
                  sourceWallet: sourceWallet!,
                ),
              );
        }
      },
      child: child,
    );
  }
}
