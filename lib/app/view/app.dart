import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_wallet/l10n/l10n.dart';
import 'package:nova_wallet/src/core/network/connectivity_service.dart';
import 'package:nova_wallet/src/core/network/drift_backend_receipt_store.dart';
import 'package:nova_wallet/src/core/network/fake_api_client.dart';
import 'package:nova_wallet/src/core/notifications/local_notification_service.dart';
import 'package:nova_wallet/src/core/queue/data/datasources/queue_database.dart';
import 'package:nova_wallet/src/core/queue/data/repositories/drift_queue_repository.dart';
import 'package:nova_wallet/src/core/queue/domain/usecases/enqueue_transaction_usecase.dart';
import 'package:nova_wallet/src/core/queue/domain/usecases/replay_queue_usecase.dart';
import 'package:nova_wallet/src/core/queue/presentation/cubit/queue_cubit.dart';
import 'package:nova_wallet/src/features/nova_save/data/repositories/drift_savings_repository.dart';
import 'package:nova_wallet/src/features/nova_save/domain/usecases/create_savings_goal_usecase.dart';
import 'package:nova_wallet/src/features/wallet_home/data/repositories/fake_wallet_home_repository.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/usecases/load_wallet_home_usecase.dart';
import 'package:nova_wallet/src/features/wallet_home/presentation/cubit/wallet_home_cubit.dart';
import 'package:nova_wallet/src/shared/router/app_router.dart';
import 'package:nova_wallet/src/shared/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final QueueDatabase _database = QueueDatabase.open();
  late final DriftQueueRepository _repository =
      DriftQueueRepository(_database);
  late final FakeApiClient _apiClient = FakeApiClient(
    receipts: DriftBackendReceiptStore(_database),
  );
  late final LocalNotificationService _notifications =
      LocalNotificationService();
  late final EnqueueTransactionUseCase _enqueue =
      EnqueueTransactionUseCase(_repository);
  late final QueueCubit _queueCubit = QueueCubit(
    enqueue: _enqueue,
    replay: ReplayQueueUseCase(_repository, _apiClient),
    connectivity: DeviceConnectivityService(Connectivity(), _apiClient),
    notifications: _notifications,
  );
  late final DriftSavingsRepository _savingsRepo =
      DriftSavingsRepository(_database);
  late final CreateSavingsGoalUseCase _createSavingsGoal =
      CreateSavingsGoalUseCase(_savingsRepo, _enqueue);
  late final LoadWalletHomeUseCase _loadWalletHome = LoadWalletHomeUseCase(
    FakeWalletHomeRepository(_apiClient).call,
  );
  late final WalletHomeCubit _walletHomeCubit = WalletHomeCubit(
    _loadWalletHome,
    queueStream: _enqueue.watchAll(),
  );
  late final GoRouter _router = buildAppRouter(
    _queueCubit,
    _savingsRepo,
    _createSavingsGoal,
  );

  @override
  void initState() {
    super.initState();
    unawaited(_initializeServices());
  }

  Future<void> _initializeServices() async {
    await _notifications.initialize();
    await _queueCubit.start();
  }

  @override
  void dispose() {
    unawaited(_walletHomeCubit.close());
    unawaited(_queueCubit.close());
    unawaited(_repository.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _queueCubit),
        BlocProvider.value(value: _walletHomeCubit),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
