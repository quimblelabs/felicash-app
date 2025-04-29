import 'package:currency_repository/src/models/models.dart';
import 'package:currency_repository/src/supported_currencies.dart';
import 'package:equatable/equatable.dart';

/// {@template currency_failure}
/// Base failure class for currency repository.
/// {@endtemplate}
abstract class CurrencyFailure with EquatableMixin implements Exception {
  /// {@macro currency_failure}
  const CurrencyFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template get_currencies_failure}
/// Failure when fetching currencies.
/// {@endtemplate}
class GetCurrenciesFailure extends CurrencyFailure {
  /// {@macro get_currencies_failure}
  const GetCurrenciesFailure(super.error);
}

/// {@template get_currency_by_id_failure}
/// Failure when fetching a currency by id.
/// {@endtemplate}
class GetCurrencyByIdFailure extends CurrencyFailure {
  /// {@macro get_currency_by_id_failure}
  const GetCurrencyByIdFailure(super.error);
}

/// {@template get_currency_by_id_not_found}
///  Failure when fetching a currency by id and it is not found.
/// {@endtemplate}
class GetCurrencyByUserIdNotFound extends GetCurrencyByIdFailure {
  /// {@macro get_currency_by_id_failure}
  const GetCurrencyByUserIdNotFound([super.error = 'Currency not found']);
}

/// {@template get_currency_by_id_parse_failure}
/// Failure when fetching a currency by id and it is not found.
/// {@endtemplate}
class GetCurrencyByUserIdParseFailure extends GetCurrencyByIdFailure {
  /// {@macro get_currency_by_id_failure}
  const GetCurrencyByUserIdParseFailure([
    super.error = 'Error parsing currency',
  ]);
}

/// {@template create_currency_failure}
/// Failure when creating a currency.
/// {@endtemplate}
class CreateCurrencyFailure extends CurrencyFailure {
  /// {@macro create_currency_failure}
  const CreateCurrencyFailure(super.error);
}

/// {@template update_currency_failure}
/// Failure when updating a currency.
/// {@endtemplate}
class UpdateCurrencyFailure extends CurrencyFailure {
  /// {@macro update_currency_failure}
  const UpdateCurrencyFailure(super.error);
}

/// {@template currency_repository}
/// Repository for managing currencies.
/// {@endtemplate}
class CurrencyRepository {
  /// {@macro currency_repository}
  const CurrencyRepository();

  /// Fetches all currencies.
  ///
  /// Throws a [GetCurrenciesFailure] if an error occurs.
  Future<List<CurrencyModel>> getCurrencies() async {
    return SupportedCurrencies.availableCurrencies.toList();
  }
}
