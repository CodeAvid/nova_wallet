import 'package:equatable/equatable.dart';
import 'package:nova_wallet/src/features/nova_save/domain/entities/savings_goal.dart';

sealed class SavingsGoalState extends Equatable {
  const SavingsGoalState();
}

final class SavingsGoalInitial extends SavingsGoalState {
  const SavingsGoalInitial({required this.goal});

  final SavingsGoal goal;

  @override
  List<Object?> get props => [goal];
}

final class SavingsGoalContributed extends SavingsGoalState {
  const SavingsGoalContributed({
    required this.goal,
    required this.idempotencyKey,
  });

  final SavingsGoal goal;
  final String idempotencyKey;

  @override
  List<Object?> get props => [goal, idempotencyKey];
}

final class SavingsGoalAwaitingConfirmation extends SavingsGoalState {
  const SavingsGoalAwaitingConfirmation({
    required this.goal,
    required this.amountKobo,
  });

  final SavingsGoal goal;
  final int amountKobo;

  @override
  List<Object?> get props => [goal, amountKobo];
}

final class SavingsGoalAwaitingPin extends SavingsGoalState {
  const SavingsGoalAwaitingPin({
    required this.goal,
    required this.amountKobo,
    this.pinError,
    this.remainingAttempts = 3,
  });

  final SavingsGoal goal;
  final int amountKobo;
  final String? pinError;
  final int remainingAttempts;

  @override
  List<Object?> get props => [goal, amountKobo, pinError, remainingAttempts];
}

final class SavingsGoalError extends SavingsGoalState {
  const SavingsGoalError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
