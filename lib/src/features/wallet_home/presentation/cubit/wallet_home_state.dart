import 'package:equatable/equatable.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/entities/transaction.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/entities/wallet.dart';

sealed class WalletHomeState extends Equatable {
  const WalletHomeState();
}

final class WalletHomeLoading extends WalletHomeState {
  const WalletHomeLoading();

  @override
  List<Object?> get props => [];
}

final class WalletHomeLoaded extends WalletHomeState {
  const WalletHomeLoaded({
    required this.wallet,
    required this.transactions,
    this.computedBalanceKobo,
  });

  final Wallet wallet;
  final List<Transaction> transactions;
  // If null, falls back to wallet.balanceKobo
  final int? computedBalanceKobo;

  int get displayBalanceKobo => computedBalanceKobo ?? wallet.balanceKobo;

  @override
  List<Object?> get props => [wallet, transactions, computedBalanceKobo];
}

final class WalletHomeFailure extends WalletHomeState {
  const WalletHomeFailure();

  @override
  List<Object?> get props => [];
}
