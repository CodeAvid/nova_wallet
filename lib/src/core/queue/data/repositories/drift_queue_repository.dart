import 'package:drift/drift.dart';
import 'package:nova_wallet/src/core/queue/data/datasources/queue_database.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_status.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/core/queue/domain/repositories/queue_repository.dart';

class DriftQueueRepository implements QueueRepository {
  DriftQueueRepository(this._database);

  final QueueDatabase _database;

  QueueItem _map(QueueRow row) => QueueItem(
    idempotencyKey: row.idempotencyKey,
    type: TransactionType.values.byName(row.type),
    amountKobo: row.amountKobo,
    targetId: row.targetId,
    status: QueueStatus.values.byName(row.status),
    createdAt: row.createdAt,
    attemptCount: row.attemptCount,
  );

  QueueRowsCompanion _companion(QueueItem item) => QueueRowsCompanion.insert(
    idempotencyKey: item.idempotencyKey,
    type: item.type.name,
    amountKobo: item.amountKobo,
    targetId: item.targetId,
    status: item.status.name,
    createdAt: item.createdAt,
    attemptCount: item.attemptCount,
  );

  @override
  Future<void> enqueue(QueueItem item) => _database
      .into(_database.queueRows)
      .insertOnConflictUpdate(_companion(item));

  @override
  Future<List<QueueItem>> getByStatus(QueueStatus status) async =>
      (await (_database.select(
            _database.queueRows,
          )..where((row) => row.status.equals(status.name))).get())
          .map(_map)
          .toList(growable: false);

  @override
  Future<void> updateStatus(String idempotencyKey, QueueStatus status) =>
      (_database.update(_database.queueRows)
            ..where((row) => row.idempotencyKey.equals(idempotencyKey)))
          .write(QueueRowsCompanion(status: Value(status.name)))
          .then<void>((_) {});

  @override
  Stream<List<QueueItem>> watchAll() => _database
      .select(_database.queueRows)
      .watch()
      .map(
        (rows) => rows.map(_map).toList(growable: false),
      );

  Future<void> close() => _database.close();
}
