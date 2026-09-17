import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nova_wallet/l10n/l10n.dart';
import 'package:nova_wallet/src/core/utils/kobo_formatter.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/entities/transaction.dart';
import 'package:nova_wallet/src/features/wallet_home/presentation/cubit/wallet_home_cubit.dart';
import 'package:nova_wallet/src/features/wallet_home/presentation/cubit/wallet_home_state.dart';
import 'package:nova_wallet/src/shared/theme/app_theme.dart';
import 'package:nova_wallet/src/shared/widgets/pressable_scale.dart';

class WalletHomePage extends StatelessWidget {
  const WalletHomePage({
    required this.onSendTap,
    required this.onNovaSaveTap,
    required this.onTopUpTap,
    super.key,
  });

  final VoidCallback onSendTap;
  final VoidCallback onNovaSaveTap;
  final VoidCallback onTopUpTap;

  @override
  Widget build(BuildContext context) => _WalletHomeView(
    onSendTap: onSendTap,
    onNovaSaveTap: onNovaSaveTap,
    onTopUpTap: onTopUpTap,
  );
}

class _WalletHomeView extends StatelessWidget {
  const _WalletHomeView({
    required this.onSendTap,
    required this.onNovaSaveTap,
    required this.onTopUpTap,
  });

  final VoidCallback onSendTap;
  final VoidCallback onNovaSaveTap;
  final VoidCallback onTopUpTap;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: BlocBuilder<WalletHomeCubit, WalletHomeState>(
        builder: (context, state) => AnimatedSwitcher(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 240),
          child: switch (state) {
            WalletHomeLoading() => const _WalletHomeSkeleton(),
            WalletHomeFailure() => _WalletHomeError(
              onRetry: context.read<WalletHomeCubit>().load,
            ),
            WalletHomeLoaded() => RefreshIndicator.adaptive(
              onRefresh: context.read<WalletHomeCubit>().refresh,
              child: _LoadedWalletHome(
                state: state,
                onSendTap: onSendTap,
                onNovaSaveTap: onNovaSaveTap,
                onTopUpTap: onTopUpTap,
              ),
            ),
          },
        ),
      ),
    ),
  );
}

class _LoadedWalletHome extends StatelessWidget {
  const _LoadedWalletHome({
    required this.state,
    required this.onSendTap,
    required this.onNovaSaveTap,
    required this.onTopUpTap,
  });

  final WalletHomeLoaded state;
  final VoidCallback onSendTap;
  final VoidCallback onNovaSaveTap;
  final VoidCallback onTopUpTap;

  @override
  Widget build(BuildContext context) => ListView.builder(
    key: const PageStorageKey('wallet-home-scroll'),
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: state.transactions.isEmpty ? 2 : state.transactions.length + 1,
    itemBuilder: (context, index) {
      if (index == 0) {
        return _WalletHomeIntro(
          ownerName: state.wallet.ownerName,
          balanceKobo: state.displayBalanceKobo,
          transactionCount: state.transactions.length,
          onSendTap: onSendTap,
          onNovaSaveTap: onNovaSaveTap,
          onTopUpTap: onTopUpTap,
        );
      }
      if (state.transactions.isEmpty) {
        return _EmptyTransactions(onSendTap: onSendTap);
      }
      return Column(
        children: [
          _TransactionRow(tx: state.transactions[index - 1]),
          if (index < state.transactions.length)
            const Padding(
              padding: EdgeInsets.only(left: 56),
              child: Divider(),
            ),
        ],
      );
    },
  );
}

class _WalletHomeIntro extends StatelessWidget {
  const _WalletHomeIntro({
    required this.ownerName,
    required this.balanceKobo,
    required this.transactionCount,
    required this.onSendTap,
    required this.onNovaSaveTap,
    required this.onTopUpTap,
  });

