import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'queue_database.g.dart';

class QueueRows extends Table {
  TextColumn get idempotencyKey => text()();
  TextColumn get type => text()();
  IntColumn get amountKobo => integer()();
  TextColumn get targetId => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attemptCount => integer()();

  @override
  Set<Column<Object>> get primaryKey => {idempotencyKey};
}

class BackendReceipts extends Table {
  TextColumn get idempotencyKey => text()();
  DateTimeColumn get processedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {idempotencyKey};
}

class SavingsGoalRows extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  IntColumn get targetKobo => integer()();
  IntColumn get currentKobo => integer()();
  IntColumn get durationMonths => integer()();
  TextColumn get frequency => text()();
  IntColumn get amountPerPeriodKobo => integer()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get status => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [QueueRows, BackendReceipts, SavingsGoalRows])
class QueueDatabase extends _$QueueDatabase {
  QueueDatabase(super.e);

  QueueDatabase.open() : this(driftDatabase(name: 'nova_wallet_queue'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) await migrator.createTable(backendReceipts);
      if (from < 3) await migrator.createTable(savingsGoalRows);
    },
  );
}
