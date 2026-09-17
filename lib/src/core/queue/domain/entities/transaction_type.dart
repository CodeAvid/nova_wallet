import 'package:dart_mappable/dart_mappable.dart';

part 'transaction_type.mapper.dart';

@MappableEnum()
enum TransactionType { send, saveContribution, topUp }
