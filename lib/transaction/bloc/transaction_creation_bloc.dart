import 'package:bloc/bloc.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:shared_models/shared_models.dart';
import 'package:transaction_repository/transaction_repository.dart';
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
      final wallet = await _walletRepository.getWalletById(id);
      emit(
        state.copyWith(
          wallet: wallet,
          isValid: _validateForm(),
        ),
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
    final amount = MonetaryAmount.dirty(event.amount);
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
        isValid: _validateForm(),
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
    MonetaryAmount? amount,
    TransactionNote? note,
  }) {
    final isValid = Formz.validate([
      amount ?? state.amount,
      if (note ?? state.note case final n) n,
    ]);

    if (state.wallet == null) {
      return false;
    }

    if (state.type == TransactionTypeEnum.transfer &&
        state.transferToWallet == null) {
      return false;
    }

    if (state.type != TransactionTypeEnum.transfer && state.category == null) {
      return false;
    }

    if (state.date == null) {
      return false;
    }

    return isValid;
  }
}
