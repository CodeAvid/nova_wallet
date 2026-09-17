import 'package:nova_wallet/src/features/wallet_home/domain/entities/transaction.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/entities/wallet.dart';

class WalletHomeData {
  const WalletHomeData({required this.wallet, required this.transactions});

  final Wallet wallet;
  final List<Transaction> transactions;
}

typedef WalletHomeLoader = Future<WalletHomeData> Function();
