import 'package:drift/drift.dart';
import 'package:nova_wallet/src/core/network/fake_api_client.dart';
import 'package:nova_wallet/src/core/queue/data/datasources/queue_database.dart';

class DriftBackendReceiptStore implements BackendReceiptStore {
  DriftBackendReceiptStore(this._database);

  final QueueDatabase _database;

  @override
  Future<bool> add(String idempotencyKey) async {
    final inserted = await _database
        .into(_database.backendReceipts)
        .insert(
          BackendReceiptsCompanion.insert(
            idempotencyKey: idempotencyKey,
            processedAt: DateTime.now().toUtc(),
          ),
          mode: InsertMode.insertOrIgnore,
        );
    return inserted == 1;
  }

  @override
  Future<bool> contains(String idempotencyKey) async =>
      await (_database.select(_database.backendReceipts)
            ..where((row) => row.idempotencyKey.equals(idempotencyKey)))
          .getSingleOrNull() !=
      null;
}
