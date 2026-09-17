import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_item.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_status.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/entities/transaction.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/repositories/wallet_home_repository.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/usecases/load_wallet_home_usecase.dart';
import 'package:nova_wallet/src/features/wallet_home/presentation/cubit/wallet_home_state.dart';

class WalletHomeCubit extends Cubit<WalletHomeState> {
  WalletHomeCubit(
    this._loadWalletHome, {
    Stream<List<QueueItem>>? queueStream,
  }) : super(const WalletHomeLoading()) {
    _queueStream = queueStream;
    unawaited(load());
  }

  final LoadWalletHomeUseCase _loadWalletHome;
  Stream<List<QueueItem>>? _queueStream;
  StreamSubscription<List<QueueItem>>? _queueSub;
  WalletHomeData? _baseData;
  List<QueueItem> _queueItems = [];

  Future<void> refresh() async {
    emit(const WalletHomeLoading());
    await load();
  }

  Future<void> load() async {
    try {
      final data = await _loadWalletHome();
      _baseData = data;
      await _queueSub?.cancel();
      _queueSub = _queueStream?.listen(_onQueueUpdate);
      _rebuild();
    } on Object {
      emit(const WalletHomeFailure());
    }
  }

  Future<void> _onQueueUpdate(List<QueueItem> items) async {
    _queueItems = items;
    try {
      _baseData = await _loadWalletHome();
    } on Object {
      // keep existing _baseData on reload failure
    }
    _rebuild();
  }

  void _rebuild() {
    final base = _baseData;
    if (base == null) return;

    final activeItems = _queueItems
        .where((i) => i.status == QueueStatus.pending || i.status == QueueStatus.sending)
        .toList();

    final pendingDebits = activeItems
        .where((i) => i.type != TransactionType.topUp)
        .fold<int>(0, (s, i) => s + i.amountKobo);
    final pendingCredits = activeItems
        .where((i) => i.type == TransactionType.topUp)
        .fold<int>(0, (s, i) => s + i.amountKobo);
    final computed = (base.wallet.balanceKobo - pendingDebits + pendingCredits).clamp(0, 1 << 53);

    // Display all non-failed queue items (confirmed items must remain visible)
    final displayItems = _queueItems.where((i) => i.status != QueueStatus.failed).toList();
    final queueTxns = displayItems.map((i) {
      final isTopUp = i.type == TransactionType.topUp;
      final isPending = i.status == QueueStatus.pending || i.status == QueueStatus.sending;
      return Transaction(
        id: i.idempotencyKey,
        title: isTopUp ? 'Top Up' : (i.type == TransactionType.send ? 'Transfer' : 'NovaSave'),
        counterparty: isTopUp ? 'Wallet' : _extractCounterparty(i),
        amountKobo: isTopUp ? i.amountKobo : -i.amountKobo,
        date: i.createdAt,
        category: isTopUp
            ? TransactionCategory.topUp
            : (i.type == TransactionType.send ? TransactionCategory.transfer : TransactionCategory.savings),
        isPending: isPending,
      );
    }).toList();

    final allTxns = [...queueTxns, ...base.transactions]
      ..sort((a, b) => b.date.compareTo(a.date));

    emit(WalletHomeLoaded(
      wallet: base.wallet,
      transactions: List.unmodifiable(allTxns),
      computedBalanceKobo: computed,
    ));
  }

  String _extractCounterparty(QueueItem item) {
    if (item.type == TransactionType.saveContribution) return 'NovaSave';
    try {
      final map = jsonDecode(item.targetId) as Map<String, dynamic>;
      final name = map['name'] as String? ?? '';
      final account = map['account'] as String? ?? '';
      return name.isNotEmpty ? name : account;
    } on Object {
      return item.targetId;
    }
  }

  @override
  Future<void> close() async {
    await _queueSub?.cancel();
    return super.close();
  }
}
