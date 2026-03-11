part of 'transaction_form_bloc.dart';

sealed class TransactionFormEvent extends Equatable {
  const TransactionFormEvent();

  @override
  List<Object?> get props => [];
}

class TransactionFormTypeChanged extends TransactionFormEvent {
  const TransactionFormTypeChanged(this.type);

  final TransactionTypeEnum type;

  @override
  List<Object> get props => [type];
}

class TransactionFormWalletChanged extends TransactionFormEvent {
  const TransactionFormWalletChanged({
    this.wallet,
    this.id,
  }) : assert(
          wallet != null || id != null,
          'Either wallet or walletId must be provided',
        );

  final WalletViewModel? wallet;
  final String? id;

  @override
  List<Object?> get props => [wallet, id];
}

class TransactionFormAmountChanged extends TransactionFormEvent {
  const TransactionFormAmountChanged(this.amount);

  final double amount;

  @override
  List<Object> get props => [amount];
}

class TransactionFormCategoryChanged extends TransactionFormEvent {
  const TransactionFormCategoryChanged(this.category);

  final CategoryModel category;

  @override
  List<Object> get props => [category];
}

class TransactionFormDateChanged extends TransactionFormEvent {
  const TransactionFormDateChanged(this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];
}

class TransactionFormNoteChanged extends TransactionFormEvent {
  const TransactionFormNoteChanged(this.note);

  final String note;

  @override
  List<Object> get props => [note];
}

class TransactionFormTransferToWalletChanged extends TransactionFormEvent {
  const TransactionFormTransferToWalletChanged(this.wallet);

  final WalletViewModel wallet;

  @override
  List<Object> get props => [wallet];
}

class TransactionFormInitialized extends TransactionFormEvent {
  const TransactionFormInitialized({
    this.transaction,
    this.transactionId,
  }) : assert(
          transaction != null ||
              transactionId != null ||
              (transaction == null && transactionId == null),
          'Either transaction or transactionId must be provided for edit mode, or neither for create mode',
        );

  final TransactionModel? transaction;
  final String? transactionId;

  @override
  List<Object?> get props => [transaction, transactionId];
}

class TransactionFormSubmitted extends TransactionFormEvent {
  const TransactionFormSubmitted();
}

class TransactionFormDeleted extends TransactionFormEvent {
  const TransactionFormDeleted();
}
