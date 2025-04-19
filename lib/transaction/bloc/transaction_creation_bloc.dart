import 'package:bloc/bloc.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'transaction_creation_event.dart';
part 'transaction_creation_state.dart';

class TransactionCreationBloc
    extends Bloc<TransactionCreationEvent, TransactionCreationState> {
  TransactionCreationBloc({
    required WalletRepository walletRepository,
  })  : _walletRepository = walletRepository,
        super(
          TransactionCreationState(
            wallet: BasicWalletModel.empty,
            date: DateTime.now(),
          ),
        ) {
    on<TransactionCreationTypeChanged>(_onTransactionTypeChanged);
    on<TransactionCreationWalletChanged>(_onTargetWalletChanged);
    on<TransactionCreationAmountChanged>(_onAmountChanged);
    on<TransactionCreationCategoryChanged>(_onCategoryChanged);
    on<TransactionCreationDateChanged>(_onDateChanged);
    on<TransactionCreationNoteChanged>(_onNoteChanged);
    on<TransactionCreationTransferToWalletChanged>(_onTransferToWalletChanged);
  }

  final WalletRepository _walletRepository;

  void _onTransactionTypeChanged(
    TransactionCreationTypeChanged event,
    Emitter<TransactionCreationState> emit,
  ) {
    emit(
      state.copyWith(
        type: event.type,
        isValid: _validateForm(),
      ),
    );
  }

  Future<void> _onTargetWalletChanged(
    TransactionCreationWalletChanged event,
    Emitter<TransactionCreationState> emit,
  ) async {
    if (event.wallet != null) {
      emit(
        state.copyWith(
          wallet: event.wallet,
          isValid: _validateForm(),
        ),
      );
      return;
    } else if (event.id case final id?) {
      await emit.forEach(
        _walletRepository.getWalletById(id),
        onData: (wallet) {
          return state.copyWith(
            wallet: wallet,
            isValid: _validateForm(),
          );
        },
        onError: (_, __) => state,
      );
      return;
    }
    emit(
      state.copyWith(
        wallet: event.wallet,
        isValid: _validateForm(),
      ),
    );
  }

  void _onAmountChanged(
    TransactionCreationAmountChanged event,
    Emitter<TransactionCreationState> emit,
  ) {
    final amount = TransactionMonetaryAmount.dirty(event.amount);
    emit(
      state.copyWith(
        amount: amount,
        isValid: _validateForm(amount: amount),
      ),
    );
  }

  void _onCategoryChanged(
    TransactionCreationCategoryChanged event,
    Emitter<TransactionCreationState> emit,
  ) {
    emit(
      state.copyWith(
        category: event.category,
        isValid: _validateForm(category: event.category),
      ),
    );
  }

  void _onDateChanged(
    TransactionCreationDateChanged event,
    Emitter<TransactionCreationState> emit,
  ) {
    emit(
      state.copyWith(
        date: event.date,
        isValid: _validateForm(),
      ),
    );
  }

  void _onNoteChanged(
    TransactionCreationNoteChanged event,
    Emitter<TransactionCreationState> emit,
  ) {
    final note = TransactionNote.dirty(event.note);
    emit(
      state.copyWith(
        note: note,
        isValid: _validateForm(note: note),
      ),
    );
  }

  void _onTransferToWalletChanged(
    TransactionCreationTransferToWalletChanged event,
    Emitter<TransactionCreationState> emit,
  ) {
    emit(
      state.copyWith(
        transferToWallet: event.wallet,
        isValid: _validateForm(),
      ),
    );
  }

  bool _validateForm({
    TransactionMonetaryAmount? amount,
    TransactionNote? note,
    TransactionTypeEnum? type,
    BaseWalletModel? wallet,
    BaseWalletModel? transferToWallet,
    CategoryModel? category,
    DateTime? date,
  }) {
    // Get effective values, using provided or current state
    final effectiveAmount = amount ?? state.amount;
    final effectiveNote = note ?? state.note;
    final effectiveType = type ?? state.type;
    final effectiveWallet = wallet ?? state.wallet;
    final effectiveTransferWallet = transferToWallet ?? state.transferToWallet;
    final effectiveCategory = category ?? state.category;
    final effectiveDate = date ?? state.date;

    // Validate form fields
    final isFormValid = Formz.validate([
      effectiveAmount,
      if (effectiveNote.value?.isNotEmpty ?? false) effectiveNote,
    ]);

    // Required fields validation
    if (effectiveWallet == null || effectiveDate == null) {
      return false;
    }

    // Transfer-specific validation
    if (effectiveType == TransactionTypeEnum.transfer) {
      if (effectiveTransferWallet == null) {
        return false;
      }

      // Prevent transfer to same wallet
      if (effectiveWallet.id == effectiveTransferWallet.id) {
        return false;
      }
    }
    // Non-transfer validation
    else if (effectiveCategory == null) {
      return false;
    }

    return isFormValid;
  }
}
