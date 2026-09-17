import 'package:nova_wallet/src/features/wallet_home/domain/repositories/wallet_home_repository.dart';

class LoadWalletHomeUseCase {
  const LoadWalletHomeUseCase(this._load);

  final WalletHomeLoader _load;

  Future<WalletHomeData> call() => _load();
}
