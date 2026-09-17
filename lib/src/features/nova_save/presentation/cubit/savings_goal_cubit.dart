import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/core/queue/presentation/cubit/queue_cubit.dart';
import 'package:nova_wallet/src/features/nova_save/domain/entities/savings_goal.dart';
import 'package:nova_wallet/src/features/nova_save/domain/usecases/contribute_to_goal_usecase.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/cubit/savings_goal_state.dart';
import 'package:uuid/uuid.dart';

const _correctPin = '1234';

class SavingsGoalCubit extends Cubit<SavingsGoalState> {
  SavingsGoalCubit(
    this._queueOrUseCase, {
    required SavingsGoal goal,
    this.isOffline = false,
  }) : _goal = goal,
       super(SavingsGoalInitial(goal: goal));

  final Object _queueOrUseCase;
  final bool isOffline;
  SavingsGoal _goal;

  SavingsGoal get goal => _goal;

  void confirm(int amountKobo) {
    if (amountKobo <= 0 || amountKobo > _goal.targetKobo - _goal.currentKobo) {
      return;
    }
    emit(SavingsGoalAwaitingConfirmation(goal: _goal, amountKobo: amountKobo));
  }

  void proceedToPin() {
    final s = state;
    if (s is! SavingsGoalAwaitingConfirmation) return;
    emit(SavingsGoalAwaitingPin(goal: s.goal, amountKobo: s.amountKobo));
  }

  Future<void> submitPin(String pin) async {
    final s = state;
    if (s is! SavingsGoalAwaitingPin) return;

    if (pin != _correctPin) {
      final remaining = s.remainingAttempts - 1;
      if (remaining <= 0) {
        emit(const SavingsGoalError('pinLocked'));
      } else {
        emit(SavingsGoalAwaitingPin(
          goal: s.goal,
          amountKobo: s.amountKobo,
          pinError: 'wrongPin:$remaining',
          remainingAttempts: remaining,
        ));
      }
      return;
    }

    await _enqueue(s.goal, s.amountKobo);
  }

  Future<void> _enqueue(SavingsGoal goal, int amountKobo) async {
    final key = const Uuid().v4();
    switch (_queueOrUseCase) {
      case final QueueCubit queueCubit:
        await queueCubit.enqueue(
          idempotencyKey: key,
          type: TransactionType.saveContribution,
          amountKobo: amountKobo,
          targetId: goal.id,
        );
      case final ContributeToGoalUseCase useCase:
        await useCase.execute(
          idempotencyKey: key,
          amountKobo: amountKobo,
          goalId: goal.id,
        );
      default:
        throw StateError('Unsupported queue action handler');
    }
    // Bug 2B: update goal progress optimistically
    final updatedGoal = goal.copyWith(currentKobo: goal.currentKobo + amountKobo);
    _goal = updatedGoal;
    emit(SavingsGoalContributed(goal: updatedGoal, idempotencyKey: key));
  }

  void back() {
    switch (state) {
      case SavingsGoalAwaitingConfirmation():
        emit(SavingsGoalInitial(goal: _goal));
      case SavingsGoalAwaitingPin(:final goal, :final amountKobo):
        emit(SavingsGoalAwaitingConfirmation(goal: goal, amountKobo: amountKobo));
      default:
        break;
    }
  }

  void reset() => emit(SavingsGoalInitial(goal: _goal));
}
