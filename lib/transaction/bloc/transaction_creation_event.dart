part of 'transaction_creation_bloc.dart';

sealed class TransactionCreationEvent extends Equatable {
  const TransactionCreationEvent();

  @override
  List<Object?> get props => [];
}

class TransactionCreationTypeChanged extends TransactionCreationEvent {
  const TransactionCreationTypeChanged(this.type);
  final TransactionTypeEnum type;
  @override
  List<Object> get props => [type];
}

class TransactionCreationWalletChanged extends TransactionCreationEvent {
  const TransactionCreationWalletChanged({
    this.wallet,
    this.id,
  }) : assert(
          wallet != null || id != null,
          'Either wallet or walletId must be provided',
        );

  final WalletViewModel? wallet;
  final String? id;

  @override
  List<Object?> get props => [wallet];
}

class TransactionCreationAmountChanged extends TransactionCreationEvent {
  const TransactionCreationAmountChanged(this.amount);
  final double amount;
  @override
  List<Object> get props => [amount];
}

class TransactionCreationCategoryChanged extends TransactionCreationEvent {
  const TransactionCreationCategoryChanged(this.category);
  final CategoryModel category;
  @override
  List<Object> get props => [category];
}

class TransactionCreationDateChanged extends TransactionCreationEvent {
  const TransactionCreationDateChanged(this.date);
  final DateTime date;
  @override
  List<Object> get props => [date];
}

class TransactionCreationNoteChanged extends TransactionCreationEvent {
  const TransactionCreationNoteChanged(this.note);
  final String note;
  @override
  List<Object> get props => [note];
}

class TransactionCreationTransferToWalletChanged
    extends TransactionCreationEvent {
  const TransactionCreationTransferToWalletChanged(this.wallet);
  final WalletViewModel wallet;
  @override
  List<Object> get props => [wallet];
}
