import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/core/queue/domain/usecases/enqueue_transaction_usecase.dart';

class SendMoneyUseCase {
  const SendMoneyUseCase(this._enqueue);

  final EnqueueTransactionUseCase _enqueue;

  Future<void> execute({
    required String idempotencyKey,
    required int amountKobo,
    required String recipientId,
  }) => _enqueue.execute(
    idempotencyKey: idempotencyKey,
    type: TransactionType.send,
    amountKobo: amountKobo,
    targetId: recipientId,
  );
}
