import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nova_wallet/l10n/l10n.dart';
import 'package:nova_wallet/src/core/utils/kobo_formatter.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/cubit/savings_create_cubit.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/cubit/savings_create_state.dart';
import 'package:nova_wallet/src/shared/theme/app_theme.dart';
import 'package:nova_wallet/src/shared/widgets/offline_success_page.dart';
import 'package:nova_wallet/src/shared/widgets/pin_pad.dart';

final _nairaFmt = NumberFormat('#,##0.00');

class NovaSaveCreatePage extends StatefulWidget {
  const NovaSaveCreatePage({required this.onDone, this.onBack, super.key});

  final VoidCallback onDone;
  final VoidCallback? onBack;

  @override
  State<NovaSaveCreatePage> createState() => _NovaSaveCreatePageState();
}

class _NovaSaveCreatePageState extends State<NovaSaveCreatePage> {
  int _durationMonths = 12;
  String _frequency = 'monthly';
  String? _savingsAmountError;
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _periodController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavingsCreateCubit, SavingsCreateState>(
      builder: (context, state) {
        final cubit = context.read<SavingsCreateCubit>();
        return switch (state) {
          SavingsCategorySelection() => _CategoryPage(
            onBack: widget.onBack,
            onSelect: cubit.selectCategory,
          ),
          SavingsDurationFrequency() => _DurationPage(
            category: state.category,
            months: _durationMonths,
            frequency: _frequency,
            onMonthsChanged: (v) => setState(() => _durationMonths = v),
            onFrequencyChanged: (v) => setState(() => _frequency = v),
            onBack: cubit.back,
            onNext: () {
              cubit.setDurationFrequency(
                months: _durationMonths,
                frequency: _frequency,
              );
              cubit.proceedToAmount();
            },
          ),
          SavingsAmountEntry() => _AmountPage(
            nameController: _nameController,
            targetController: _targetController,
            periodController: _periodController,
            amountError: _savingsAmountError,
            onBack: cubit.back,
            onErrorCleared: () => setState(() => _savingsAmountError = null),
            onNext: () {
              final targetNaira = double.tryParse(
                _targetController.text.replaceAll(',', ''),
              );
              final periodNaira = double.tryParse(
                _periodController.text.replaceAll(',', ''),
              );
              if (targetNaira == null ||
                  targetNaira <= 0 ||
                  periodNaira == null ||
                  periodNaira <= 0) {
                setState(
                  () => _savingsAmountError = context.l10n.invalidSavingsAmount,
                );
                return;
              }
              setState(() => _savingsAmountError = null);
              cubit.setAmount(
                name: _nameController.text.trim(),
                targetKobo: (targetNaira * 100).round(),
                amountPerPeriodKobo: (periodNaira * 100).round(),
              );
            },
          ),
          SavingsConfirmation() || SavingsSubmitting() => _ConfirmationPage(
            state: state is SavingsConfirmation ? state : (state as SavingsSubmitting).confirmation,
            isSubmitting: state is SavingsSubmitting,
            onBack: cubit.back,
            onAuthorize: cubit.proceedToPin,
          ),
          SavingsAwaitingPin(:final remainingAttempts, :final pinError, :final confirmation) =>
            _PinPage(
              amountKobo: confirmation.amountPerPeriodKobo,
              pinError: pinError == null ? null : context.l10n.wrongPin(remainingAttempts),
              onBack: cubit.back,
              onComplete: (pin) => unawaited(cubit.submitPin(pin)),
            ),
          SavingsCreated(:final goal, :final isOffline) => isOffline
            ? OfflineSuccessPage(
                amountKobo: goal.amountPerPeriodKobo,
                type: OfflineSuccessType.save,
                onBackToHome: widget.onDone,
              )
            : _SuccessPage(goal: goal, onDone: widget.onDone),
          SavingsCreateError(:final message) => _ErrorPage(
            message: message == 'pinLocked' ? context.l10n.pinLocked : message,
            onRetry: cubit.reset,
          ),
        };
      },
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current});

  final int current;

  @override
  Widget build(BuildContext context) {
    const total = 5;
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
                    ? AppColors.secondary
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

class _CategoryPage extends StatelessWidget {
  const _CategoryPage({required this.onSelect, this.onBack});
  final void Function(String) onSelect;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = [
      (
        'emergency',
        l10n.savingsCategoryEmergency,
        l10n.savingsCategoryEmergencyDesc,
        Icons.emergency_rounded,
        AppColors.error,
      ),
      (
        'target',
        l10n.savingsCategoryTarget,
        l10n.savingsCategoryTargetDesc,
        Icons.flag_rounded,
        AppColors.primary,
      ),
      (
        'fixed',
        l10n.savingsCategoryFixed,
        l10n.savingsCategoryFixedDesc,
        Icons.lock_rounded,
        AppColors.secondary,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createSavingsTitle),
        leading: onBack != null ? BackButton(onPressed: onBack) : null,
      ),
      body: Column(
        children: [
          const _StepIndicator(current: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.selectCategoryHint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: categories.map((c) {
                final (key, name, desc, icon, color) = c;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => onSelect(key),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(icon, color: color, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  desc,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationPage extends StatelessWidget {
  const _DurationPage({
    required this.category,
    required this.months,
    required this.frequency,
    required this.onMonthsChanged,
    required this.onFrequencyChanged,
    required this.onBack,
    required this.onNext,
  });
  final String category;
  final int months;
  final String frequency;
  final void Function(int) onMonthsChanged;
  final void Function(String) onFrequencyChanged;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createSavingsTitle),
        leading: BackButton(onPressed: onBack),
      ),
      body: Column(
        children: [
          const _StepIndicator(current: 2),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.durationLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [3, 6, 12, 24].map((m) {
                      final selected = m == months;
                      return ChoiceChip(
                        label: Text(l10n.months(m)),
                        selected: selected,
                        onSelected: (_) => onMonthsChanged(m),
                        selectedColor: AppColors.secondary,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.frequencyLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...['daily', 'weekly', 'monthly'].map((f) {
                    final label = switch (f) {
                      'daily' => l10n.frequencyDaily,
                      'weekly' => l10n.frequencyWeekly,
                      _ => l10n.frequencyMonthly,
                    };
                    return RadioListTile<String>(
                      title: Text(label),
                      value: f,
                      groupValue: frequency,
                      onChanged: (v) => onFrequencyChanged(v!),
                      activeColor: AppColors.secondary,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
                onPressed: onNext,
                child: Text(l10n.continueButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountPage extends StatelessWidget {
  const _AmountPage({
    required this.nameController,
    required this.targetController,
    required this.periodController,
    required this.onBack,
    required this.onNext,
    required this.onErrorCleared,
    this.amountError,
  });
  final TextEditingController nameController;
  final TextEditingController targetController;
  final TextEditingController periodController;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onErrorCleared;
  final String? amountError;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createSavingsTitle),
        leading: BackButton(onPressed: onBack),
      ),
      body: Column(
        children: [
          const _StepIndicator(current: 3),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: l10n.savingsPlanName,
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: targetController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                      LengthLimitingTextInputFormatter(14),
                    ],
                    onChanged: (_) => onErrorCleared(),
                    decoration: InputDecoration(
                      labelText: l10n.targetAmountLabel,
                      errorText: amountError,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: periodController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                      LengthLimitingTextInputFormatter(14),
                    ],
                    onChanged: (_) => onErrorCleared(),
                    decoration: InputDecoration(
                      labelText: l10n.amountPerPeriodLabel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [10000, 50000, 100000, 500000].map((kobo) {
                      return ActionChip(
                        label: Text(formatKobo(kobo)),
                        onPressed: () {
                          periodController.text = _nairaFmt.format(kobo / 100);
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
                onPressed: onNext,
                child: Text(l10n.continueButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationPage extends StatelessWidget {
  const _ConfirmationPage({
    required this.state,
    required this.isSubmitting,
    required this.onBack,
    required this.onAuthorize,
  });
  final SavingsConfirmation state;
  final bool isSubmitting;
  final VoidCallback onBack;
  final VoidCallback onAuthorize;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categoryLabel = switch (state.category) {
      'emergency' => l10n.savingsCategoryEmergency,
      'fixed' => l10n.savingsCategoryFixed,
      _ => l10n.savingsCategoryTarget,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.confirmSavingsTitle),
        leading: BackButton(onPressed: isSubmitting ? null : onBack),
      ),
      body: Column(
        children: [
          const _StepIndicator(current: 4),
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
                    _SummaryRow(label: l10n.savingsPlanName, value: state.name),
                    const Divider(height: 24),
                    _SummaryRow(label: l10n.categoryLabel, value: categoryLabel),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: l10n.durationSummary,
                      value: l10n.months(state.durationMonths),
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: l10n.frequencySummary,
                      value: switch (state.frequency) {
                        'daily' => l10n.frequencyDaily,
                        'weekly' => l10n.frequencyWeekly,
                        _ => l10n.frequencyMonthly,
                      },
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: l10n.targetAmountLabel,
                      value: formatKobo(state.targetKobo),
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: l10n.amountPerPeriodLabel,
                      value: formatKobo(state.amountPerPeriodKobo),
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
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
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
                    : Text(l10n.authorizeButton),
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
          const _StepIndicator(current: 5),
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
  const _SuccessPage({required this.goal, required this.onDone});
  final dynamic goal;
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
                decoration: const BoxDecoration(
                  color: Color(0x1FC9962C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.savings_rounded,
                  size: 40,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.savingsCreatedSuccess,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
                onPressed: onDone,
                child: Text(context.l10n.backToHome),
              ),
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
