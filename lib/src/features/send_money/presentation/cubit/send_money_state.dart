import 'package:equatable/equatable.dart';

class BankInfo extends Equatable {
  const BankInfo({required this.name, required this.code});
  final String name;
  final String code;
  @override
  List<Object?> get props => [code];
}

sealed class SendMoneyState extends Equatable {
  const SendMoneyState();
}

final class SendMoneyBankSelection extends SendMoneyState {
  const SendMoneyBankSelection();
  @override
  List<Object?> get props => [];
}

final class SendMoneyAccountEntry extends SendMoneyState {
  const SendMoneyAccountEntry({required this.bank});
  final BankInfo bank;
  @override
  List<Object?> get props => [bank];
}

final class SendMoneyLookingUp extends SendMoneyState {
  const SendMoneyLookingUp({required this.bank, required this.accountNumber});
  final BankInfo bank;
  final String accountNumber;
  @override
  List<Object?> get props => [bank, accountNumber];
}

final class SendMoneyLookupFailed extends SendMoneyState {
  const SendMoneyLookupFailed({required this.bank, required this.accountNumber});
  final BankInfo bank;
  final String accountNumber;
  @override
  List<Object?> get props => [bank, accountNumber];
}

final class SendMoneyAmountEntry extends SendMoneyState {
  const SendMoneyAmountEntry({
    required this.bank,
    required this.accountNumber,
    required this.accountName,
  });
  final BankInfo bank;
  final String accountNumber;
  final String accountName;
  @override
  List<Object?> get props => [bank, accountNumber, accountName];
}

final class SendMoneyConfirmation extends SendMoneyState {
  const SendMoneyConfirmation({
    required this.bank,
    required this.accountNumber,
    required this.accountName,
    required this.amountKobo,
  });
  final BankInfo bank;
  final String accountNumber;
  final String accountName;
  final int amountKobo;
  @override
  List<Object?> get props => [bank, accountNumber, accountName, amountKobo];
}

final class SendMoneyAwaitingPin extends SendMoneyState {
  const SendMoneyAwaitingPin({
    required this.bank,
    required this.accountNumber,
    required this.accountName,
    required this.amountKobo,
    this.pinError,
    this.remainingAttempts = 3,
  });
  final BankInfo bank;
  final String accountNumber;
  final String accountName;
  final int amountKobo;
  final String? pinError;
  final int remainingAttempts;
  @override
  List<Object?> get props => [bank, accountNumber, accountName, amountKobo, pinError, remainingAttempts];
}

final class SendMoneySubmitting extends SendMoneyState {
  const SendMoneySubmitting({
    required this.bank,
    required this.accountNumber,
    required this.accountName,
    required this.amountKobo,
    required this.idempotencyKey,
  });
  final BankInfo bank;
  final String accountNumber;
  final String accountName;
  final int amountKobo;
  final String idempotencyKey;
  @override
  List<Object?> get props => [bank, accountNumber, accountName, amountKobo, idempotencyKey];
}

final class SendMoneyQueued extends SendMoneyState {
  const SendMoneyQueued({
    required this.idempotencyKey,
    required this.amountKobo,
    required this.isOffline,
  });
  final String idempotencyKey;
  final int amountKobo;
  final bool isOffline;
  @override
  List<Object?> get props => [idempotencyKey, amountKobo, isOffline];
}

final class SendMoneyError extends SendMoneyState {
  const SendMoneyError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

// ── Legacy states — kept for existing test compatibility ───────────────────

final class SendMoneyStep1 extends SendMoneyState {
  const SendMoneyStep1();
  @override
  List<Object?> get props => [];
}

final class SendMoneyStep2 extends SendMoneyState {
  const SendMoneyStep2({required this.recipientId});
  final String recipientId;
  @override
  List<Object?> get props => [recipientId];
}

final class SendMoneyStep3 extends SendMoneyState {
  const SendMoneyStep3({required this.recipientId, required this.amountKobo});
  final String recipientId;
  final int amountKobo;
  @override
  List<Object?> get props => [recipientId, amountKobo];
}
