import 'package:equatable/equatable.dart';
import 'package:nova_wallet/src/features/nova_save/domain/entities/savings_goal.dart';

sealed class SavingsCreateState extends Equatable {
  const SavingsCreateState();
}

final class SavingsCategorySelection extends SavingsCreateState {
  const SavingsCategorySelection();
  @override
  List<Object?> get props => [];
}

final class SavingsDurationFrequency extends SavingsCreateState {
  const SavingsDurationFrequency({
    required this.category,
    this.durationMonths = 12,
    this.frequency = 'monthly',
  });
  final String category;
  final int durationMonths;
  final String frequency;
  @override
  List<Object?> get props => [category, durationMonths, frequency];
}

final class SavingsAmountEntry extends SavingsCreateState {
  const SavingsAmountEntry({
    required this.category,
    required this.durationMonths,
    required this.frequency,
    this.name = '',
  });
  final String category;
  final int durationMonths;
  final String frequency;
  final String name;
  @override
  List<Object?> get props => [category, durationMonths, frequency, name];
}

final class SavingsConfirmation extends SavingsCreateState {
  const SavingsConfirmation({
    required this.category,
    required this.durationMonths,
    required this.frequency,
    required this.name,
    required this.targetKobo,
    required this.amountPerPeriodKobo,
  });
  final String category;
  final int durationMonths;
  final String frequency;
  final String name;
  final int targetKobo;
  final int amountPerPeriodKobo;
  @override
  List<Object?> get props => [
    category, durationMonths, frequency, name, targetKobo, amountPerPeriodKobo,
  ];
}

final class SavingsAwaitingPin extends SavingsCreateState {
  const SavingsAwaitingPin({
    required this.confirmation,
    this.pinError,
    this.remainingAttempts = 3,
  });
  final SavingsConfirmation confirmation;
  final String? pinError;
  final int remainingAttempts;
  @override
  List<Object?> get props => [confirmation, pinError, remainingAttempts];
}

final class SavingsSubmitting extends SavingsCreateState {
  const SavingsSubmitting({required this.confirmation});
  final SavingsConfirmation confirmation;
  @override
  List<Object?> get props => [confirmation];
}

final class SavingsCreated extends SavingsCreateState {
  const SavingsCreated({
    required this.goal,
    required this.isOffline,
  });
  final SavingsGoal goal;
  final bool isOffline;
  @override
  List<Object?> get props => [goal, isOffline];
}

final class SavingsCreateError extends SavingsCreateState {
  const SavingsCreateError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
