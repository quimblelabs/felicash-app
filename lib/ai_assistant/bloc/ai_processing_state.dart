part of 'ai_assistant_bloc.dart';

sealed class AiAssistantState extends Equatable {
  const AiAssistantState(this.history);
  final List<AiAssistantRequestModel> history;
  @override
  List<Object?> get props => [history];
}

class AiAssistantInitial extends AiAssistantState {
  const AiAssistantInitial([
    super.history = const [],
  ]);
}

class AiAssistantStarted extends AiAssistantState {
  const AiAssistantStarted({
    required List<AiAssistantRequestModel> history,
  }) : super(history);
}

class AiAssistantInProgress extends AiAssistantState {
  const AiAssistantInProgress({
    required List<AiAssistantRequestModel> history,
  }) : super(history);
}

class AiAssistantCompleted extends AiAssistantState {
  const AiAssistantCompleted({
    required this.process,
    required List<AiAssistantRequestModel> history,
  }) : super(history);
  final AiAssistantRequestModel process;

  @override
  List<Object?> get props => [process, ...super.props];
}

class AiAssistantFailed extends AiAssistantState {
  const AiAssistantFailed({
    required this.process,
    required List<AiAssistantRequestModel> history,
  }) : super(history);
  final AiAssistantRequestModel process;

  @override
  List<Object?> get props => [process, ...super.props];
}

class AiAssistantCancelled extends AiAssistantState {
  const AiAssistantCancelled({
    required List<AiAssistantRequestModel> history,
  }) : super(history);
}
