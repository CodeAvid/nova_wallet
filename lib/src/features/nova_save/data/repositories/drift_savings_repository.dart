import 'package:drift/drift.dart';
import 'package:nova_wallet/src/core/queue/data/datasources/queue_database.dart';
import 'package:nova_wallet/src/features/nova_save/domain/entities/savings_goal.dart';
import 'package:nova_wallet/src/features/nova_save/domain/repositories/savings_repository.dart';

class DriftSavingsRepository implements SavingsRepository {
  const DriftSavingsRepository(this._db);

  final QueueDatabase _db;

  @override
  Future<void> createGoal(SavingsGoal goal) async {
    await _db.into(_db.savingsGoalRows).insertOnConflictUpdate(
      SavingsGoalRowsCompanion.insert(
        id: goal.id,
        name: goal.name,
        category: goal.category,
        targetKobo: goal.targetKobo,
        currentKobo: goal.currentKobo,
        durationMonths: goal.durationMonths,
        frequency: goal.frequency,
        amountPerPeriodKobo: goal.amountPerPeriodKobo,
        createdAt: goal.createdAt ?? DateTime.now(),
        status: goal.status,
      ),
    );
  }

  @override
  Stream<List<SavingsGoal>> watchAll() {
    return (_db.select(_db.savingsGoalRows)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<SavingsGoal?> getById(String id) async {
    final row = await (_db.select(_db.savingsGoalRows)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  SavingsGoal _toEntity(SavingsGoalRow row) => SavingsGoal(
    id: row.id,
    name: row.name,
    category: row.category,
    targetKobo: row.targetKobo,
    currentKobo: row.currentKobo,
    durationMonths: row.durationMonths,
    frequency: row.frequency,
    amountPerPeriodKobo: row.amountPerPeriodKobo,
    createdAt: row.createdAt,
    status: row.status,
  );
}
