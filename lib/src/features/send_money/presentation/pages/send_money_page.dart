import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nova_wallet/l10n/l10n.dart';
import 'package:nova_wallet/src/core/utils/kobo_formatter.dart';
import 'package:nova_wallet/src/features/send_money/presentation/cubit/send_money_cubit.dart';
import 'package:nova_wallet/src/features/send_money/presentation/cubit/send_money_state.dart';
import 'package:nova_wallet/src/features/wallet_home/presentation/cubit/wallet_home_cubit.dart';
import 'package:nova_wallet/src/features/wallet_home/presentation/cubit/wallet_home_state.dart';
import 'package:nova_wallet/src/shared/theme/app_theme.dart';
import 'package:nova_wallet/src/shared/widgets/offline_success_page.dart';
import 'package:nova_wallet/src/shared/widgets/pin_pad.dart';

final _nairaFmt = NumberFormat('#,##0.00');


const _banks = [
  BankInfo(name: 'Access Bank', code: 'ACCESS'),
  BankInfo(name: 'GTBank', code: 'GTB'),
  BankInfo(name: 'First Bank', code: 'FIRSTBANK'),
  BankInfo(name: 'Zenith Bank', code: 'ZENITH'),
  BankInfo(name: 'UBA', code: 'UBA'),
  BankInfo(name: 'Fidelity Bank', code: 'FIDELITY'),
  BankInfo(name: 'Union Bank', code: 'UNION'),
  BankInfo(name: 'Sterling Bank', code: 'STERLING'),
  BankInfo(name: 'Opay', code: 'OPAY'),
  BankInfo(name: 'PalmPay', code: 'PALMPAY'),
  BankInfo(name: 'Kuda', code: 'KUDA'),
  BankInfo(name: 'Moniepoint', code: 'MONIEPOINT'),
];

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({this.onExit, super.key});

  final VoidCallback? onExit;

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _bankSearchController = TextEditingController();
  final _recipientController = TextEditingController(); // legacy flow
  String _bankQuery = '';
  String? _amountError;

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _bankSearchController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendMoneyCubit, SendMoneyState>(
      listener: (context, state) {
        if (state is SendMoneyBankSelection) {
          _bankQuery = '';
          _bankSearchController.clear();
          _accountController.clear();
          _amountController.clear();
        }
      },
      builder: (context, state) {
        final cubit = context.read<SendMoneyCubit>();
        return switch (state) {
          SendMoneyBankSelection() => _BankSelectionPage(
            query: _bankQuery,
            searchController: _bankSearchController,
            onQueryChanged: (q) => setState(() => _bankQuery = q),
            onSelect: cubit.selectBank,
            onBack: widget.onExit,
          ),
          SendMoneyAccountEntry(:final bank) => _AccountEntryPage(
            bank: bank,
            controller: _accountController,
            hasError: false,
            onBack: cubit.back,
            onSubmit: () => unawaited(
              cubit.lookupAccount(_accountController.text.trim()),
            ),
          ),
          SendMoneyLookupFailed(:final bank) => _AccountEntryPage(
            bank: bank,
            controller: _accountController,
            hasError: true,
            onBack: cubit.back,
            onSubmit: () => unawaited(
              cubit.lookupAccount(_accountController.text.trim()),
            ),
          ),
          SendMoneyLookingUp(:final bank) =>
            _AccountEntryPage(
              bank: bank,
              controller: _accountController,
              isLoading: true,
              onBack: cubit.back,
              onSubmit: null,
            ),
          SendMoneyAmountEntry(:final bank, :final accountNumber, :final accountName) =>
            _AmountEntryPage(
              bank: bank,
              accountNumber: accountNumber,
              accountName: accountName,
              controller: _amountController,
              amountError: _amountError,
              onBack: cubit.back,
              onErrorCleared: () => setState(() => _amountError = null),
              onNext: (balanceKobo) {
                final naira = double.tryParse(
                  _amountController.text.replaceAll(',', ''),
                );
                final koboAmount = naira != null ? (naira * 100).round() : null;
                if (koboAmount == null ||
                    koboAmount <= 0 ||
                    koboAmount > balanceKobo) {
                  setState(
                    () => _amountError = context.l10n.invalidSendAmount,
                  );
                  return;
                }
                setState(() => _amountError = null);
                cubit.setAmount(koboAmount);
              },
            ),
          SendMoneyConfirmation() ||
          SendMoneySubmitting() => _ConfirmationPage(
            bank: state is SendMoneyConfirmation
                ? state.bank
                : (state as SendMoneySubmitting).bank,
            accountNumber: state is SendMoneyConfirmation
                ? state.accountNumber
                : (state as SendMoneySubmitting).accountNumber,
            accountName: state is SendMoneyConfirmation
                ? state.accountName
                : (state as SendMoneySubmitting).accountName,
            amountKobo: state is SendMoneyConfirmation
                ? state.amountKobo
                : (state as SendMoneySubmitting).amountKobo,
            isSubmitting: state is SendMoneySubmitting,
            onBack: cubit.back,
            onAuthorize: cubit.proceedToPin,
          ),
          SendMoneyAwaitingPin(
            :final amountKobo,
            :final pinError,
            :final remainingAttempts,
          ) =>
            _PinPage(
              amountKobo: amountKobo,
              pinError: pinError == null
                  ? null
                  : context.l10n.wrongPin(remainingAttempts),
              onBack: cubit.back,
              onComplete: (pin) => unawaited(cubit.submitPin(pin)),
            ),
          SendMoneyQueued(:final amountKobo, :final isOffline) =>
            isOffline
                ? OfflineSuccessPage(
                    amountKobo: amountKobo,
                    type: OfflineSuccessType.send,
                    onBackToHome: () => widget.onExit?.call(),
                  )
                : _SuccessPage(
                    amountKobo: amountKobo,
                    onDone: () => widget.onExit?.call(),
                  ),
          SendMoneyError(:final message) => _ErrorPage(
            message: message == 'pinLocked'
                ? context.l10n.pinLocked
                : message,
            onRetry: cubit.reset,
          ),
          // Legacy 3-step flow (used when cubit is backed by SendMoneyUseCase)
          SendMoneyStep1() => _LegacyStep1Page(
            controller: _recipientController,
            onNext: () => cubit.setRecipient(_recipientController.text.trim()),
          ),
          SendMoneyStep2(:final recipientId) => _LegacyStep2Page(
            recipientId: recipientId,
            controller: _amountController,
            amountError: _amountError,
            onBack: cubit.back,
            onErrorCleared: () => setState(() => _amountError = null),
            onNext: (balanceKobo) {
              final kobo = int.tryParse(_amountController.text);
              if (kobo == null || kobo <= 0 || kobo > balanceKobo) {
                setState(
                  () => _amountError = context.l10n.invalidSendAmount,
                );
                return;
              }
              setState(() => _amountError = null);
              cubit.setAmount(kobo);
            },
          ),
          SendMoneyStep3(:final recipientId, :final amountKobo) => _LegacyStep3Page(
            recipientId: recipientId,
            amountKobo: amountKobo,
            onBack: cubit.back,
            onConfirm: () => unawaited(cubit.confirm()),
          ),
        };
      },
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(total, (i) {
          return Expanded(
            child: Container(
              height: 3,
              margin: i < total - 1
                  ? const EdgeInsets.only(right: 4)
                  : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: i < current
                    ? AppColors.primary
                    : Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BankSelectionPage extends StatelessWidget {
  const _BankSelectionPage({
    required this.query,
    required this.searchController,
    required this.onQueryChanged,
    required this.onSelect,
    this.onBack,
  });
  final String query;
  final TextEditingController searchController;
  final void Function(String) onQueryChanged;
  final void Function(BankInfo) onSelect;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final filtered = query.isEmpty
        ? _banks
        : _banks
            .where(
              (b) => b.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.selectBankTitle),
        leading: onBack != null ? BackButton(onPressed: onBack) : null,
      ),
      body: Column(
        children: [
          const _StepIndicator(current: 1, total: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: onQueryChanged,
              decoration: InputDecoration(
                hintText: context.l10n.searchBankHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(indent: 56),
              itemBuilder: (_, i) {
                final bank = filtered[i];
                return ListTile(
                  leading: _BankAvatar(bank.code),
                  title: Text(bank.name),
                  onTap: () => onSelect(bank),
                  trailing: const Icon(Icons.chevron_right_rounded),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BankAvatar extends StatelessWidget {
  const _BankAvatar(this.code);
  final String code;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      child: Text(
        code.substring(0, 1),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AccountEntryPage extends StatelessWidget {
  const _AccountEntryPage({
    required this.bank,
    required this.controller,
    required this.onBack,
    required this.onSubmit,
    this.isLoading = false,
    this.hasError = false,
  });
  final BankInfo bank;
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback? onSubmit;
  final bool isLoading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.sendMoneyTitle),
        leading: BackButton(onPressed: onBack),
      ),
      body: Column(
        children: [
          const _StepIndicator(current: 2, total: 5),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BankChip(bank: bank),
                  const SizedBox(height: 24),
                  TextField(
                    controller: controller,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: context.l10n.accountNumberLabel,
                      hintText: context.l10n.accountNumberHint,
                      errorText: hasError
                          ? context.l10n.accountLookupFailed
                          : null,
                      suffixIcon: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : null,
                    ),
                    onChanged: (v) {
                      if (v.length == 10 && onSubmit != null) onSubmit!();
                    },
                  ),
                  if (isLoading) ...[
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.lookingUpAccount,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: (isLoading || onSubmit == null)
                    ? null
                    : onSubmit,
                child: Text(context.l10n.continueButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BankChip extends StatelessWidget {
  const _BankChip({required this.bank});
  final BankInfo bank;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _BankAvatar(bank.code),
          const SizedBox(width: 10),
          Text(bank.name, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _AmountEntryPage extends StatelessWidget {
  const _AmountEntryPage({
    required this.bank,
    required this.accountNumber,
    required this.accountName,
    required this.controller,
    required this.onBack,
    required this.onNext,
    required this.onErrorCleared,
    this.amountError,
  });
  final BankInfo bank;
  final String accountNumber;
  final String accountName;
  final TextEditingController controller;
  final VoidCallback onBack;
  final void Function(int balanceKobo) onNext;
  final VoidCallback onErrorCleared;
  final String? amountError;

  @override
  Widget build(BuildContext context) {
    final balanceKobo = context.select<WalletHomeCubit, int>(
      (c) => c.state is WalletHomeLoaded
          ? (c.state as WalletHomeLoaded).displayBalanceKobo
          : 0,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.sendMoneyTitle),
        leading: BackButton(onPressed: onBack),
      ),
      body: Column(
        children: [
          const _StepIndicator(current: 3, total: 5),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _RecipientCard(
                    bank: bank,
                    accountNumber: accountNumber,
                    accountName: accountName,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: controller,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                      LengthLimitingTextInputFormatter(14),
                    ],
                    onChanged: (_) => onErrorCleared(),
                    decoration: InputDecoration(
                      labelText: context.l10n.amountFieldLabel,
                      helperText: amountError == null
                          ? context.l10n.availableAmount(
                              formatKobo(balanceKobo),
                            )
                          : null,
                      errorText: amountError,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [100000, 500000, 1000000, 5000000].map((kobo) {
                      return ActionChip(
                        key: Key('amountChip_${kobo ~/ 100}'),
                        label: Text(formatKobo(kobo)),
                        onPressed: () {
                          controller.text = _nairaFmt.format(kobo / 100);
                          onErrorCleared();
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => onNext(balanceKobo),
                child: Text(context.l10n.continueButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipientCard extends StatelessWidget {
  const _RecipientCard({
    required this.bank,
    required this.accountNumber,
    required this.accountName,
  });
  final BankInfo bank;
  final String accountNumber;
  final String accountName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accountName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${bank.name} · $accountNumber',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationPage extends StatelessWidget {
  const _ConfirmationPage({
    required this.bank,
    required this.accountNumber,
    required this.accountName,
    required this.amountKobo,
    required this.isSubmitting,
    required this.onBack,
    required this.onAuthorize,
  });
  final BankInfo bank;
  final String accountNumber;
  final String accountName;
  final int amountKobo;
  final bool isSubmitting;
  final VoidCallback onBack;
  final VoidCallback onAuthorize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.confirmTransferTitle),
        leading: BackButton(onPressed: isSubmitting ? null : onBack),
      ),
      body: Column(
        children: [
          const _StepIndicator(current: 4, total: 5),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _SummaryRow(
                      label: context.l10n.nameSummary,
                      value: accountName,
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: context.l10n.bankSummary,
                      value: bank.name,
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: context.l10n.accountSummary,
                      value: accountNumber,
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: context.l10n.amountSummary,
                      value: formatKobo(amountKobo),
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: context.l10n.feeSummary,
                      value: context.l10n.freeFee,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onAuthorize,
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(context.l10n.authorizeButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinPage extends StatelessWidget {
  const _PinPage({
    required this.amountKobo,
    required this.onBack,
    required this.onComplete,
    this.pinError,
  });
  final int amountKobo;
  final String? pinError;
  final VoidCallback onBack;
  final void Function(String) onComplete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.enterPinTitle),
        leading: BackButton(onPressed: onBack),
      ),
      body: Column(
        children: [
          const _StepIndicator(current: 5, total: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.enterPinSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatKobo(amountKobo),
                    style: context.currencyLg,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  PinPad(onComplete: onComplete, errorMessage: pinError),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessPage extends StatelessWidget {
  const _SuccessPage({required this.amountKobo, required this.onDone});
  final int amountKobo;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.successContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 40,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.transferSuccess,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                formatKobo(amountKobo),
                style: context.currencyDisplay,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(onPressed: onDone, child: Text(context.l10n.backToHome)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorPage extends StatelessWidget {
  const _ErrorPage({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(context.l10n.tryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

// ── Legacy 3-step pages — used when cubit is backed by SendMoneyUseCase ──────

class _LegacyStep1Page extends StatelessWidget {
  const _LegacyStep1Page({required this.controller, required this.onNext});
  final TextEditingController controller;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sendMoneyTitle)),
      body: Column(
        children: [
          const _StepIndicator(current: 1, total: 3),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.sendMoneyRecipientHint,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    label: context.l10n.recipientFieldLabel,
                    child: TextField(
                      key: const Key('recipientField'),
                      controller: controller,
                      textInputAction: TextInputAction.next,
                      maxLength: 64,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9-]')),
                      ],
                      decoration: InputDecoration(
                        labelText: context.l10n.recipientFieldLabel,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                key: const Key('nextButton'),
                onPressed: onNext,
                child: Text(context.l10n.continueButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegacyStep2Page extends StatelessWidget {
  const _LegacyStep2Page({
    required this.recipientId,
    required this.controller,
    required this.onBack,
    required this.onNext,
    required this.onErrorCleared,
    this.amountError,
  });
  final String recipientId;
  final TextEditingController controller;
  final VoidCallback onBack;
  final void Function(int balanceKobo) onNext;
  final VoidCallback onErrorCleared;
  final String? amountError;

  @override
  Widget build(BuildContext context) {
    final balanceKobo = context.select<WalletHomeCubit, int>(
      (c) => c.state is WalletHomeLoaded
          ? (c.state as WalletHomeLoaded).displayBalanceKobo
          : 0,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.sendMoneyTitle),
        leading: BackButton(onPressed: onBack),
      ),
      body: Column(
        children: [
          const _StepIndicator(current: 2, total: 3),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      context.l10n.sendTo(recipientId),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    key: const Key('amountField'),
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    onChanged: (_) => onErrorCleared(),
                    decoration: InputDecoration(
                      labelText: context.l10n.amountFieldLabel,
                      helperText: amountError == null
                          ? context.l10n.availableAmount(
                              formatKobo(balanceKobo),
                            )
                          : null,
                      errorText: amountError,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [100000, 500000, 1000000].map((kobo) {
                      return ActionChip(
                        key: Key('amountChip_${kobo ~/ 100}'),
                        label: Text(formatKobo(kobo)),
                        onPressed: () {
                          controller.text = '$kobo';
                          onErrorCleared();
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                key: const Key('nextButton'),
                onPressed: () => onNext(balanceKobo),
                child: Text(context.l10n.continueButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegacyStep3Page extends StatelessWidget {
  const _LegacyStep3Page({
    required this.recipientId,
    required this.amountKobo,
    required this.onBack,
    required this.onConfirm,
  });
  final String recipientId;
  final int amountKobo;
  final VoidCallback onBack;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.confirmTransferTitle),
        leading: BackButton(onPressed: onBack),
      ),
      body: Column(
        children: [
          const _StepIndicator(current: 3, total: 3),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _SummaryRow(
                      label: context.l10n.recipientSummary,
                      value: recipientId,
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: context.l10n.amountSummary,
                      value: formatKobo(amountKobo),
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: context.l10n.feeSummary,
                      value: context.l10n.freeFee,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Semantics(
                label: context.l10n.sendMoneyButtonLabel,
                child: ElevatedButton(
                  key: const Key('sendButton'),
                  onPressed: onConfirm,
                  child: Text(context.l10n.sendMoneyCtaButton),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
