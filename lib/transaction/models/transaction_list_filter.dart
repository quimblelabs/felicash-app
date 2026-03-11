import 'package:category_repository/category_repository.dart';
import 'package:felicash/wallet/models/wallet_view_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_models/shared_models.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'transaction_list_filter.freezed.dart';
part 'transaction_list_filter.g.dart';

@freezed
abstract class TransactionListFilter with _$TransactionListFilter {
  const factory TransactionListFilter({
    @Default('') String searchKey,
    @Default({}) Set<CategoryModel> categories,
    @Default({}) Set<TransactionTypeEnum> types,
    @Default({}) Set<WalletViewModel> wallets,
    DateTime? from,
    DateTime? to,
  }) = _TransactionListFilter;

  /// Factory constructor for [TransactionListFilter] from JSON
  factory TransactionListFilter.fromJson(Map<String, dynamic> json) =>
      _$TransactionListFilterFromJson(json);

  const TransactionListFilter._();

  /// Empty filter that will return all transactions
  static const empty = TransactionListFilter();

  /// Check if the filter is empty
  bool get isEmpty => this == empty;
}
