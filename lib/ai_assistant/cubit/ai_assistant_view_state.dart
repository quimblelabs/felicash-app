part of 'ai_assistant_view_cubit.dart';

class AiAssistantViewState extends Equatable {
  const AiAssistantViewState({
    this.chatBoxSize = Size.zero,
    this.message = '',
    this.sourceWallet,
  });

  /// The size of the chat box.
  final Size chatBoxSize;

  /// The current message being typed by the user.
  final String message;

  /// The current wallet selected by the user.
  final WalletViewModel? sourceWallet;

  AiAssistantViewState copyWith({
    Size? chatBoxSize,
    String? message,
    WalletViewModel? sourceWallet,
  }) {
    return AiAssistantViewState(
      chatBoxSize: chatBoxSize ?? this.chatBoxSize,
      message: message ?? this.message,
      sourceWallet: sourceWallet ?? this.sourceWallet,
    );
  }

  @override
  List<Object?> get props => [message, chatBoxSize, sourceWallet];

  @override
  bool? get stringify => true;
}
