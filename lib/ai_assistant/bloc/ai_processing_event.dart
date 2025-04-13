part of 'ai_assistant_bloc.dart';

sealed class AiAssistantEvent extends Equatable {
  const AiAssistantEvent();

  @override
  List<Object> get props => [];
}

class AiAssistantStartProcessing extends AiAssistantEvent {
  const AiAssistantStartProcessing(this.requestMessage);
  final String requestMessage;

  @override
  List<Object> get props => [requestMessage, ...super.props];
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
  List<Object> get props => [keepHistory, ...super.props];
}
