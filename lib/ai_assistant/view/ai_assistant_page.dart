import 'package:app_ui/app_ui.dart';
import 'package:category_repository/category_repository.dart';
import 'package:felicash/ai_assistant/bloc/ai_assistant_bloc.dart';
import 'package:felicash/ai_assistant/cubit/ai_assistant_view_cubit.dart';
import 'package:felicash/ai_assistant/widgets/chat_box.dart';
import 'package:felicash/ai_assistant/widgets/input_box.dart';
import 'package:felicash/voice_transaction/bloc/speech_recognition_bloc.dart';
import 'package:felicash/wallet/bloc/wallets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

class AiAssistantPage extends StatelessWidget {
  const AiAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AiAssistantViewCubit()),
        BlocProvider(
          create: (_) => AiAssistantBloc(
            aiClient: context.read(),
          ),
        ),
        BlocProvider(
          create: (context) => SpeechRecognitionBloc(
            speechToTextClient: context.read(),
          )..add(SpeechRecognitionClientStarted()),
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
    return _ListenForUserSpeechDone(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('AI Assistant'),
          ),
          body: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: const Column(
              children: [
                Expanded(child: ChatBox()),
                InputBox(),
              ],
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
    return BlocListener<SpeechRecognitionBloc, SpeechRecognitionState>(
      listenWhen: (previous, current) =>
          current is SpeechRecognitionListeningSuccess,
      listener: (context, state) {
        if (state is SpeechRecognitionListeningSuccess) {
          final text = state.recognizedText;
          if (text.trim().isEmpty) return;
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
          context.read<AiAssistantBloc>().add(
                AiAssistantStartProcessing(
                  requestMessage: text,
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
