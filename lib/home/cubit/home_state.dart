part of 'home_cubit.dart';

enum HomeState {
  home(0),
  transaction(1),
  wallet(2),
  personal(3);

  const HomeState(this.tabIndex);
  final int tabIndex;
}
