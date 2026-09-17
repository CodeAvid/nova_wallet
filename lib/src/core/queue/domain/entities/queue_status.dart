import 'package:dart_mappable/dart_mappable.dart';

part 'queue_status.mapper.dart';

@MappableEnum()
enum QueueStatus { pending, sending, confirmed, failed }
