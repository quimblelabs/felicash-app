import 'package:equatable/equatable.dart';
import 'package:shared_models/src/enums/order_type_enum.dart';

/// A base class for get queries.
abstract class BaseGetQuery extends Equatable {
  /// Creates a new instance of [BaseGetQuery].
  const BaseGetQuery({
    this.pageIndex = 0,
    this.pageSize = 999999,
    this.orderType = OrderTypeEnum.ascending,
    this.orderBy,
  });

  /// The page index.
  final int pageIndex;

  /// The page size.
  final int pageSize;

  /// The offset.
  int get offset => pageIndex * pageSize;

  /// The limit.
  int get limit => pageSize;

  /// The order type [OrderTypeEnum]
  /// to be used for sorting.
  final OrderTypeEnum orderType;

  /// The field to be used for sorting.
  final String? orderBy;

  @override
  List<Object?> get props => [pageIndex, pageSize, orderType, orderBy];
}
