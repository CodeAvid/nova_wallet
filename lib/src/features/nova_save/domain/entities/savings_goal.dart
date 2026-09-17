import 'package:dart_mappable/dart_mappable.dart';

part 'savings_goal.mapper.dart';

@MappableClass()
class SavingsGoal with SavingsGoalMappable {
  const SavingsGoal({
    required this.targetKobo,
    required this.currentKobo,
    this.id = 'emergency-fund',
    this.name = 'Emergency Fund',
    this.targetDate,
    this.category = 'target',
    this.durationMonths = 12,
    this.frequency = 'monthly',
    this.amountPerPeriodKobo = 0,
    this.status = 'active',
    this.createdAt,
  });

  final String id;
  final String name;
  final int targetKobo;
  final int currentKobo;
  final DateTime? targetDate;
  final String category;
  final int durationMonths;
  final String frequency;
  final int amountPerPeriodKobo;
  final String status;
  final DateTime? createdAt;

  int get progressPercent =>
      targetKobo == 0 ? 0 : ((currentKobo * 100) ~/ targetKobo).clamp(0, 100);
}
