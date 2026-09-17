import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/l10n/l10n.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/entities/transaction.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/entities/wallet.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/repositories/wallet_home_repository.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/usecases/load_wallet_home_usecase.dart';
import 'package:nova_wallet/src/features/wallet_home/presentation/cubit/wallet_home_cubit.dart';
import 'package:nova_wallet/src/features/wallet_home/presentation/pages/wallet_home_page.dart';
import 'package:nova_wallet/src/shared/theme/app_theme.dart';

void main() {
  testWidgets('renders a lazy transaction feed at large text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => WalletHomeCubit(
          LoadWalletHomeUseCase(_WalletHomeRepository().call),
        ),
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: WalletHomePage(
              onSendTap: () {},
              onNovaSaveTap: () {},
              onTopUpTap: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(find.text('Transfer'), findsWidgets);
    expect(find.text('Recipient 96'), findsNothing);
    expect(find.byType(RefreshIndicator), findsOneWidget);
  });
}

class _WalletHomeRepository {
  Future<WalletHomeData> call() async => WalletHomeData(
    wallet: const Wallet(balanceKobo: 500000, ownerName: 'Ada Okafor'),
    transactions: List.generate(
      96,
      (index) => Transaction(
        id: '$index',
        title: 'Transfer',
        counterparty: 'Recipient ${index + 1}',
        amountKobo: -10000,
        date: DateTime(2026, 9),
        category: TransactionCategory.transfer,
      ),
    ),
  );
}
