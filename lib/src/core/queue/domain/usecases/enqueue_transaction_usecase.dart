import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_status.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/core/queue/domain/repositories/queue_repository.dart';

class EnqueueTransactionUseCase {
  const EnqueueTransactionUseCase(this._repo);

  final QueueRepository _repo;

  Stream<List<QueueItem>> watchAll() => _repo.watchAll();

  Future<void> execute({
    required String idempotencyKey,
    required TransactionType type,
    required int amountKobo,
    required String targetId,
  }) => _repo.enqueue(
    QueueItem(
      idempotencyKey: idempotencyKey,
      type: type,
      amountKobo: amountKobo,
      targetId: targetId,
      status: QueueStatus.pending,
      createdAt: DateTime.now(),
      attemptCount: 0,
    ),
  );
}
