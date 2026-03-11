import 'package:bloc/bloc.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/material.dart' show Color, IconData, Icons;
import 'package:form_inputs/form_inputs.dart';
import 'package:shared_models/shared_models.dart';
import 'package:uuid/uuid.dart';

part 'category_creation_event.dart';
part 'category_creation_state.dart';

class CategoryCreationBloc
    extends Bloc<CategoryCreationEvent, CategoryCreationState> {
  CategoryCreationBloc({
    required TransactionTypeEnum transactionType,
    required CategoryRepository categoryRepository,
    required Color color,
  })  : _categoryRepository = categoryRepository,
        super(
          CategoryCreationState(
            transactionType: transactionType,
            color: color,
          ),
        ) {
    on<CategoryCreationNameChanged>(_onWalletNameChanged);
    on<CategoryCreationDescriptionChanged>(_onWalletDescriptionChanged);
    on<CategoryCreationIconChanged>(_onWalletIconChanged);
    on<CategoryCreationColorChanged>(_onWalletColorChanged);
    on<CategoryCreationSubmitted>(_onSubmitted);
  }

  final CategoryRepository _categoryRepository;

  void _onWalletNameChanged(
    CategoryCreationNameChanged event,
    Emitter<CategoryCreationState> emit,
  ) {
    final name = CategoryName.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        isValid: _validateForm(name: name),
      ),
    );
  }

  void _onWalletDescriptionChanged(
    CategoryCreationDescriptionChanged event,
    Emitter<CategoryCreationState> emit,
  ) {
    final description = CategoryDescription.dirty(event.description);
    emit(
      state.copyWith(
        description: description,
        isValid: _validateForm(description: description),
      ),
    );
  }

  void _onWalletIconChanged(
    CategoryCreationIconChanged event,
    Emitter<CategoryCreationState> emit,
  ) {
    emit(
      state.copyWith(
        icon: event.icon,
      ),
    );
  }

  void _onWalletColorChanged(
    CategoryCreationColorChanged event,
    Emitter<CategoryCreationState> emit,
  ) {
    emit(
      state.copyWith(
        color: event.color,
      ),
    );
  }

  bool _validateForm({
    CategoryName? name,
    CategoryDescription? description,
  }) {
    final isValid = Formz.validate([
      name ?? state.name,
      description ?? state.description,
    ]);

    return isValid;
  }

  Future<void> _onSubmitted(
    CategoryCreationSubmitted event,
    Emitter<CategoryCreationState> emit,
  ) async {
    if (!state.isValid) return;

    final category = CategoryModel(
      id: const Uuid().v4(),
      name: state.name.value,
      description: state.description.value,
      icon: IconDataIcon.fromIconData(state.icon),
      color: state.color,
      transactionType: state.transactionType,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      emit(state.copyWith(status: CategoryCreationStatus.submiting));
      await _categoryRepository.createCategory(category);
      emit(state.copyWith(status: CategoryCreationStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CategoryCreationStatus.failure));
      return;
    }

    emit(state.copyWith(status: CategoryCreationStatus.success));
  }
}
