import 'package:nova_wallet/src/features/nova_save/domain/entities/savings_goal.dart';

abstract class SavingsRepository {
  Future<void> createGoal(SavingsGoal goal);
  Stream<List<SavingsGoal>> watchAll();
  Future<SavingsGoal?> getById(String id);
}
