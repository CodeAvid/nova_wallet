import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_wallet/src/core/network/connectivity_service.dart';
import 'package:nova_wallet/src/core/notifications/local_notification_service.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/core/queue/domain/usecases/enqueue_transaction_usecase.dart';
import 'package:nova_wallet/src/core/queue/domain/usecases/replay_queue_usecase.dart';
import 'package:nova_wallet/src/core/queue/presentation/cubit/queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  QueueCubit({
    required this._enqueue,
    required this._replay,
    required this._connectivity,
    required this._notifications,
  }) : super(const QueueState());

  final EnqueueTransactionUseCase _enqueue;
  final ReplayQueueUseCase _replay;
  final ConnectivityService _connectivity;
  final AppNotificationService _notifications;
  StreamSubscription<List<QueueItem>>? _itemsSubscription;
  StreamSubscription<bool>? _connectivitySubscription;

  Future<void> start() async {
    _itemsSubscription = _enqueue.watchAll().listen(
      (items) => emit(
        QueueState(
          items: items,
          isOnline: state.isOnline,
          isReplaying: state.isReplaying,
        ),
      ),
    );
    final online = await _connectivity.isOnline;
    emit(QueueState(items: state.items, isOnline: online));
    _connectivitySubscription = _connectivity.online.listen((connected) {
      emit(QueueState(items: state.items, isOnline: connected));
      if (connected) unawaited(replay());
    });
    if (online) await replay();
  }

  Future<String> enqueue({
    required String idempotencyKey,
    required TransactionType type,
    required int amountKobo,
    required String targetId,
  }) async {
    await _enqueue.execute(
      idempotencyKey: idempotencyKey,
      type: type,
      amountKobo: amountKobo,
      targetId: targetId,
    );
    if (state.isOnline) await replay();
    return idempotencyKey;
  }

  Future<void> replay() async {
    if (!state.isOnline || state.isReplaying) return;
    emit(QueueState(items: state.items, isOnline: true, isReplaying: true));
    final completed = await _replay.execute();
    emit(QueueState(items: state.items, isOnline: true));
    for (final item in completed) {
      final (title, body) = switch (item.type) {
        TransactionType.send => ('Transfer complete', 'Your transfer was completed.'),
        TransactionType.saveContribution => ('Contribution complete', 'Your NovaSave contribution was completed.'),
        TransactionType.topUp => ('Top-up complete', 'Your funds have been added to your wallet.'),
      };
      await _notifications.show(title: title, body: body);
    }
  }

  @override
  Future<void> close() async {
    await _itemsSubscription?.cancel();
    await _connectivitySubscription?.cancel();
    return super.close();
  }
}
