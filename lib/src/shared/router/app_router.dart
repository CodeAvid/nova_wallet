import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_wallet/src/core/queue/presentation/cubit/queue_cubit.dart';
import 'package:nova_wallet/src/features/nova_save/domain/entities/savings_goal.dart';
import 'package:nova_wallet/src/features/nova_save/domain/repositories/savings_repository.dart';
import 'package:nova_wallet/src/features/nova_save/domain/usecases/create_savings_goal_usecase.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/cubit/savings_create_cubit.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/cubit/savings_goal_cubit.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/pages/nova_save_create_page.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/pages/nova_save_goals_page.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/pages/nova_save_page.dart';
import 'package:nova_wallet/src/features/send_money/presentation/cubit/send_money_cubit.dart';
import 'package:nova_wallet/src/features/send_money/presentation/pages/send_money_page.dart';
import 'package:nova_wallet/src/features/top_up/presentation/cubit/top_up_cubit.dart';
import 'package:nova_wallet/src/features/top_up/presentation/pages/top_up_page.dart';
import 'package:nova_wallet/src/features/wallet_home/presentation/pages/wallet_home_page.dart';
import 'package:nova_wallet/src/shared/widgets/connectivity_banner.dart';

GoRouter buildAppRouter(
  QueueCubit queueCubit,
  SavingsRepository savingsRepo,
  CreateSavingsGoalUseCase createSavingsGoal,
) =>
    GoRouter(
      routes: [
        ShellRoute(
          builder: (context, _, child) => ConnectivityBanner(child: child),
          routes: [
            GoRoute(
              path: '/',
              builder: (context, _) => WalletHomePage(
                onSendTap: () => context.go('/send'),
                onNovaSaveTap: () => context.go('/nova-save'),
                onTopUpTap: () => context.go('/top-up'),
              ),
            ),
            GoRoute(
              path: '/send',
              builder: (context, state) => BlocProvider(
                create: (_) => SendMoneyCubit(queueCubit),
                child: SendMoneyPage(
                  onExit: () => context.go('/'),
                ),
              ),
            ),
            GoRoute(
              path: '/top-up',
              builder: (context, _) => BlocProvider(
                create: (_) => TopUpCubit(queueCubit),
                child: TopUpPage(onExit: () => context.go('/')),
              ),
            ),
            GoRoute(
              path: '/nova-save',
              builder: (context, _) => NovaSaveGoalsPage(
                savingsRepo: savingsRepo,
                onBack: () => context.go('/'),
                onGoalTap: (goal) =>
                    context.go('/nova-save/detail', extra: goal),
                onCreateTap: () => context.go('/nova-save/create'),
              ),
            ),
            GoRoute(
              path: '/nova-save/create',
              builder: (context, _) => BlocProvider(
                create: (_) =>
                    SavingsCreateCubit(queueCubit, createSavingsGoal),
                child: NovaSaveCreatePage(
                  onBack: () => context.go('/nova-save'),
                  onDone: () => context.go('/'),
                ),
              ),
            ),
            GoRoute(
              path: '/nova-save/detail',
              builder: (context, state) {
                final goal = state.extra as SavingsGoal? ??
                    const SavingsGoal(
                      targetKobo: 1000000,
                      currentKobo: 0,
                    );
                return BlocProvider(
                  create: (_) => SavingsGoalCubit(queueCubit, goal: goal),
                  child: NovaSavePage(
                    onBack: () => context.go('/nova-save'),
                  ),
                );
              },
            ),
            GoRoute(
              path: '/nova-save/goal',
              redirect: (_, __) => '/nova-save',
            ),
          ],
        ),
      ],
    );
