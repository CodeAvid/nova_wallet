import 'package:dart_mappable/dart_mappable.dart';

part 'wallet.mapper.dart';

@MappableClass()
class Wallet with WalletMappable {
  const Wallet({required this.balanceKobo, required this.ownerName});

  final int balanceKobo;
  final String ownerName;
}
