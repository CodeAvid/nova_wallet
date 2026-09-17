import 'package:nova_wallet/src/core/network/fake_api_client.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_status.dart';
import 'package:nova_wallet/src/core/queue/domain/repositories/queue_repository.dart';

class ReplayQueueUseCase {
  const ReplayQueueUseCase(this._repository, this._apiClient);

  final QueueRepository _repository;
  final FakeApiClient _apiClient;

  Future<List<QueueItem>> execute() async {
    final confirmed = <QueueItem>[];
    final interrupted = await _repository.getByStatus(QueueStatus.sending);
    for (final item in interrupted) {
      if (await _apiClient.isProcessed(item.idempotencyKey)) {
        await _repository.updateStatus(
          item.idempotencyKey,
          QueueStatus.confirmed,
        );
        confirmed.add(item);
      } else {
        await _repository.updateStatus(item.idempotencyKey, QueueStatus.failed);
      }
    }
    final ready = <QueueItem>[
      ...await _repository.getByStatus(QueueStatus.pending),
      ...await _repository.getByStatus(QueueStatus.failed),
    ];
    for (final item in ready) {
      await _repository.updateStatus(item.idempotencyKey, QueueStatus.sending);
      try {
        await _apiClient.submit(item);
        await _repository.updateStatus(
          item.idempotencyKey,
          QueueStatus.confirmed,
        );
        confirmed.add(item);
      } on Object {
        await _repository.updateStatus(item.idempotencyKey, QueueStatus.failed);
      }
    }
    return confirmed;
  }
}
