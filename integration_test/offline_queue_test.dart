import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nova_wallet/src/core/network/fake_api_client.dart';
import 'package:nova_wallet/src/core/queue/data/repositories/in_memory_queue_repository.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_status.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/core/queue/domain/usecases/replay_queue_usecase.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'queued transfer is confirmed exactly once after restart and reconnect',
    (tester) async {
      final queue = InMemoryQueueRepository();
      final backend = FakeApiClient();
      final item = QueueItem(
        idempotencyKey: 'af4de6e7-76f4-4224-b0b7-8b8979d4d0fe',
        type: TransactionType.send,
        amountKobo: 10000,
        targetId: 'ACC-001',
        status: QueueStatus.pending,
        createdAt: DateTime.utc(2026),
        attemptCount: 0,
      );
      await queue.enqueue(item); // Offline tap persists the action.

      await ReplayQueueUseCase(
        queue,
        backend,
      ).execute(); // Reconnect after restart.
      await ReplayQueueUseCase(
        queue,
        backend,
      ).execute(); // Duplicate replay signal.

      expect(backend.processedWriteCount, 1);
      expect(await queue.getByStatus(QueueStatus.confirmed), hasLength(1));
    },
  );
}
