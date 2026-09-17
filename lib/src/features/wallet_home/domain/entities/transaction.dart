import 'package:dart_mappable/dart_mappable.dart';

part 'transaction.mapper.dart';

@MappableEnum()
enum TransactionCategory {
  transfer,
  savings,
  airtime,
  data,
  topUp,
}

@MappableClass()
class Transaction with TransactionMappable {
  const Transaction({
    required this.id,
    required this.title,
    required this.counterparty,
    required this.amountKobo,
    required this.date,
    required this.category,
    this.isPending = false,
  });

  final String id;
  final String title;
  final String counterparty;
  final int amountKobo; // negative = debit, positive = credit
  final DateTime date;
  final TransactionCategory category;
  final bool isPending;
}