  final String ownerName;
  final int balanceKobo;
  final int transactionCount;
  final VoidCallback onSendTap;
  final VoidCallback onNovaSaveTap;
  final VoidCallback onTopUpTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _Header(ownerName: ownerName),
      const SizedBox(height: 22),
      _BalanceHeroCard(balanceKobo: balanceKobo),
      const SizedBox(height: 16),
      _QuickActions(onSendTap: onSendTap, onNovaSaveTap: onNovaSaveTap, onTopUpTap: onTopUpTap),
      const SizedBox(height: 30),
      Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.recentTransactions,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Text(
            '$transactionCount',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.onSurfaceMuted.withValues(alpha: .62),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
    ],
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.ownerName});

  final String ownerName;

  @override
  Widget build(BuildContext context) {
    final firstName = ownerName.trim().split(RegExp(r'\s+')).first;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.goodMorning,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 2),
              Text(
                firstName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        Semantics(
          image: true,
          label: context.l10n.profileFor(firstName),
          child: CircleAvatar(
            radius: 23,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              firstName.isEmpty
                  ? '?'
                  : String.fromCharCode(firstName.runes.first).toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _BalanceHeroCard extends StatelessWidget {
  const _BalanceHeroCard({required this.balanceKobo});

  final int balanceKobo;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '${context.l10n.walletBalanceLabel}: ${formatKobo(balanceKobo)}',
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF314A9A), AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x382B3B7C),
            blurRadius: 24,
            offset: Offset(0, 12),
            spreadRadius: -8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.availableBalance,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: .78),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            formatKobo(balanceKobo),
            style: context.currencyDisplay.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Icon(
                Icons.account_balance_outlined,
                size: 16,
                color: Colors.white.withValues(alpha: .72),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  context.l10n.accountNumberMasked,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: .82),
                  ),
                ),
              ),
              IconButton(
                tooltip: context.l10n.copyAccountNumber,
                color: Colors.white,
                onPressed: () async {
                  await Clipboard.setData(
                    const ClipboardData(text: '0123456789'),
                  );
                  await Fluttertoast.showToast(
                    msg: context.l10n.accountNumberCopied,
                    toastLength: Toast.LENGTH_SHORT,
                  );
                },
                icon: const Icon(Icons.copy_outlined, size: 18),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onSendTap,
    required this.onNovaSaveTap,
    required this.onTopUpTap,
  });

  final VoidCallback onSendTap;
  final VoidCallback onNovaSaveTap;
  final VoidCallback onTopUpTap;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _ActionButton(
          key: const Key('sendAction'),
          icon: Icons.arrow_upward_rounded,
          label: context.l10n.sendButton,
          semanticLabel: context.l10n.sendMoneyButtonLabel,
          onPressed: onSendTap,
          filled: true,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _ActionButton(
          key: const Key('saveAction'),
          icon: Icons.savings_outlined,
          label: context.l10n.novaSaveTitle,
          semanticLabel: context.l10n.novaSaveButtonLabel,
          onPressed: onNovaSaveTap,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _ActionButton(
          key: const Key('topUpAction'),
          icon: Icons.add_rounded,
          label: context.l10n.topUpButton,
          semanticLabel: context.l10n.topUpButtonLabel,
          onPressed: onTopUpTap,
        ),
      ),
    ],
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.semanticLabel,
    required this.onPressed,
    this.filled = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final String semanticLabel;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) => PressableScale(
    onPressed: onPressed,
    semanticLabel: semanticLabel,
    child: Ink(
      height: 56,
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: filled ? null : Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 19,
            color: filled ? Colors.white : AppColors.primary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: filled ? Colors.white : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.tx});

  final Transaction tx;

  IconData get _icon => switch (tx.category) {
    TransactionCategory.transfer => Icons.swap_horiz_rounded,
    TransactionCategory.savings => Icons.savings_outlined,
    TransactionCategory.airtime => Icons.phone_android_outlined,
    TransactionCategory.data => Icons.wifi_rounded,
    TransactionCategory.topUp => Icons.add_circle_outline_rounded,
  };

  String _title(BuildContext context) => switch (tx.category) {
    TransactionCategory.transfer when tx.amountKobo > 0 =>
      context.l10n.transferReceived,
    TransactionCategory.transfer => context.l10n.transfer,
    TransactionCategory.savings => context.l10n.novaSaveTitle,
    TransactionCategory.airtime => context.l10n.airtime,
    TransactionCategory.data => context.l10n.dataBundle,
    TransactionCategory.topUp => tx.title,
  };

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.amountKobo > 0;
    final amount = '${isCredit ? '+' : '−'}${formatKobo(tx.amountKobo.abs())}';
    return Semantics(
      label: '${_title(context)}, ${tx.counterparty}, $amount',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isCredit
                    ? AppColors.successContainer
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _icon,
                size: 21,
                color: isCredit ? AppColors.success : AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title(context),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${tx.counterparty} · '
                    '${DateFormat.MMMd(
                      Localizations.localeOf(context).toLanguageTag(),
                    ).format(tx.date.toLocal())}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceMuted.withValues(alpha: .62),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: context.currencyMd.copyWith(
                    color: isCredit
                        ? AppColors.success
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (tx.isPending)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      context.l10n.pendingBadge,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.secondary,
                        fontSize: 9,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletHomeSkeleton extends StatelessWidget {
  const _WalletHomeSkeleton();

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey('wallet-loading'),
    padding: const EdgeInsets.all(20),
    children: [
      const _SkeletonBox(width: 156, height: 20),
      const SizedBox(height: 8),
      const _SkeletonBox(width: 112, height: 29),
      const SizedBox(height: 24),
      const _SkeletonBox(height: 174),
      const SizedBox(height: 16),
      const Row(
        children: [
          Expanded(child: _SkeletonBox(height: 56)),
          SizedBox(width: 12),
          Expanded(child: _SkeletonBox(height: 56)),
        ],
      ),
      const SizedBox(height: 32),
      ...List<Widget>.generate(
        6,
        (_) => const Padding(
          padding: EdgeInsets.only(bottom: 14),
          child: _SkeletonBox(height: 50),
        ),
      ),
    ],
  );
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.height, this.width});
  final double? width;
  final double height;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: height,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

class _WalletHomeError extends StatelessWidget {
  const _WalletHomeError({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    key: const ValueKey('wallet-error'),
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 42,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.walletLoadFailed,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(context.l10n.walletLoadFailedBody, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          SizedBox(
            width: 180,
            child: ElevatedButton(
              onPressed: onRetry,
              child: Text(context.l10n.tryAgain),
            ),
          ),
        ],
      ),
    ),
  );
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions({required this.onSendTap});
  final VoidCallback onSendTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.receipt_long_outlined,
          size: 44,
          color: AppColors.primary,
        ),
        const SizedBox(height: 12),
        Text(
          context.l10n.noTransactions,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(context.l10n.noTransactionsBody, textAlign: TextAlign.center),
        const SizedBox(height: 18),
        SizedBox(
          width: 190,
          child: ElevatedButton(
            onPressed: onSendTap,
            child: Text(context.l10n.sendButton),
          ),
        ),
      ],
    ),
  );
}
