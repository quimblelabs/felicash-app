import 'package:bloc/bloc.dart';
import 'package:category_repository/category_repository.dart';
import 'package:currency_repository/currency_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:shared_models/shared_models.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'transaction_form_event.dart';
part 'transaction_form_state.dart';

class TransactionFormBloc
    extends Bloc<TransactionFormEvent, TransactionFormState> {
  TransactionFormBloc({
    required WalletRepository walletRepository,
    required CurrencyRepository currencyRepository,
    required TransactionRepository transactionRepository,
  })  : _walletRepository = walletRepository,
        _currencyRepository = currencyRepository,
        _transactionRepository = transactionRepository,
        super(
          TransactionFormState(
            wallet: null,
            date: DateTime.now(),
          ),
        ) {
    on<TransactionFormTypeChanged>(_onTypeChanged);
    on<TransactionFormWalletChanged>(_onWalletChanged);
    on<TransactionFormAmountChanged>(_onAmountChanged);
    on<TransactionFormCategoryChanged>(_onCategoryChanged);
    on<TransactionFormDateChanged>(_onDateChanged);
    on<TransactionFormNoteChanged>(_onNoteChanged);
    on<TransactionFormTransferToWalletChanged>(_onTransferToWalletChanged);
    on<TransactionFormInitialized>(_onInitialized);
    on<TransactionFormSubmitted>(_onSubmitted);
    on<TransactionFormDeleted>(_onDeleted);
  }

  final WalletRepository _walletRepository;
  final CurrencyRepository _currencyRepository;
  final TransactionRepository _transactionRepository;
  TransactionFormState? _initialState;

  /// Updates the transaction type and validates the form.
  void _onTypeChanged(
    TransactionFormTypeChanged event,
    Emitter<TransactionFormState> emit,
  ) {
    emit(
      state.copyWith(
        type: event.type,
        isValid: _validateForm(),
        isDirty: _isStateDirty(type: event.type),
      ),
    );
  }

  /// Updates the target wallet, fetching from repository if only ID is provided.
  Future<void> _onWalletChanged(
    TransactionFormWalletChanged event,
    Emitter<TransactionFormState> emit,
  ) async {
    try {
      if (event.wallet != null) {
        emit(
          state.copyWith(
            wallet: event.wallet,
            isValid: _validateForm(),
            isDirty: _isStateDirty(wallet: event.wallet?.wallet),
          ),
        );
        return;
      } else if (event.id != null) {
        emit(state.copyWith(status: TransactionFormStatus.loading));
        final currencies = await _currencyRepository.getCurrencies();
        await emit.forEach(
          _walletRepository.getWalletByIdStream(event.id!),
          onData: (wallet) {
            final currency = currencies.firstWhere(
              (currency) => currency.code == wallet.currencyCode,
              orElse: () => throw Exception('Currency not found'),
            );
            final walletViewModel =
                WalletViewModel(wallet: wallet, currency: currency);
            return state.copyWith(
              wallet: walletViewModel,
              isValid: _validateForm(),
              isDirty: _isStateDirty(wallet: walletViewModel.wallet),
              status: TransactionFormStatus.initial,
            );
          },
          onError: (error, stackTrace) {
            return state.copyWith(
              status: TransactionFormStatus.error,
              errorMessage: 'Failed to load wallet: $error',
            );
          },
        );
      } else {
        emit(
          state.copyWith(
            isValid: _validateForm(),
            isDirty: _isStateDirty(),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionFormStatus.error,
          errorMessage: 'Error updating wallet: $e',
        ),
      );
    }
  }

  /// Updates the transaction amount and validates the form.
  void _onAmountChanged(
    TransactionFormAmountChanged event,
    Emitter<TransactionFormState> emit,
  ) {
    final amount = TransactionMonetaryAmount.dirty(event.amount);
    emit(
      state.copyWith(
        amount: amount,
        isValid: _validateForm(amount: amount),
        isDirty: _isStateDirty(amount: amount),
      ),
    );
  }

  /// Updates the transaction category and validates the form.
  void _onCategoryChanged(
    TransactionFormCategoryChanged event,
    Emitter<TransactionFormState> emit,
  ) {
    emit(
      state.copyWith(
        category: event.category,
        isDirty: _isStateDirty(category: event.category),
      ),
    );
  }

  /// Updates the transaction date and validates the form.
  void _onDateChanged(
    TransactionFormDateChanged event,
    Emitter<TransactionFormState> emit,
  ) {
    emit(
      state.copyWith(
        date: event.date,
        isValid: _validateForm(date: event.date),
        isDirty: _isStateDirty(date: event.date),
      ),
    );
  }

  /// Updates the transaction note and validates the form.
  void _onNoteChanged(
    TransactionFormNoteChanged event,
    Emitter<TransactionFormState> emit,
  ) {
    final note = TransactionNote.dirty(event.note);
    emit(
      state.copyWith(
        note: note,
        isValid: _validateForm(note: note),
        isDirty: _isStateDirty(note: note),
      ),
    );
  }

  /// Updates the transfer-to wallet for transfer transactions.
  void _onTransferToWalletChanged(
    TransactionFormTransferToWalletChanged event,
    Emitter<TransactionFormState> emit,
  ) {
    emit(
      state.copyWith(
        transferToWallet: event.wallet,
        isValid: _validateForm(transferToWallet: event.wallet.wallet),
        isDirty: _isStateDirty(transferToWallet: event.wallet.wallet),
      ),
    );
  }

  /// Initializes the form for creating or editing a transaction.
  Future<void> _onInitialized(
    TransactionFormInitialized event,
    Emitter<TransactionFormState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TransactionFormStatus.loading));
      TransactionFormState newState;
      if (event.transaction != null) {
        final walletById = await _getWalletById(event.transaction!.wallet.id);
        WalletViewModel? transferToWallet;
        if (walletById == null) {
          emit(
            state.copyWith(
              status: TransactionFormStatus.error,
              errorMessage: 'Wallet not found',
            ),
          );
          return;
        }

        if (event.transaction!.transferWallet != null) {
          transferToWallet = await _getWalletById(
            event.transaction!.transferWallet!.id,
          );
          if (transferToWallet == null) {
            emit(
              state.copyWith(
                status: TransactionFormStatus.error,
                errorMessage: 'Transfer wallet not found',
              ),
            );
            return;
          }
        }

        final transaction = event.transaction!;
        newState = TransactionFormState(
          transactionId: transaction.id,
          mode: TransactionMode.edit,
          type: transaction.transactionType,
          wallet: walletById,
          amount: TransactionMonetaryAmount.dirty(transaction.amount),
          category: transaction.category,
          date: transaction.transactionDate,
          note: TransactionNote.dirty(transaction.notes ?? ''),
          transferToWallet: transferToWallet,
        );
        newState = newState.copyWith(
          isValid: _validateForm(
            amount: newState.amount,
            date: newState.date,
            note: newState.note,
            transferToWallet: newState.transferToWallet?.wallet,
          ),
        );
      } else if (event.transactionId != null) {
        final transaction = await _transactionRepository
            .getTransactionByIdFuture(event.transactionId!);
        final walletById = await _getWalletById(transaction.wallet.id);
        WalletViewModel? transferToWallet;
        if (transaction.transferWallet != null) {
          transferToWallet = await _getWalletById(
            transaction.transferWallet!.id,
          );
        }
        if (walletById == null) {
          emit(
            state.copyWith(
              status: TransactionFormStatus.error,
              errorMessage: 'Wallet not found',
            ),
          );
          return;
        }
        if (transaction.transferWallet != null && transferToWallet == null) {
          emit(
            state.copyWith(
              status: TransactionFormStatus.error,
              errorMessage: 'Transfer wallet not found',
            ),
          );
          return;
        }
        newState = TransactionFormState(
          transactionId: transaction.id,
          mode: TransactionMode.edit,
          type: transaction.transactionType,
          wallet: walletById,
          amount: TransactionMonetaryAmount.dirty(transaction.amount),
          category: transaction.category,
          date: transaction.transactionDate,
          note: TransactionNote.dirty(transaction.notes ?? ''),
          transferToWallet: transferToWallet,
        );

        newState = newState.copyWith(
          isValid: _validateForm(
            amount: newState.amount,
            date: newState.date,
            note: newState.note,
            transferToWallet: newState.transferToWallet?.wallet,
          ),
        );
      } else {
        newState = TransactionFormState(
          wallet: null,
          date: DateTime.now(),
          isValid: _validateForm(),
        );
      }
      _initialState = newState; // Store initial state for dirty checking
      emit(newState);
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionFormStatus.error,
          errorMessage: 'Failed to initialize form: $e',
        ),
      );
    }
  }

  /// Submits the form to create or update a transaction.
  Future<void> _onSubmitted(
    TransactionFormSubmitted event,
    Emitter<TransactionFormState> emit,
  ) async {
    if (!_validateForm()) return;
    emit(state.copyWith(status: TransactionFormStatus.submitting));
    try {
      final amount = switch (state.type) {
        TransactionTypeEnum.income => state.amount.value.abs(),
        TransactionTypeEnum.expense => -state.amount.value.abs(),
        _ => state.amount.value,
      };
      final transaction = TransactionModel(
        id: state.transactionId ?? const Uuid().v4(),
        transactionType: state.type,
        wallet: state.wallet!.wallet,
        amount: amount,
        category: state.category,
        transactionDate: state.date!,
        notes: (state.note.value ?? '').isNotEmpty ? state.note.value : null,
        transferWallet: state.transferToWallet?.wallet,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (state.mode == TransactionMode.create) {
        await _transactionRepository.createTransaction(transaction);
      } else {
        await _transactionRepository.updateTransaction(transaction);
      }
      emit(
        state.copyWith(
          status: TransactionFormStatus.success,
          isDirty: false,
        ),
      );
      _initialState = state; // Reset initial state after submission
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionFormStatus.error,
          errorMessage: 'Failed to submit transaction: $e',
        ),
      );
    }
  }

  /// Deletes the transaction in edit mode.
  Future<void> _onDeleted(
    TransactionFormDeleted event,
    Emitter<TransactionFormState> emit,
  ) async {
    if (state.mode != TransactionMode.edit || state.transactionId == null) {
      return;
    }

    emit(state.copyWith(status: TransactionFormStatus.deleting));
    try {
      await _transactionRepository.deleteTransaction(state.transactionId!);
      emit(
        state.copyWith(
          status: TransactionFormStatus.deleted,
          isDirty: false,
        ),
      );
      _initialState = state; // Reset initial state after deletion
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionFormStatus.error,
          errorMessage: 'Failed to delete transaction: $e',
        ),
      );
    }
  }

  Future<WalletViewModel?> _getWalletById(String id) async {
    try {
      final wallet = await _walletRepository.getWalletByIdFuture(id);
      final currencies = await _currencyRepository.getCurrencies();
      final currency = currencies.firstWhere(
        (currency) => currency.code == wallet.currencyCode,
        orElse: () => throw Exception('Currency not found'),
      );
      return WalletViewModel(wallet: wallet, currency: currency);
    } catch (e, stackTrace) {
      debugPrintStack(
        stackTrace: stackTrace,
        label: 'TransactionFormBloc._getWalletById',
      );
      return null;
    }
  }

  /// Validates the form based on the current or provided state.
  bool _validateForm({
    TransactionMonetaryAmount? amount,
    TransactionNote? note,
    TransactionTypeEnum? type,
    BaseWalletModel? wallet,
    BaseWalletModel? transferToWallet,
    DateTime? date,
  }) {
    final effectiveAmount = amount ?? state.amount;
    final effectiveNote = note ?? state.note;
    final effectiveType = type ?? state.type;
    final effectiveWallet = wallet ?? state.wallet?.wallet;
    final effectiveTransferWallet =
        transferToWallet ?? state.transferToWallet?.wallet;
    final effectiveDate = date ?? state.date;

    // Validate form inputs using Formz
    final isFormValid = Formz.validate([
      effectiveAmount,
      if (effectiveNote.value?.isNotEmpty ?? false) effectiveNote,
    ]);

    // Required fields
    if (effectiveWallet == null || effectiveDate == null) {
      return false;
    }

    // Transfer-specific validation
    if (effectiveType == TransactionTypeEnum.transfer) {
      if (effectiveTransferWallet == null) {
        return false;
      }
      if (effectiveWallet.id == effectiveTransferWallet.id) {
        return false;
      }
    }

    return isFormValid;
  }

  /// Checks if the state is dirty by comparing with the initial state.
  bool _isStateDirty({
    TransactionTypeEnum? type,
    BaseWalletModel? wallet,
    TransactionMonetaryAmount? amount,
    CategoryModel? category,
    DateTime? date,
    TransactionNote? note,
    BaseWalletModel? transferToWallet,
  }) {
    if (_initialState == null) return false;

    final effectiveType = type ?? state.type;
    final effectiveWallet = wallet ?? state.wallet?.wallet;
    final effectiveAmount = amount ?? state.amount;
    final effectiveCategory = category ?? state.category;
    final effectiveDate = date ?? state.date;
    final effectiveNote = note ?? state.note;
    final effectiveTransferWallet =
        transferToWallet ?? state.transferToWallet?.wallet;

    return effectiveType != _initialState!.type ||
        effectiveWallet?.id != _initialState!.wallet?.wallet.id ||
        effectiveAmount.value != _initialState!.amount.value ||
        effectiveCategory?.id != _initialState!.category?.id ||
        effectiveDate != _initialState!.date ||
        effectiveNote.value != _initialState!.note.value ||
        effectiveTransferWallet?.id !=
            _initialState!.transferToWallet?.wallet.id;
  }
}
