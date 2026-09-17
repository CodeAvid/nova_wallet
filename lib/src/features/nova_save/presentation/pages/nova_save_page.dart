import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nova_wallet/l10n/l10n.dart';
import 'package:nova_wallet/src/core/utils/kobo_formatter.dart';
import 'package:nova_wallet/src/features/nova_save/domain/entities/savings_goal.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/cubit/savings_goal_cubit.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/cubit/savings_goal_state.dart';
import 'package:nova_wallet/src/shared/theme/app_theme.dart';
import 'package:nova_wallet/src/shared/widgets/pin_pad.dart';

class NovaSavePage extends StatefulWidget {
  const NovaSavePage({this.onBack, super.key});

  final VoidCallback? onBack;

  @override
  State<NovaSavePage> createState() => _NovaSavePageState();
}

class _NovaSavePageState extends State<NovaSavePage> {
  final _contributionController = TextEditingController();
  String? _contributionError;

  @override
  void dispose() {
    _contributionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SavingsGoalCubit, SavingsGoalState>(
      listener: (context, state) {
        if (state is SavingsGoalContributed) {
          unawaited(Fluttertoast.showToast(
            msg: context.l10n.contributionQueued,
            toastLength: Toast.LENGTH_SHORT,
          ));
          _contributionController.clear();
          setState(() => _contributionError = null);
        }
      },
      builder: (context, state) {
        final cubit = context.read<SavingsGoalCubit>();
        return switch (state) {
          SavingsGoalInitial() || SavingsGoalContributed() => _ContributionFormPage(
            goal: cubit.goal,
            controller: _contributionController,
            contributionError: _contributionError,
            onBack: widget.onBack,
            onErrorCleared: () => setState(() => _contributionError = null),
            onContribute: (amount) {
              if (amount == null ||
                  amount <= 0 ||
                  amount > cubit.goal.targetKobo - cubit.goal.currentKobo) {
                setState(
                  () => _contributionError = context.l10n.invalidContribution,
                );
                return;
              }
              setState(() => _contributionError = null);
              cubit.confirm(amount);
            },
          ),
          SavingsGoalAwaitingConfirmation(:final goal, :final amountKobo) =>
            _ContributeConfirmPage(
              goal: goal,
              amountKobo: amountKobo,
              onBack: cubit.back,
              onAuthorize: cubit.proceedToPin,
            ),
          SavingsGoalAwaitingPin(
            :final amountKobo,
            :final pinError,
            :final remainingAttempts,
          ) =>
            _ContributePinPage(
              amountKobo: amountKobo,
              pinError: pinError == null
                  ? null
                  : context.l10n.wrongPin(remainingAttempts),
              onBack: cubit.back,
              onComplete: (pin) => unawaited(cubit.submitPin(pin)),
            ),
          SavingsGoalError(:final message) => _ContributeErrorPage(
            message: message == 'pinLocked' ? context.l10n.pinLocked : message,
            onRetry: cubit.reset,
          ),
        };
      },
    );
  }
}

class _ContributionFormPage extends StatelessWidget {
  const _ContributionFormPage({
    required this.goal,
    required this.controller,
    required this.onBack,
    required this.onErrorCleared,
    required this.onContribute,
    this.contributionError,
  });

  final SavingsGoal goal;
  final TextEditingController controller;
  final VoidCallback? onBack;
  final VoidCallback onErrorCleared;
  final void Function(int?) onContribute;
  final String? contributionError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.savingsDetailTitle),
        leading: onBack != null ? BackButton(onPressed: onBack) : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatKobo(goal.currentKobo),
                                  style: context.currencyLg,
                                ),
                                Text(
                                  context.l10n.goalOf(formatKobo(goal.targetKobo)),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Semantics(
                                label: context.l10n.savingsProgressLabel,
                                child: Text(
                                  '${goal.progressPercent}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: goal.targetKobo == 0
                                ? 0
                                : goal.currentKobo / goal.targetKobo,
                            minHeight: 8,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    context.l10n.contributeButton,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    label: context.l10n.contributionAmount,
                    child: TextField(
                      key: const Key('contributionField'),
                      controller: controller,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12),
                      ],
                      onChanged: (_) => onErrorCleared(),
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.02 * 32,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                      decoration: InputDecoration(
                        labelText: context.l10n.contributionFieldLabel,
                        errorText: contributionError,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [50000, 100000, 500000].map((kobo) {
                      return ActionChip(
                        tooltip: context.l10n.contributeAmount(formatKobo(kobo)),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Semantics(
                label: context.l10n.contributeToGoal,
                child: ElevatedButton(
                  key: const Key('contributeButton'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                  ),
                  onPressed: () =>
                      onContribute(int.tryParse(controller.text)),
                  child: Text(context.l10n.contributeButton),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContributeConfirmPage extends StatelessWidget {
  const _ContributeConfirmPage({
    required this.goal,
    required this.amountKobo,
    required this.onBack,
    required this.onAuthorize,
  });

  final SavingsGoal goal;
  final int amountKobo;
  final VoidCallback onBack;
  final VoidCallback onAuthorize;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.confirmSavingsTitle),
        leading: BackButton(onPressed: onBack),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _SummaryRow(label: l10n.goalLabel, value: goal.name),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: l10n.amountSummary,
                      value: formatKobo(amountKobo),
                    ),
                    const Divider(height: 24),
                    _SummaryRow(label: l10n.feeSummary, value: l10n.freeFee),
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
                key: const Key('authorizeContributeButton'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
                onPressed: onAuthorize,
                child: Text(l10n.authorizeButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContributePinPage extends StatelessWidget {
  const _ContributePinPage({
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
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
    );
  }
}

class _ContributeErrorPage extends StatelessWidget {
  const _ContributeErrorPage({
    required this.message,
    required this.onRetry,
  });

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
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
