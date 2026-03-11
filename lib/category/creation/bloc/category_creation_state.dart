part of 'category_creation_bloc.dart';

enum CategoryCreationStatus { initial, submiting, success, failure }

class CategoryCreationState extends Equatable {
  const CategoryCreationState({
    required this.color,
    required this.transactionType,
    this.name = const CategoryName.pure(),
    this.description = const CategoryDescription.pure(),
    this.icon = Icons.category_rounded,
    this.isValid = false,
    this.status = CategoryCreationStatus.initial,
    this.errorMessage,
  });

  // -- Category creation form fields
  final CategoryName name;
  final TransactionTypeEnum transactionType;
  final CategoryDescription description;
  final IconData icon;
  final Color color;

  // -- Category creation form state
  final bool isValid;
  final CategoryCreationStatus status;
  final String? errorMessage;

  CategoryCreationState copyWith({
    CategoryName? name,
    TransactionTypeEnum? transactionType,
    CategoryDescription? description,
    IconData? icon,
    Color? color,
    bool? isValid,
    CategoryCreationStatus? status,
    String? errorMessage,
  }) {
    return CategoryCreationState(
      name: name ?? this.name,
      transactionType: transactionType ?? this.transactionType,
      color: color ?? this.color,
      status: status ?? this.status,
      description: description ?? this.description,
      isValid: isValid ?? this.isValid,
      icon: icon ?? this.icon,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props {
    return [
      name,
      description,
      icon,
      color,
      isValid,
      status,
      errorMessage,
    ];
  }
}
