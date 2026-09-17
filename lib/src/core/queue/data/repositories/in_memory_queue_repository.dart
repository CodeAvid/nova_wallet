import 'dart:async';

import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_status.dart';
import 'package:nova_wallet/src/core/queue/domain/repositories/queue_repository.dart';

class InMemoryQueueRepository implements QueueRepository {
  final List<QueueItem> _items = [];
  final _controller = StreamController<List<QueueItem>>.broadcast();

  @override
  Future<void> enqueue(QueueItem item) async {
    _items.add(item);
    _controller.add(List.unmodifiable(_items));
  }

  @override
  Future<List<QueueItem>> getByStatus(QueueStatus status) async =>
      _items.where((i) => i.status == status).toList();

  @override
  Future<void> updateStatus(String idempotencyKey, QueueStatus status) async {
    final idx = _items.indexWhere((i) => i.idempotencyKey == idempotencyKey);
    if (idx >= 0) _items[idx] = _items[idx].copyWith(status: status);
    _controller.add(List.unmodifiable(_items));
  }

  @override
  Stream<List<QueueItem>> watchAll() => _controller.stream;

  void dispose() => _controller.close();
}
