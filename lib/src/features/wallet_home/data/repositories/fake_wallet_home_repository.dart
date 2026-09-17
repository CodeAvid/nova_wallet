import 'package:nova_wallet/src/core/network/fake_api_client.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/entities/wallet.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/repositories/wallet_home_repository.dart';

class FakeWalletHomeRepository {
  const FakeWalletHomeRepository(this._client);

  final FakeApiClient _client;

  Future<WalletHomeData> call() async {
    final seed = await _client.loadSeed();
    return WalletHomeData(
      wallet: Wallet(balanceKobo: _client.balanceKobo, ownerName: seed.wallet.ownerName),
      transactions: List.unmodifiable(seed.transactions),
    );
  }
}
