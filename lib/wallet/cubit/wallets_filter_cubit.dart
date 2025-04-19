import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felicash/wallet/models/wallets_view_filter.dart';
import 'package:flutter/material.dart';

part 'wallets_filter_state.dart';

class WalletsFilterCubit extends Cubit<WalletsFilterState> {
  WalletsFilterCubit() : super(const WalletsFilterState());

  void onFilterChanged(WalletsViewFilter filter) {
    emit(state.copyWith(filter: () => filter));
  }
}
