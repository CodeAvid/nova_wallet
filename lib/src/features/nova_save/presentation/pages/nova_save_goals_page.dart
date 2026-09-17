import 'package:flutter/material.dart';
import 'package:nova_wallet/l10n/l10n.dart';
import 'package:nova_wallet/src/core/utils/kobo_formatter.dart';
import 'package:nova_wallet/src/features/nova_save/domain/entities/savings_goal.dart';
import 'package:nova_wallet/src/features/nova_save/domain/repositories/savings_repository.dart';
import 'package:nova_wallet/src/shared/theme/app_theme.dart';

class NovaSaveGoalsPage extends StatelessWidget {
  const NovaSaveGoalsPage({
    required this.savingsRepo,
    required this.onGoalTap,
    required this.onCreateTap,
    this.onBack,
    super.key,
  });

  final SavingsRepository savingsRepo;
  final void Function(SavingsGoal) onGoalTap;
  final VoidCallback onCreateTap;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.novaSaveTitle),
        leading: onBack != null ? BackButton(onPressed: onBack) : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(context.l10n.newSavingsPlan),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<SavingsGoal>>(
        stream: savingsRepo.watchAll(),
        builder: (context, snapshot) {
          final goals = snapshot.data ?? [];
          if (goals.isEmpty) {
            return _EmptyState(onCreateTap: onCreateTap);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _GoalCard(goal: goals[i], onTap: () => onGoalTap(goals[i])),
            ),
          );
        },
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal, required this.onTap});

  final SavingsGoal goal;
  final VoidCallback onTap;

  IconData get _icon => switch (goal.category) {
    'emergency' => Icons.emergency_rounded,
    'fixed' => Icons.lock_rounded,
    _ => Icons.flag_rounded,
  };

  Color get _color => switch (goal.category) {
    'emergency' => AppColors.error,
    'fixed' => AppColors.secondary,
    _ => AppColors.primary,
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: goal.name,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_icon, color: _color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          context.l10n.goalTarget(formatKobo(goal.targetKobo)),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
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
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(_color),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${goal.progressPercent}%',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreateTap});
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.savings_outlined,
              size: 56,
              color: AppColors.secondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.noSavingsPlans,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.noSavingsPlansBody,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
                onPressed: onCreateTap,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(context.l10n.newSavingsPlan),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
