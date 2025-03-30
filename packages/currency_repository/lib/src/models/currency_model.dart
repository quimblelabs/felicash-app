import 'package:equatable/equatable.dart';

/// {@template currency_model}
/// Currency model for the app
/// {@endtemplate}
class CurrencyModel extends Equatable {
  /// {@macro currency_model}
  const CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Code of the currency
  final String code;

  /// Name of the currency
  final String name;

  /// Symbol of the currency
  final String symbol;

  /// Date of creation of the currency
  final DateTime createdAt;

  /// Date of update of the currency
  final DateTime updatedAt;

  /// Empty currency model
  static final empty = CurrencyModel(
    code: '',
    name: '',
    symbol: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  ///  Check if the currency is empty
  bool get isEmpty => this == CurrencyModel.empty;

  @override
  List<Object?> get props => [
        code,
        name,
        symbol,
        createdAt,
        updatedAt,
      ];
}
