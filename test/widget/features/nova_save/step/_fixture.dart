import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_wallet/l10n/l10n.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_status.dart';
import 'package:nova_wallet/src/core/queue/domain/repositories/queue_repository.dart';
import 'package:nova_wallet/src/core/queue/domain/usecases/enqueue_transaction_usecase.dart';
import 'package:nova_wallet/src/features/nova_save/domain/entities/savings_goal.dart';
import 'package:nova_wallet/src/features/nova_save/domain/usecases/contribute_to_goal_usecase.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/cubit/savings_goal_cubit.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/pages/nova_save_page.dart';

// Shared with send_money tests — same in-memory fake, no Drift.
class FakeQueueRepository implements QueueRepository {
  final List<QueueItem> _items = [];
  final _controller = StreamController<List<QueueItem>>.broadcast();

  List<QueueItem> get items => List.unmodifiable(_items);
  List<QueueItem> get pendingItems =>
      _items.where((i) => i.status == QueueStatus.pending).toList();

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

class _NovaSaveFixture {
  FakeQueueRepository repo = FakeQueueRepository();
  bool isOffline = false;
  int targetKobo = 0;
  int currentKobo = 0;

  void reset() {
    repo.dispose();
    repo = FakeQueueRepository();
    isOffline = false;
    targetKobo = 0;
    currentKobo = 0;
  }

  Widget buildPage() => BlocProvider(
    create: (_) => SavingsGoalCubit(
      ContributeToGoalUseCase(EnqueueTransactionUseCase(repo)),
      goal: SavingsGoal(
        targetKobo: targetKobo,
        currentKobo: currentKobo,
      ),
      isOffline: isOffline,
    ),
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: NovaSavePage(),
    ),
  );
}

// Module-level singleton — reset inside theNovaSavePageIsDisplayed.
final fixture = _NovaSaveFixture();
