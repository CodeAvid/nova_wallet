// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'queue_status.dart';

class QueueStatusMapper extends EnumMapper<QueueStatus> {
  QueueStatusMapper._();

  static QueueStatusMapper? _instance;
  static QueueStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QueueStatusMapper._());
    }
    return _instance!;
  }

  static QueueStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  QueueStatus decode(dynamic value) {
    switch (value) {
      case r'pending':
        return QueueStatus.pending;
      case r'sending':
        return QueueStatus.sending;
      case r'confirmed':
        return QueueStatus.confirmed;
      case r'failed':
        return QueueStatus.failed;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(QueueStatus self) {
    switch (self) {
      case QueueStatus.pending:
        return r'pending';
      case QueueStatus.sending:
        return r'sending';
      case QueueStatus.confirmed:
        return r'confirmed';
      case QueueStatus.failed:
        return r'failed';
    }
  }
}

extension QueueStatusMapperExtension on QueueStatus {
  String toValue() {
    QueueStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<QueueStatus>(this) as String;
  }
}

