import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'ai_assistant_view_state.dart';

class AiAssistantViewCubit extends Cubit<AiAssistantViewState> {
  AiAssistantViewCubit() : super(const AiAssistantViewState());

  void updateChatBoxSize(Size chatBoxSize) {
    emit(state.copyWith(chatBoxSize: chatBoxSize));
  }

  void updateMessage(String message) {
    emit(state.copyWith(message: message));
  }

  void updateSourceWallet(BaseWalletModel? sourceWallet) {
    emit(state.copyWith(sourceWallet: sourceWallet));
  }
}
