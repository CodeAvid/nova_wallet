import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/core/queue/domain/usecases/enqueue_transaction_usecase.dart';
import 'package:nova_wallet/src/features/nova_save/domain/entities/savings_goal.dart';
import 'package:nova_wallet/src/features/nova_save/domain/repositories/savings_repository.dart';

class CreateSavingsGoalUseCase {
  const CreateSavingsGoalUseCase(this._repo, this._enqueue);

  final SavingsRepository _repo;
  final EnqueueTransactionUseCase _enqueue;

  Future<void> execute({
    required String idempotencyKey,
    required SavingsGoal goal,
  }) async {
    await _repo.createGoal(goal);
    await _enqueue.execute(
      idempotencyKey: idempotencyKey,
      type: TransactionType.saveContribution,
      amountKobo: goal.amountPerPeriodKobo,
      targetId: goal.id,
    );
  }
}
