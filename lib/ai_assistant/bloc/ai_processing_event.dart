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
    this.images = const [],
  });

  final String requestMessage;
  final List<String> images;

  final BaseWalletModel sourceWallet;

  @override
  List<Object?> get props => [
        ...super.props,
        requestMessage,
        sourceWallet,
        images,
      ];
}

class AiAssistantRetryProcess extends AiAssistantEvent {
  const AiAssistantRetryProcess({
    required this.sourceWallet,
    required this.processId,
  });
  final BaseWalletModel sourceWallet;
  final String processId;

  @override
  List<Object?> get props => [...super.props, processId, sourceWallet];
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
