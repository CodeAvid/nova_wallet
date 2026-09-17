import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_wallet/src/core/network/fake_account_lookup.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/core/queue/presentation/cubit/queue_cubit.dart';
import 'package:nova_wallet/src/features/send_money/domain/usecases/send_money_usecase.dart';
import 'package:nova_wallet/src/features/send_money/presentation/cubit/send_money_state.dart';
import 'package:uuid/uuid.dart';

const _correctPin = '1234';

class SendMoneyCubit extends Cubit<SendMoneyState> {
  SendMoneyCubit(this._queueOrUseCase, {this.isOffline = false})
      // Legacy use case → old 3-step UI; QueueCubit → new 5-step UI
      : super(_queueOrUseCase is SendMoneyUseCase
            ? const SendMoneyStep1()
            : const SendMoneyBankSelection());

  final Object _queueOrUseCase;
  final bool isOffline;

  void selectBank(BankInfo bank) => emit(SendMoneyAccountEntry(bank: bank));

  Future<void> lookupAccount(String accountNumber) async {
    final s = state;
    if (s is! SendMoneyAccountEntry && s is! SendMoneyLookupFailed) return;
    final bank = s is SendMoneyAccountEntry ? s.bank : (s as SendMoneyLookupFailed).bank;

    if (accountNumber.length != 10) return;
    emit(SendMoneyLookingUp(bank: bank, accountNumber: accountNumber));

    final name = await lookupAccountName(accountNumber);
    if (isClosed) return;

    if (name == null) {
      emit(SendMoneyLookupFailed(bank: bank, accountNumber: accountNumber));
    } else {
      emit(SendMoneyAmountEntry(
        bank: bank,
        accountNumber: accountNumber,
        accountName: name,
      ));
    }
  }

  void setAmount(int amountKobo) {
    if (amountKobo <= 0) {
      emit(const SendMoneyError('invalidAmount'));
      return;
    }
    final s = state;
    if (s is SendMoneyAmountEntry) {
      emit(SendMoneyConfirmation(
        bank: s.bank,
        accountNumber: s.accountNumber,
        accountName: s.accountName,
        amountKobo: amountKobo,
      ));
    } else if (s is SendMoneyStep2) {
      // Legacy flow
      emit(SendMoneyStep3(recipientId: s.recipientId, amountKobo: amountKobo));
    }
  }

  void proceedToPin() {
    final s = state;
    if (s is! SendMoneyConfirmation) return;
    emit(SendMoneyAwaitingPin(
      bank: s.bank,
      accountNumber: s.accountNumber,
      accountName: s.accountName,
      amountKobo: s.amountKobo,
    ));
  }

  Future<void> submitPin(String pin) async {
    final s = state;
    if (s is! SendMoneyAwaitingPin) return;

    if (pin != _correctPin) {
      final remaining = s.remainingAttempts - 1;
      if (remaining <= 0) {
        emit(const SendMoneyError('pinLocked'));
      } else {
        emit(SendMoneyAwaitingPin(
          bank: s.bank,
          accountNumber: s.accountNumber,
          accountName: s.accountName,
          amountKobo: s.amountKobo,
          pinError: 'wrongPin:$remaining',
          remainingAttempts: remaining,
        ));
      }
      return;
    }

    await _enqueue(s);
  }

  Future<void> _enqueue(SendMoneyAwaitingPin s) async {
    final key = const Uuid().v4();
    final targetId = jsonEncode({
      'bank': s.bank.code,
      'account': s.accountNumber,
      'name': s.accountName,
    });

    emit(SendMoneySubmitting(
      bank: s.bank,
      accountNumber: s.accountNumber,
      accountName: s.accountName,
      amountKobo: s.amountKobo,
      idempotencyKey: key,
    ));

    try {
      switch (_queueOrUseCase) {
        case final QueueCubit queueCubit:
          await queueCubit.enqueue(
            idempotencyKey: key,
            type: TransactionType.send,
            amountKobo: s.amountKobo,
            targetId: targetId,
          );
        case final SendMoneyUseCase useCase:
          await useCase.execute(
            idempotencyKey: key,
            amountKobo: s.amountKobo,
            recipientId: targetId,
          );
        default:
          throw StateError('Unsupported queue action handler');
      }
    } on Object {
      emit(const SendMoneyError('transferFailed'));
      return;
    }

    emit(SendMoneyQueued(
      idempotencyKey: key,
      amountKobo: s.amountKobo,
      isOffline: isOffline || !_isOnline,
    ));
  }

  bool get _isOnline => switch (_queueOrUseCase) {
    QueueCubit q => q.state.isOnline,
    _ => true,
  };

  void back() {
    switch (state) {
      case SendMoneyAccountEntry() || SendMoneyLookingUp():
        emit(const SendMoneyBankSelection());
      // Legacy back navigation
      case SendMoneyStep2():
        emit(const SendMoneyStep1());
      case SendMoneyLookupFailed(:final bank):
        emit(SendMoneyAccountEntry(bank: bank));
      case SendMoneyAmountEntry(:final bank):
        emit(SendMoneyAccountEntry(bank: bank));
      case SendMoneyConfirmation(:final bank, :final accountNumber, :final accountName):
        emit(SendMoneyAmountEntry(
          bank: bank,
          accountNumber: accountNumber,
          accountName: accountName,
        ));
      case SendMoneyAwaitingPin(
        :final bank,
        :final accountNumber,
        :final accountName,
        :final amountKobo,
      ):
        emit(SendMoneyConfirmation(
          bank: bank,
          accountNumber: accountNumber,
          accountName: accountName,
          amountKobo: amountKobo,
        ));
      default:
        break;
    }
  }

  void reset() => emit(const SendMoneyBankSelection());

  // ── Legacy API (used by existing unit tests) ──────────────────────────────

  void setRecipient(String recipientId) {
    final normalized = recipientId.trim();
    if (!RegExp(r'^[A-Za-z0-9-]{3,64}$').hasMatch(normalized)) {
      emit(const SendMoneyError('invalidRecipient'));
      return;
    }
    emit(SendMoneyStep2(recipientId: normalized));
  }

  // Called by legacy test after setRecipient/setAmount
  Future<void> confirm() async {
    final current = state;
    if (current is SendMoneyStep3) {
      final key = const Uuid().v4();
      emit(SendMoneySubmitting(
        bank: const BankInfo(name: '', code: ''),
        accountNumber: current.recipientId,
        accountName: current.recipientId,
        amountKobo: current.amountKobo,
        idempotencyKey: key,
      ));
      try {
        switch (_queueOrUseCase) {
          case final QueueCubit queueCubit:
            await queueCubit.enqueue(
              idempotencyKey: key,
              type: TransactionType.send,
              amountKobo: current.amountKobo,
              targetId: current.recipientId,
            );
          case final SendMoneyUseCase useCase:
            await useCase.execute(
              idempotencyKey: key,
              amountKobo: current.amountKobo,
              recipientId: current.recipientId,
            );
          default:
            throw StateError('Unsupported queue action handler');
        }
      } on Object {
        emit(const SendMoneyError('transferFailed'));
        return;
      }
      emit(SendMoneyQueued(
        idempotencyKey: key,
        amountKobo: current.amountKobo,
        isOffline: false,
      ));
    }
  }
}
