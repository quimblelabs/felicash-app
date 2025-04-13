part of 'ai_assistant_view_cubit.dart';

class AiAssistantViewState extends Equatable {
  const AiAssistantViewState({
    this.chatBoxSize = Size.zero,
    this.message = '',
  });

  final Size chatBoxSize;

  /// The current message being typed by the user.
  final String message;

  AiAssistantViewState copyWith({
    Size? chatBoxSize,
    String? message,
  }) {
    return AiAssistantViewState(
      chatBoxSize: chatBoxSize ?? this.chatBoxSize,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [message, chatBoxSize];

  @override
  bool? get stringify => true;
}
