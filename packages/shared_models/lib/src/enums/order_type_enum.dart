// ignore_for_file: sort_constructors_first

/// The enum [OrderTypeEnum] is used to order the results of a query.
enum OrderTypeEnum {
  /// Order by ascending.
  ascending._('ASC'),

  /// Order by descending.
  descending._('DESC');

  /// Returns the string representation of the enum.
  final String sqlString;

  const OrderTypeEnum._(this.sqlString);
}
