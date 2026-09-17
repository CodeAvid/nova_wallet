import 'package:dart_mappable/dart_mappable.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_status.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';

part 'queue_item.mapper.dart';

@MappableClass()
class QueueItem with QueueItemMappable {
  const QueueItem({
    required this.idempotencyKey,
    required this.type,
    required this.amountKobo,
    required this.targetId,
    required this.status,
    required this.createdAt,
    required this.attemptCount,
  });

  final String idempotencyKey;
  final TransactionType type;
  final int amountKobo;
  final String targetId;
  final QueueStatus status;
  final DateTime createdAt;
  final int attemptCount;
}
