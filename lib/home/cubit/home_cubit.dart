import 'package:bloc/bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.home);

  void changeTab(int index) {
    emit(HomeState.values[index]);
  }
}
