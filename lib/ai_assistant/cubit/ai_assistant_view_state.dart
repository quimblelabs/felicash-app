part of 'ai_assistant_view_cubit.dart';

enum AiAssistantMode {
  /// The assistant is in assistant mode.
  ///
  /// In this mode, the assistant will respond to user messages with
  /// text-based answers. Helpful for general inquiries.
  assistant,

  /// The assistant is in transaction mode.
  ///
  /// In this mode, the assistant will respond to user messages with
  /// transaction-related answers. Helpful for transaction-related inquiries.
  transaction,
}

class AiAssistantViewState extends Equatable {
  const AiAssistantViewState({
    this.chatBoxSize = Size.zero,
    this.mode = AiAssistantMode.transaction,
    this.message = '',
    this.sourceWallet,
  });

  /// The size of the chat box.
  final Size chatBoxSize;

  /// The current message being typed by the user.
  final String message;

  final AiAssistantMode mode;

  /// The current wallet selected by the user.
  final WalletViewModel? sourceWallet;

  AiAssistantViewState copyWith({
    Size? chatBoxSize,
    AiAssistantMode? mode,
    String? message,
    WalletViewModel? sourceWallet,
  }) {
    return AiAssistantViewState(
      chatBoxSize: chatBoxSize ?? this.chatBoxSize,
      mode: mode ?? this.mode,
      message: message ?? this.message,
      sourceWallet: sourceWallet ?? this.sourceWallet,
    );
  }

  @override
  List<Object?> get props => [message, chatBoxSize, sourceWallet, mode];

  @override
  bool? get stringify => true;
}
