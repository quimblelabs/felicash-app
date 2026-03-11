part of 'wallets_filter_cubit.dart';

final class WalletsFilterState extends Equatable {
  const WalletsFilterState({
    this.filter = const WalletsViewFilter(),
  });

  final WalletsViewFilter filter;

  WalletsFilterState copyWith({
    ValueGetter<WalletsViewFilter>? filter,
  }) {
    return WalletsFilterState(
      filter: filter != null ? filter() : this.filter,
    );
  }

  @override
  List<Object> get props => [filter];
}
