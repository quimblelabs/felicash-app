part of 'ai_assistant_bloc.dart';

sealed class AiAssistantEvent extends Equatable {
  const AiAssistantEvent();

  @override
  List<Object?> get props => [];
}

class AiAssistantLoadResourceRequested extends AiAssistantEvent {
  const AiAssistantLoadResourceRequested({
    this.walletsParameter = const [],
    this.categoriesParameter = const [],
  });

  final List<BaseWalletModel> walletsParameter;
  final List<CategoryModel> categoriesParameter;

  @override
  List<Object?> get props => [
        ...super.props,
        walletsParameter,
        categoriesParameter,
      ];
}

class AiAssistantStartProcessing extends AiAssistantEvent {
  const AiAssistantStartProcessing({
    required this.requestMessage,
    required this.sourceWallet,
  });
  final String requestMessage;

  final BaseWalletModel sourceWallet;

  @override
  List<Object?> get props => [
        ...super.props,
        requestMessage,
        sourceWallet,
      ];
}

/// Cancel the current transaction processing
class AiAssistantCancelProcessing extends AiAssistantEvent {}

/// Reset the transaction processing state to initial state
///
/// If [keepHistory] is true, the history will be kept
/// otherwise the history will be cleared
class AiAssistantReset extends AiAssistantEvent {
  const AiAssistantReset({
    this.keepHistory = false,
  });
  final bool keepHistory;
  @override
  List<Object?> get props => [...super.props, keepHistory];
}
