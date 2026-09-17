import 'package:dart_mappable/dart_mappable.dart';
import 'package:nova_wallet/src/features/nova_save/domain/entities/savings_goal.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/entities/transaction.dart';
import 'package:nova_wallet/src/features/wallet_home/domain/entities/wallet.dart';

part 'fake_backend_models.mapper.dart';

@MappableClass()
class FakeBackendSeed with FakeBackendSeedMappable {
  const FakeBackendSeed({
    required this.wallet,
    required this.transactions,
    required this.goals,
  });

  final Wallet wallet;
  final List<Transaction> transactions;
  final List<SavingsGoal> goals;
}

@MappableClass()
class SubmissionResult with SubmissionResultMappable {
  const SubmissionResult({
    required this.accepted,
    required this.alreadyProcessed,
  });

  final bool accepted;
  final bool alreadyProcessed;
}
