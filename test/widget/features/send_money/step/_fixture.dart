import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_wallet/l10n/l10n.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_status.dart';
import 'package:nova_wallet/src/core/queue/domain/repositories/queue_repository.dart';
import 'package:nova_wallet/src/core/queue/domain/usecases/enqueue_transaction_usecase.dart';
import 'package:nova_wallet/src/features/send_money/domain/usecases/send_money_usecase.dart';
import 'package:nova_wallet/src/features/send_money/presentation/cubit/send_money_cubit.dart';
import 'package:nova_wallet/src/features/send_money/presentation/pages/send_money_page.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/entities/wallet.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/repositories/wallet_home_repository.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/usecases/load_wallet_home_usecase.dart';
import 'package:nova_wallet/src/features/wallet_home/presentation/cubit/wallet_home_cubit.dart';

// In-memory queue — avoids Drift setup in widget tests.
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

class _SendMoneyFixture {
  FakeQueueRepository repo = FakeQueueRepository();
  bool isOffline = false;
  int walletBalanceKobo = 0;
  String? capturedIdempotencyKey;

  void reset() {
    repo.dispose();
    repo = FakeQueueRepository();
    isOffline = false;
    capturedIdempotencyKey = null;
  }

  Widget buildPage() => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => SendMoneyCubit(
          SendMoneyUseCase(EnqueueTransactionUseCase(repo)),
          isOffline: isOffline,
        ),
      ),
      BlocProvider(
        create: (_) => WalletHomeCubit(
          LoadWalletHomeUseCase(
            () async => WalletHomeData(
              wallet: Wallet(
                balanceKobo: walletBalanceKobo,
                ownerName: 'Tester',
              ),
              transactions: const [],
            ),
          ),
        ),
      ),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SendMoneyPage(),
    ),
  );
}

// Module-level singleton — reset inside theSendMoneyPageIsDisplayed.
final fixture = _SendMoneyFixture();
