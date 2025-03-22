part of 'wallet_bloc.dart';

sealed class WalletState extends Equatable {
  const WalletState();
  
  @override
  List<Object> get props => [];
}

final class WalletInitial extends WalletState {}
