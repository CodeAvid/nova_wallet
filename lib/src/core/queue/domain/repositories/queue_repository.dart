import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_status.dart';

abstract class QueueRepository {
  Future<void> enqueue(QueueItem item);
  Future<List<QueueItem>> getByStatus(QueueStatus status);
  Future<void> updateStatus(String idempotencyKey, QueueStatus status);
  Stream<List<QueueItem>> watchAll();
}
