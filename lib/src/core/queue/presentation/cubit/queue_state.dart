import 'package:equatable/equatable.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';

class QueueState extends Equatable {
  const QueueState({
    this.items = const [],
    this.isOnline = false,
    this.isReplaying = false,
  });

  final List<QueueItem> items;
  final bool isOnline;
  final bool isReplaying;

  @override
  List<Object?> get props => [items, isOnline, isReplaying];
}
