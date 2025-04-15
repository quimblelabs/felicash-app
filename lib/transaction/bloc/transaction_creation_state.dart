part of 'transaction_creation_bloc.dart';

class TransactionCreationState extends Equatable {
  const TransactionCreationState({
    required this.wallet,
    this.type = TransactionTypeEnum.expense,
    this.amount = const MonetaryAmount.pure(),
    this.category,
    this.date,
    this.note = const TransactionNote.pure(),
    this.transferToWallet,
    this.isValid = false,
  });

  final TransactionTypeEnum type;

  /// The wallet that the transaction is going to be created for.
  final BaseWalletModel? wallet;
  final MonetaryAmount amount;
  final CategoryModel? category;
  final DateTime? date;
  final TransactionNote note;

  // Transfers
  /// The wallet that the transaction is going to be created for.
  final BaseWalletModel? transferToWallet;

  final bool isValid;

  TransactionCreationState copyWith({
    TransactionTypeEnum? type,
    BaseWalletModel? wallet,
    MonetaryAmount? amount,
    CategoryModel? category,
    DateTime? date,
    TransactionNote? note,
    BaseWalletModel? transferToWallet,
    bool? isValid,
  }) {
    return TransactionCreationState(
      type: type ?? this.type,
      wallet: wallet ?? this.wallet,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      transferToWallet: transferToWallet ?? this.transferToWallet,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [
        type,
        wallet,
        amount,
        category,
        date,
        note,
        transferToWallet,
        isValid,
      ];
}
