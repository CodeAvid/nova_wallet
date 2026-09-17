import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nova_wallet/src/core/network/fake_backend_models.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/entities/transaction.dart';

abstract interface class BackendReceiptStore {
  Future<bool> contains(String idempotencyKey);
  Future<bool> add(String idempotencyKey);
}

class InMemoryBackendReceiptStore implements BackendReceiptStore {
  final Set<String> _keys = <String>{};

  @override
  Future<bool> add(String idempotencyKey) async => _keys.add(idempotencyKey);

  @override
  Future<bool> contains(String idempotencyKey) async =>
      _keys.contains(idempotencyKey);
}

/// Deterministic, local stand-in for the NIP rail. It retains idempotency keys
/// for the lifetime of the backend instance, just as a remote service would.
class FakeApiClient {
  FakeApiClient({AssetBundle? bundle, BackendReceiptStore? receipts})
    : _bundle = bundle ?? rootBundle,
      _receipts = receipts ?? InMemoryBackendReceiptStore();

  final AssetBundle _bundle;
  final BackendReceiptStore _receipts;
  var _processedWriteCount = 0;
  FakeBackendSeed? _seed;
  int _balanceKobo = 0;

  int get balanceKobo => _balanceKobo;

  Future<FakeBackendSeed> loadSeed() async {
    final cached = _seed;
    if (cached != null) return cached;
    final raw = await _bundle.loadString('assets/mock/fake_backend.json');
    final parsed = jsonDecode(raw) as Map<String, dynamic>;
    final compactSeed = FakeBackendSeedMapper.fromMap(parsed);
    _balanceKobo = compactSeed.wallet.balanceKobo;
    final transactions = List.generate(72, (index) {
      final source =
          compactSeed.transactions[index % compactSeed.transactions.length];
      return Transaction(
        id: '${source.id}-$index',
        title: source.title,
        counterparty: source.counterparty,
        amountKobo: source.amountKobo,
        date: source.date.subtract(
          Duration(days: index ~/ compactSeed.transactions.length),
        ),
        category: source.category,
      );
    });
    return _seed = FakeBackendSeed(
      wallet: compactSeed.wallet,
      transactions: transactions,
      goals: compactSeed.goals,
    );
  }

  Future<bool> health() async => true;

  Future<bool> isProcessed(String idempotencyKey) async =>
      _receipts.contains(idempotencyKey);

  Future<SubmissionResult> submit(QueueItem item) async {
    final inserted = await _receipts.add(item.idempotencyKey);
    if (inserted) {
      _processedWriteCount++;
      if (item.type == TransactionType.topUp) {
        _balanceKobo += item.amountKobo;
      } else {
        _balanceKobo = (_balanceKobo - item.amountKobo).clamp(0, _balanceKobo);
      }
    }
    final duplicate = !inserted;
    return SubmissionResult(accepted: true, alreadyProcessed: duplicate);
  }

  int get processedWriteCount => _processedWriteCount;
}
