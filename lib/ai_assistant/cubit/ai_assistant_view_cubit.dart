import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';

part 'ai_assistant_view_state.dart';

class AiAssistantViewCubit extends Cubit<AiAssistantViewState> {
  AiAssistantViewCubit() : super(const AiAssistantViewState());

  void updateChatBoxSize(Size chatBoxSize) {
    emit(state.copyWith(chatBoxSize: chatBoxSize));
  }

  void updateMessage(String message) {
    emit(state.copyWith(message: message));
  }

  void updateSourceWallet(WalletViewModel? sourceWallet) {
    emit(state.copyWith(sourceWallet: sourceWallet));
  }
}
