import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_wallet/src/core/queue/presentation/cubit/queue_cubit.dart';
import 'package:nova_wallet/src/features/nova_save/domain/entities/savings_goal.dart';
import 'package:nova_wallet/src/features/nova_save/domain/usecases/create_savings_goal_usecase.dart';
import 'package:nova_wallet/src/features/nova_save/presentation/cubit/savings_create_state.dart';
import 'package:uuid/uuid.dart';

const _correctPin = '1234';

class SavingsCreateCubit extends Cubit<SavingsCreateState> {
  SavingsCreateCubit(this._queueCubit, this._createGoal)
      : super(const SavingsCategorySelection());

  final QueueCubit _queueCubit;
  final CreateSavingsGoalUseCase _createGoal;

  void selectCategory(String category) {
    emit(SavingsDurationFrequency(category: category));
  }

  void setDurationFrequency({required int months, required String frequency}) {
    final s = state;
    if (s is! SavingsDurationFrequency) return;
    emit(SavingsDurationFrequency(
      category: s.category,
      durationMonths: months,
      frequency: frequency,
    ));
  }

  void proceedToAmount() {
    final s = state;
    if (s is! SavingsDurationFrequency) return;
    if (s.durationMonths < 1 || s.durationMonths > 60) return;
    emit(SavingsAmountEntry(
      category: s.category,
      durationMonths: s.durationMonths,
      frequency: s.frequency,
    ));
  }

  void setAmount({
    required String name,
    required int targetKobo,
    required int amountPerPeriodKobo,
  }) {
    final s = state;
    if (s is! SavingsAmountEntry) return;
    if (targetKobo <= 0 || amountPerPeriodKobo <= 0) return;
    emit(SavingsConfirmation(
      category: s.category,
      durationMonths: s.durationMonths,
      frequency: s.frequency,
      name: name.isEmpty ? '${s.category} savings' : name,
      targetKobo: targetKobo,
      amountPerPeriodKobo: amountPerPeriodKobo,
    ));
  }

  void proceedToPin() {
    final s = state;
    if (s is! SavingsConfirmation) return;
    emit(SavingsAwaitingPin(confirmation: s));
  }

  Future<void> submitPin(String pin) async {
    final s = state;
    if (s is! SavingsAwaitingPin) return;

    if (pin != _correctPin) {
      final remaining = s.remainingAttempts - 1;
      if (remaining <= 0) {
        emit(const SavingsCreateError('pinLocked'));
      } else {
        emit(SavingsAwaitingPin(
          confirmation: s.confirmation,
          pinError: 'wrongPin:$remaining',
          remainingAttempts: remaining,
        ));
      }
      return;
    }

    await _submit(s.confirmation);
  }

  Future<void> _submit(SavingsConfirmation c) async {
    emit(SavingsSubmitting(confirmation: c));

    final key = const Uuid().v4();
    final goal = SavingsGoal(
      id: key,
      name: c.name,
      category: c.category,
      targetKobo: c.targetKobo,
      currentKobo: 0,
      durationMonths: c.durationMonths,
      frequency: c.frequency,
      amountPerPeriodKobo: c.amountPerPeriodKobo,
      createdAt: DateTime.now(),
    );

    try {
      await _createGoal.execute(idempotencyKey: key, goal: goal);
      if (_queueCubit.state.isOnline) await _queueCubit.replay();
    } on Object {
      emit(const SavingsCreateError('creationFailed'));
      return;
    }

    emit(SavingsCreated(goal: goal, isOffline: !_queueCubit.state.isOnline));
  }

  void reset() => emit(const SavingsCategorySelection());

  void back() {
    switch (state) {
      case SavingsDurationFrequency():
        emit(const SavingsCategorySelection());
      case SavingsAmountEntry(:final category, :final durationMonths, :final frequency):
        emit(SavingsDurationFrequency(
          category: category,
          durationMonths: durationMonths,
          frequency: frequency,
        ));
      case SavingsConfirmation(:final category, :final durationMonths, :final frequency, :final name):
        emit(SavingsAmountEntry(
          category: category,
          durationMonths: durationMonths,
          frequency: frequency,
          name: name,
        ));
      case SavingsAwaitingPin(:final confirmation):
        emit(confirmation);
      default:
        break;
    }
  }
}
