part of 'transaction_form_bloc.dart';

enum TransactionMode { create, edit }

enum TransactionFormStatus {
  initial,
  loading,
  submitting,
  success,
  deleting,
  deleted,
  error
}

class TransactionFormState extends Equatable {
  const TransactionFormState({
    required this.wallet,
    this.transactionId,
    this.mode = TransactionMode.create,
    this.type = TransactionTypeEnum.expense,
    this.amount = const TransactionMonetaryAmount.pure(),
    this.category,
    this.date,
    this.note = const TransactionNote.pure(),
    this.transferToWallet,
    this.isValid = false,
    this.isDirty = false,
    this.status = TransactionFormStatus.initial,
    this.errorMessage,
  });

  final String? transactionId;
  final TransactionMode mode;
  final TransactionTypeEnum type;
  final WalletViewModel? wallet;
  final TransactionMonetaryAmount amount;
  final CategoryModel? category;
  final DateTime? date;
  final TransactionNote note;
  final WalletViewModel? transferToWallet;
  final bool isValid;
  final bool isDirty;
  final TransactionFormStatus status;
  final String? errorMessage;

  TransactionFormState copyWith({
    String? transactionId,
    TransactionMode? mode,
    TransactionTypeEnum? type,
    WalletViewModel? wallet,
    TransactionMonetaryAmount? amount,
    CategoryModel? category,
    DateTime? date,
    TransactionNote? note,
    WalletViewModel? transferToWallet,
    bool? isValid,
    bool? isDirty,
    TransactionFormStatus? status,
    String? errorMessage,
  }) {
    return TransactionFormState(
      transactionId: transactionId ?? this.transactionId,
      mode: mode ?? this.mode,
      type: type ?? this.type,
      wallet: wallet ?? this.wallet,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      transferToWallet: transferToWallet ?? this.transferToWallet,
      isValid: isValid ?? this.isValid,
      isDirty: isDirty ?? this.isDirty,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        transactionId,
        mode,
        type,
        wallet,
        amount,
        category,
        date,
        note,
        transferToWallet,
        isValid,
        isDirty,
        status,
        errorMessage,
      ];
}
