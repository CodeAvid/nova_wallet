// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'queue_item.dart';

class QueueItemMapper extends ClassMapperBase<QueueItem> {
  QueueItemMapper._();

  static QueueItemMapper? _instance;
  static QueueItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QueueItemMapper._());
      TransactionTypeMapper.ensureInitialized();
      QueueStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'QueueItem';

  static String _$idempotencyKey(QueueItem v) => v.idempotencyKey;
  static const Field<QueueItem, String> _f$idempotencyKey = Field(
    'idempotencyKey',
    _$idempotencyKey,
  );
  static TransactionType _$type(QueueItem v) => v.type;
  static const Field<QueueItem, TransactionType> _f$type = Field(
    'type',
    _$type,
  );
  static int _$amountKobo(QueueItem v) => v.amountKobo;
  static const Field<QueueItem, int> _f$amountKobo = Field(
    'amountKobo',
    _$amountKobo,
  );
  static String _$targetId(QueueItem v) => v.targetId;
  static const Field<QueueItem, String> _f$targetId = Field(
    'targetId',
    _$targetId,
  );
  static QueueStatus _$status(QueueItem v) => v.status;
  static const Field<QueueItem, QueueStatus> _f$status = Field(
    'status',
    _$status,
  );
  static DateTime _$createdAt(QueueItem v) => v.createdAt;
  static const Field<QueueItem, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static int _$attemptCount(QueueItem v) => v.attemptCount;
  static const Field<QueueItem, int> _f$attemptCount = Field(
    'attemptCount',
    _$attemptCount,
  );

  @override
  final MappableFields<QueueItem> fields = const {
    #idempotencyKey: _f$idempotencyKey,
    #type: _f$type,
    #amountKobo: _f$amountKobo,
    #targetId: _f$targetId,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #attemptCount: _f$attemptCount,
  };

  static QueueItem _instantiate(DecodingData data) {
    return QueueItem(
      idempotencyKey: data.dec(_f$idempotencyKey),
      type: data.dec(_f$type),
      amountKobo: data.dec(_f$amountKobo),
      targetId: data.dec(_f$targetId),
      status: data.dec(_f$status),
      createdAt: data.dec(_f$createdAt),
      attemptCount: data.dec(_f$attemptCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static QueueItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QueueItem>(map);
  }

  static QueueItem fromJson(String json) {
    return ensureInitialized().decodeJson<QueueItem>(json);
  }
}

mixin QueueItemMappable {
  String toJson() {
    return QueueItemMapper.ensureInitialized().encodeJson<QueueItem>(
      this as QueueItem,
    );
  }

  Map<String, dynamic> toMap() {
    return QueueItemMapper.ensureInitialized().encodeMap<QueueItem>(
      this as QueueItem,
    );
  }

  QueueItemCopyWith<QueueItem, QueueItem, QueueItem> get copyWith =>
      _QueueItemCopyWithImpl<QueueItem, QueueItem>(
        this as QueueItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return QueueItemMapper.ensureInitialized().stringifyValue(
      this as QueueItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return QueueItemMapper.ensureInitialized().equalsValue(
      this as QueueItem,
      other,
    );
  }

  @override
  int get hashCode {
    return QueueItemMapper.ensureInitialized().hashValue(this as QueueItem);
  }
}

extension QueueItemValueCopy<$R, $Out> on ObjectCopyWith<$R, QueueItem, $Out> {
  QueueItemCopyWith<$R, QueueItem, $Out> get $asQueueItem =>
      $base.as((v, t, t2) => _QueueItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class QueueItemCopyWith<$R, $In extends QueueItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? idempotencyKey,
    TransactionType? type,
    int? amountKobo,
    String? targetId,
    QueueStatus? status,
    DateTime? createdAt,
    int? attemptCount,
  });
  QueueItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _QueueItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QueueItem, $Out>
    implements QueueItemCopyWith<$R, QueueItem, $Out> {
  _QueueItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QueueItem> $mapper =
      QueueItemMapper.ensureInitialized();
  @override
  $R call({
    String? idempotencyKey,
    TransactionType? type,
    int? amountKobo,
    String? targetId,
    QueueStatus? status,
    DateTime? createdAt,
    int? attemptCount,
  }) => $apply(
    FieldCopyWithData({
      if (idempotencyKey != null) #idempotencyKey: idempotencyKey,
      if (type != null) #type: type,
      if (amountKobo != null) #amountKobo: amountKobo,
      if (targetId != null) #targetId: targetId,
      if (status != null) #status: status,
      if (createdAt != null) #createdAt: createdAt,
      if (attemptCount != null) #attemptCount: attemptCount,
    }),
  );
  @override
  QueueItem $make(CopyWithData data) => QueueItem(
    idempotencyKey: data.get(#idempotencyKey, or: $value.idempotencyKey),
    type: data.get(#type, or: $value.type),
    amountKobo: data.get(#amountKobo, or: $value.amountKobo),
    targetId: data.get(#targetId, or: $value.targetId),
    status: data.get(#status, or: $value.status),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    attemptCount: data.get(#attemptCount, or: $value.attemptCount),
  );

  @override
  QueueItemCopyWith<$R2, QueueItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _QueueItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

