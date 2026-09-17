import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/src/core/network/fake_api_client.dart';
import 'package:nova_wallet/src/core/queue/data/repositories/in_memory_queue_repository.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_status.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/core/queue/domain/usecases/replay_queue_usecase.dart';

void main() {
  test(
    'reconciles an interrupted accepted write without submitting twice',
    () async {
      final repository = InMemoryQueueRepository();
      final api = FakeApiClient();
      const key = '7d642ec3-6f7e-4290-9e61-6f4a30e88b64';
      final item = QueueItem(
        idempotencyKey: key,
        type: TransactionType.send,
        amountKobo: 10000,
        targetId: 'ACC-001',
        status: QueueStatus.sending,
        createdAt: DateTime.utc(2026),
        attemptCount: 0,
      );
      await repository.enqueue(item);
      await api.submit(
        item,
      ); // Backend accepted before the app was interrupted.

      await ReplayQueueUseCase(repository, api).execute();

      expect(api.processedWriteCount, 1);
      expect(await repository.getByStatus(QueueStatus.confirmed), hasLength(1));
    },
  );
}
