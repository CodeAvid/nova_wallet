import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/core/queue/domain/usecases/enqueue_transaction_usecase.dart';

class ContributeToGoalUseCase {
  const ContributeToGoalUseCase(this._enqueue);

  final EnqueueTransactionUseCase _enqueue;

  Future<void> execute({
    required String idempotencyKey,
    required int amountKobo,
    required String goalId,
  }) => _enqueue.execute(
    idempotencyKey: idempotencyKey,
    type: TransactionType.saveContribution,
    amountKobo: amountKobo,
    targetId: goalId,
  );
}
