// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_database.dart';

// ignore_for_file: type=lint
class $QueueRowsTable extends QueueRows
    with TableInfo<$QueueRowsTable, QueueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QueueRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountKoboMeta = const VerificationMeta(
    'amountKobo',
  );
  @override
  late final GeneratedColumn<int> amountKobo = GeneratedColumn<int>(
    'amount_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idempotencyKey,
    type,
    amountKobo,
    targetId,
    status,
    createdAt,
    attemptCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'queue_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<QueueRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_kobo')) {
      context.handle(
        _amountKoboMeta,
        amountKobo.isAcceptableOrUnknown(data['amount_kobo']!, _amountKoboMeta),
      );
    } else if (isInserting) {
      context.missing(_amountKoboMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attemptCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idempotencyKey};
  @override
  QueueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QueueRow(
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amountKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_kobo'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
    );
  }

  @override
  $QueueRowsTable createAlias(String alias) {
    return $QueueRowsTable(attachedDatabase, alias);
  }
}

class QueueRow extends DataClass implements Insertable<QueueRow> {
  final String idempotencyKey;
  final String type;
  final int amountKobo;
  final String targetId;
  final String status;
  final DateTime createdAt;
  final int attemptCount;
  const QueueRow({
    required this.idempotencyKey,
    required this.type,
    required this.amountKobo,
    required this.targetId,
    required this.status,
    required this.createdAt,
    required this.attemptCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['type'] = Variable<String>(type);
    map['amount_kobo'] = Variable<int>(amountKobo);
    map['target_id'] = Variable<String>(targetId);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempt_count'] = Variable<int>(attemptCount);
    return map;
  }

  QueueRowsCompanion toCompanion(bool nullToAbsent) {
    return QueueRowsCompanion(
      idempotencyKey: Value(idempotencyKey),
      type: Value(type),
      amountKobo: Value(amountKobo),
      targetId: Value(targetId),
      status: Value(status),
      createdAt: Value(createdAt),
      attemptCount: Value(attemptCount),
    );
  }

  factory QueueRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QueueRow(
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      type: serializer.fromJson<String>(json['type']),
      amountKobo: serializer.fromJson<int>(json['amountKobo']),
      targetId: serializer.fromJson<String>(json['targetId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'type': serializer.toJson<String>(type),
      'amountKobo': serializer.toJson<int>(amountKobo),
      'targetId': serializer.toJson<String>(targetId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attemptCount': serializer.toJson<int>(attemptCount),
    };
  }

  QueueRow copyWith({
    String? idempotencyKey,
    String? type,
    int? amountKobo,
    String? targetId,
    String? status,
    DateTime? createdAt,
    int? attemptCount,
  }) => QueueRow(
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    type: type ?? this.type,
    amountKobo: amountKobo ?? this.amountKobo,
    targetId: targetId ?? this.targetId,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    attemptCount: attemptCount ?? this.attemptCount,
  );
  QueueRow copyWithCompanion(QueueRowsCompanion data) {
    return QueueRow(
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      type: data.type.present ? data.type.value : this.type,
      amountKobo: data.amountKobo.present
          ? data.amountKobo.value
          : this.amountKobo,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QueueRow(')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('type: $type, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('targetId: $targetId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptCount: $attemptCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idempotencyKey,
    type,
    amountKobo,
    targetId,
    status,
    createdAt,
    attemptCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QueueRow &&
          other.idempotencyKey == this.idempotencyKey &&
          other.type == this.type &&
          other.amountKobo == this.amountKobo &&
          other.targetId == this.targetId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.attemptCount == this.attemptCount);
}

class QueueRowsCompanion extends UpdateCompanion<QueueRow> {
  final Value<String> idempotencyKey;
  final Value<String> type;
  final Value<int> amountKobo;
  final Value<String> targetId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> attemptCount;
  final Value<int> rowid;
  const QueueRowsCompanion({
    this.idempotencyKey = const Value.absent(),
    this.type = const Value.absent(),
    this.amountKobo = const Value.absent(),
    this.targetId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QueueRowsCompanion.insert({
    required String idempotencyKey,
    required String type,
    required int amountKobo,
    required String targetId,
    required String status,
    required DateTime createdAt,
    required int attemptCount,
    this.rowid = const Value.absent(),
  }) : idempotencyKey = Value(idempotencyKey),
       type = Value(type),
       amountKobo = Value(amountKobo),
       targetId = Value(targetId),
       status = Value(status),
       createdAt = Value(createdAt),
       attemptCount = Value(attemptCount);
  static Insertable<QueueRow> custom({
    Expression<String>? idempotencyKey,
    Expression<String>? type,
    Expression<int>? amountKobo,
    Expression<String>? targetId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? attemptCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (type != null) 'type': type,
      if (amountKobo != null) 'amount_kobo': amountKobo,
      if (targetId != null) 'target_id': targetId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QueueRowsCompanion copyWith({
    Value<String>? idempotencyKey,
    Value<String>? type,
    Value<int>? amountKobo,
    Value<String>? targetId,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? attemptCount,
    Value<int>? rowid,
  }) {
    return QueueRowsCompanion(
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      type: type ?? this.type,
      amountKobo: amountKobo ?? this.amountKobo,
      targetId: targetId ?? this.targetId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      attemptCount: attemptCount ?? this.attemptCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountKobo.present) {
      map['amount_kobo'] = Variable<int>(amountKobo.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QueueRowsCompanion(')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('type: $type, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('targetId: $targetId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackendReceiptsTable extends BackendReceipts
    with TableInfo<$BackendReceiptsTable, BackendReceipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackendReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processedAtMeta = const VerificationMeta(
    'processedAt',
  );
  @override
  late final GeneratedColumn<DateTime> processedAt = GeneratedColumn<DateTime>(
    'processed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [idempotencyKey, processedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backend_receipts';
  @override
  VerificationContext validateIntegrity(
    Insertable<BackendReceipt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('processed_at')) {
      context.handle(
        _processedAtMeta,
        processedAt.isAcceptableOrUnknown(
          data['processed_at']!,
          _processedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idempotencyKey};
  @override
  BackendReceipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackendReceipt(
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      processedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}processed_at'],
      )!,
    );
  }

  @override
  $BackendReceiptsTable createAlias(String alias) {
    return $BackendReceiptsTable(attachedDatabase, alias);
  }
}

class BackendReceipt extends DataClass implements Insertable<BackendReceipt> {
  final String idempotencyKey;
  final DateTime processedAt;
  const BackendReceipt({
    required this.idempotencyKey,
    required this.processedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['processed_at'] = Variable<DateTime>(processedAt);
    return map;
  }

  BackendReceiptsCompanion toCompanion(bool nullToAbsent) {
    return BackendReceiptsCompanion(
      idempotencyKey: Value(idempotencyKey),
      processedAt: Value(processedAt),
    );
  }

  factory BackendReceipt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackendReceipt(
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      processedAt: serializer.fromJson<DateTime>(json['processedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'processedAt': serializer.toJson<DateTime>(processedAt),
    };
  }

  BackendReceipt copyWith({String? idempotencyKey, DateTime? processedAt}) =>
      BackendReceipt(
        idempotencyKey: idempotencyKey ?? this.idempotencyKey,
        processedAt: processedAt ?? this.processedAt,
      );
  BackendReceipt copyWithCompanion(BackendReceiptsCompanion data) {
    return BackendReceipt(
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      processedAt: data.processedAt.present
          ? data.processedAt.value
          : this.processedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackendReceipt(')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('processedAt: $processedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idempotencyKey, processedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackendReceipt &&
          other.idempotencyKey == this.idempotencyKey &&
          other.processedAt == this.processedAt);
}

class BackendReceiptsCompanion extends UpdateCompanion<BackendReceipt> {
  final Value<String> idempotencyKey;
  final Value<DateTime> processedAt;
  final Value<int> rowid;
  const BackendReceiptsCompanion({
    this.idempotencyKey = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackendReceiptsCompanion.insert({
    required String idempotencyKey,
    required DateTime processedAt,
    this.rowid = const Value.absent(),
  }) : idempotencyKey = Value(idempotencyKey),
       processedAt = Value(processedAt);
  static Insertable<BackendReceipt> custom({
    Expression<String>? idempotencyKey,
    Expression<DateTime>? processedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (processedAt != null) 'processed_at': processedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackendReceiptsCompanion copyWith({
    Value<String>? idempotencyKey,
    Value<DateTime>? processedAt,
    Value<int>? rowid,
  }) {
    return BackendReceiptsCompanion(
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      processedAt: processedAt ?? this.processedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<DateTime>(processedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackendReceiptsCompanion(')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('processedAt: $processedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalRowsTable extends SavingsGoalRows
    with TableInfo<$SavingsGoalRowsTable, SavingsGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetKoboMeta = const VerificationMeta(
    'targetKobo',
  );
  @override
  late final GeneratedColumn<int> targetKobo = GeneratedColumn<int>(
    'target_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentKoboMeta = const VerificationMeta(
    'currentKobo',
  );
  @override
  late final GeneratedColumn<int> currentKobo = GeneratedColumn<int>(
    'current_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMonthsMeta = const VerificationMeta(
    'durationMonths',
  );
  @override
  late final GeneratedColumn<int> durationMonths = GeneratedColumn<int>(
    'duration_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPerPeriodKoboMeta =
      const VerificationMeta('amountPerPeriodKobo');
  @override
  late final GeneratedColumn<int> amountPerPeriodKobo = GeneratedColumn<int>(
    'amount_per_period_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    targetKobo,
    currentKobo,
    durationMonths,
    frequency,
    amountPerPeriodKobo,
    createdAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goal_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('target_kobo')) {
      context.handle(
        _targetKoboMeta,
        targetKobo.isAcceptableOrUnknown(data['target_kobo']!, _targetKoboMeta),
      );
    } else if (isInserting) {
      context.missing(_targetKoboMeta);
    }
    if (data.containsKey('current_kobo')) {
      context.handle(
        _currentKoboMeta,
        currentKobo.isAcceptableOrUnknown(
          data['current_kobo']!,
          _currentKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentKoboMeta);
    }
    if (data.containsKey('duration_months')) {
      context.handle(
        _durationMonthsMeta,
        durationMonths.isAcceptableOrUnknown(
          data['duration_months']!,
          _durationMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMonthsMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('amount_per_period_kobo')) {
      context.handle(
        _amountPerPeriodKoboMeta,
        amountPerPeriodKobo.isAcceptableOrUnknown(
          data['amount_per_period_kobo']!,
          _amountPerPeriodKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPerPeriodKoboMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      targetKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_kobo'],
      )!,
      currentKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_kobo'],
      )!,
      durationMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_months'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      amountPerPeriodKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_per_period_kobo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $SavingsGoalRowsTable createAlias(String alias) {
    return $SavingsGoalRowsTable(attachedDatabase, alias);
  }
}

class SavingsGoalRow extends DataClass implements Insertable<SavingsGoalRow> {
  final String id;
  final String name;
  final String category;
  final int targetKobo;
  final int currentKobo;
  final int durationMonths;
  final String frequency;
  final int amountPerPeriodKobo;
  final DateTime createdAt;
  final String status;
  const SavingsGoalRow({
    required this.id,
    required this.name,
    required this.category,
    required this.targetKobo,
    required this.currentKobo,
    required this.durationMonths,
    required this.frequency,
    required this.amountPerPeriodKobo,
    required this.createdAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['target_kobo'] = Variable<int>(targetKobo);
    map['current_kobo'] = Variable<int>(currentKobo);
    map['duration_months'] = Variable<int>(durationMonths);
    map['frequency'] = Variable<String>(frequency);
    map['amount_per_period_kobo'] = Variable<int>(amountPerPeriodKobo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    return map;
  }

  SavingsGoalRowsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalRowsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      targetKobo: Value(targetKobo),
      currentKobo: Value(currentKobo),
      durationMonths: Value(durationMonths),
      frequency: Value(frequency),
      amountPerPeriodKobo: Value(amountPerPeriodKobo),
      createdAt: Value(createdAt),
      status: Value(status),
    );
  }

  factory SavingsGoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoalRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      targetKobo: serializer.fromJson<int>(json['targetKobo']),
      currentKobo: serializer.fromJson<int>(json['currentKobo']),
      durationMonths: serializer.fromJson<int>(json['durationMonths']),
      frequency: serializer.fromJson<String>(json['frequency']),
      amountPerPeriodKobo: serializer.fromJson<int>(
        json['amountPerPeriodKobo'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'targetKobo': serializer.toJson<int>(targetKobo),
      'currentKobo': serializer.toJson<int>(currentKobo),
      'durationMonths': serializer.toJson<int>(durationMonths),
      'frequency': serializer.toJson<String>(frequency),
      'amountPerPeriodKobo': serializer.toJson<int>(amountPerPeriodKobo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
    };
  }

  SavingsGoalRow copyWith({
    String? id,
    String? name,
    String? category,
    int? targetKobo,
    int? currentKobo,
    int? durationMonths,
    String? frequency,
    int? amountPerPeriodKobo,
    DateTime? createdAt,
    String? status,
  }) => SavingsGoalRow(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    targetKobo: targetKobo ?? this.targetKobo,
    currentKobo: currentKobo ?? this.currentKobo,
    durationMonths: durationMonths ?? this.durationMonths,
    frequency: frequency ?? this.frequency,
    amountPerPeriodKobo: amountPerPeriodKobo ?? this.amountPerPeriodKobo,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
  );
  SavingsGoalRow copyWithCompanion(SavingsGoalRowsCompanion data) {
    return SavingsGoalRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      targetKobo: data.targetKobo.present
          ? data.targetKobo.value
          : this.targetKobo,
      currentKobo: data.currentKobo.present
          ? data.currentKobo.value
          : this.currentKobo,
      durationMonths: data.durationMonths.present
          ? data.durationMonths.value
          : this.durationMonths,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      amountPerPeriodKobo: data.amountPerPeriodKobo.present
          ? data.amountPerPeriodKobo.value
          : this.amountPerPeriodKobo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('targetKobo: $targetKobo, ')
          ..write('currentKobo: $currentKobo, ')
          ..write('durationMonths: $durationMonths, ')
          ..write('frequency: $frequency, ')
          ..write('amountPerPeriodKobo: $amountPerPeriodKobo, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    targetKobo,
    currentKobo,
    durationMonths,
    frequency,
    amountPerPeriodKobo,
    createdAt,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoalRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.targetKobo == this.targetKobo &&
          other.currentKobo == this.currentKobo &&
          other.durationMonths == this.durationMonths &&
          other.frequency == this.frequency &&
          other.amountPerPeriodKobo == this.amountPerPeriodKobo &&
          other.createdAt == this.createdAt &&
          other.status == this.status);
}

class SavingsGoalRowsCompanion extends UpdateCompanion<SavingsGoalRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int> targetKobo;
  final Value<int> currentKobo;
  final Value<int> durationMonths;
  final Value<String> frequency;
  final Value<int> amountPerPeriodKobo;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<int> rowid;
  const SavingsGoalRowsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.targetKobo = const Value.absent(),
    this.currentKobo = const Value.absent(),
    this.durationMonths = const Value.absent(),
    this.frequency = const Value.absent(),
    this.amountPerPeriodKobo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavingsGoalRowsCompanion.insert({
    required String id,
    required String name,
    required String category,
    required int targetKobo,
    required int currentKobo,
    required int durationMonths,
    required String frequency,
    required int amountPerPeriodKobo,
    required DateTime createdAt,
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       targetKobo = Value(targetKobo),
       currentKobo = Value(currentKobo),
       durationMonths = Value(durationMonths),
       frequency = Value(frequency),
       amountPerPeriodKobo = Value(amountPerPeriodKobo),
       createdAt = Value(createdAt),
       status = Value(status);
  static Insertable<SavingsGoalRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? targetKobo,
    Expression<int>? currentKobo,
    Expression<int>? durationMonths,
    Expression<String>? frequency,
    Expression<int>? amountPerPeriodKobo,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (targetKobo != null) 'target_kobo': targetKobo,
      if (currentKobo != null) 'current_kobo': currentKobo,
      if (durationMonths != null) 'duration_months': durationMonths,
      if (frequency != null) 'frequency': frequency,
      if (amountPerPeriodKobo != null)
        'amount_per_period_kobo': amountPerPeriodKobo,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavingsGoalRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<int>? targetKobo,
    Value<int>? currentKobo,
    Value<int>? durationMonths,
    Value<String>? frequency,
    Value<int>? amountPerPeriodKobo,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return SavingsGoalRowsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      targetKobo: targetKobo ?? this.targetKobo,
      currentKobo: currentKobo ?? this.currentKobo,
      durationMonths: durationMonths ?? this.durationMonths,
      frequency: frequency ?? this.frequency,
      amountPerPeriodKobo: amountPerPeriodKobo ?? this.amountPerPeriodKobo,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (targetKobo.present) {
      map['target_kobo'] = Variable<int>(targetKobo.value);
    }
    if (currentKobo.present) {
      map['current_kobo'] = Variable<int>(currentKobo.value);
    }
    if (durationMonths.present) {
      map['duration_months'] = Variable<int>(durationMonths.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (amountPerPeriodKobo.present) {
      map['amount_per_period_kobo'] = Variable<int>(amountPerPeriodKobo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalRowsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('targetKobo: $targetKobo, ')
          ..write('currentKobo: $currentKobo, ')
          ..write('durationMonths: $durationMonths, ')
          ..write('frequency: $frequency, ')
          ..write('amountPerPeriodKobo: $amountPerPeriodKobo, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$QueueDatabase extends GeneratedDatabase {
  _$QueueDatabase(QueryExecutor e) : super(e);
  $QueueDatabaseManager get managers => $QueueDatabaseManager(this);
  late final $QueueRowsTable queueRows = $QueueRowsTable(this);
  late final $BackendReceiptsTable backendReceipts = $BackendReceiptsTable(
    this,
  );
  late final $SavingsGoalRowsTable savingsGoalRows = $SavingsGoalRowsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    queueRows,
    backendReceipts,
    savingsGoalRows,
  ];
}

typedef $$QueueRowsTableCreateCompanionBuilder =
    QueueRowsCompanion Function({
      required String idempotencyKey,
      required String type,
      required int amountKobo,
      required String targetId,
      required String status,
      required DateTime createdAt,
      required int attemptCount,
      Value<int> rowid,
    });
typedef $$QueueRowsTableUpdateCompanionBuilder =
    QueueRowsCompanion Function({
      Value<String> idempotencyKey,
      Value<String> type,
      Value<int> amountKobo,
      Value<String> targetId,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> attemptCount,
      Value<int> rowid,
    });

class $$QueueRowsTableFilterComposer
    extends Composer<_$QueueDatabase, $QueueRowsTable> {
  $$QueueRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QueueRowsTableOrderingComposer
    extends Composer<_$QueueDatabase, $QueueRowsTable> {
  $$QueueRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QueueRowsTableAnnotationComposer
    extends Composer<_$QueueDatabase, $QueueRowsTable> {
  $$QueueRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );
}

class $$QueueRowsTableTableManager
    extends
        RootTableManager<
          _$QueueDatabase,
          $QueueRowsTable,
          QueueRow,
          $$QueueRowsTableFilterComposer,
          $$QueueRowsTableOrderingComposer,
          $$QueueRowsTableAnnotationComposer,
          $$QueueRowsTableCreateCompanionBuilder,
          $$QueueRowsTableUpdateCompanionBuilder,
          (
            QueueRow,
            BaseReferences<_$QueueDatabase, $QueueRowsTable, QueueRow>,
          ),
          QueueRow,
          PrefetchHooks Function()
        > {
  $$QueueRowsTableTableManager(_$QueueDatabase db, $QueueRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QueueRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QueueRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QueueRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> idempotencyKey = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amountKobo = const Value.absent(),
                Value<String> targetId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QueueRowsCompanion(
                idempotencyKey: idempotencyKey,
                type: type,
                amountKobo: amountKobo,
                targetId: targetId,
                status: status,
                createdAt: createdAt,
                attemptCount: attemptCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String idempotencyKey,
                required String type,
                required int amountKobo,
                required String targetId,
                required String status,
                required DateTime createdAt,
                required int attemptCount,
                Value<int> rowid = const Value.absent(),
              }) => QueueRowsCompanion.insert(
                idempotencyKey: idempotencyKey,
                type: type,
                amountKobo: amountKobo,
                targetId: targetId,
                status: status,
                createdAt: createdAt,
                attemptCount: attemptCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QueueRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$QueueDatabase,
      $QueueRowsTable,
      QueueRow,
      $$QueueRowsTableFilterComposer,
      $$QueueRowsTableOrderingComposer,
      $$QueueRowsTableAnnotationComposer,
      $$QueueRowsTableCreateCompanionBuilder,
      $$QueueRowsTableUpdateCompanionBuilder,
      (QueueRow, BaseReferences<_$QueueDatabase, $QueueRowsTable, QueueRow>),
      QueueRow,
      PrefetchHooks Function()
    >;
typedef $$BackendReceiptsTableCreateCompanionBuilder =
    BackendReceiptsCompanion Function({
      required String idempotencyKey,
      required DateTime processedAt,
      Value<int> rowid,
    });
typedef $$BackendReceiptsTableUpdateCompanionBuilder =
    BackendReceiptsCompanion Function({
      Value<String> idempotencyKey,
      Value<DateTime> processedAt,
      Value<int> rowid,
    });

class $$BackendReceiptsTableFilterComposer
    extends Composer<_$QueueDatabase, $BackendReceiptsTable> {
  $$BackendReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BackendReceiptsTableOrderingComposer
    extends Composer<_$QueueDatabase, $BackendReceiptsTable> {
  $$BackendReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BackendReceiptsTableAnnotationComposer
    extends Composer<_$QueueDatabase, $BackendReceiptsTable> {
  $$BackendReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => column,
  );
}

class $$BackendReceiptsTableTableManager
    extends
        RootTableManager<
          _$QueueDatabase,
          $BackendReceiptsTable,
          BackendReceipt,
          $$BackendReceiptsTableFilterComposer,
          $$BackendReceiptsTableOrderingComposer,
          $$BackendReceiptsTableAnnotationComposer,
          $$BackendReceiptsTableCreateCompanionBuilder,
          $$BackendReceiptsTableUpdateCompanionBuilder,
          (
            BackendReceipt,
            BaseReferences<
              _$QueueDatabase,
              $BackendReceiptsTable,
              BackendReceipt
            >,
          ),
          BackendReceipt,
          PrefetchHooks Function()
        > {
  $$BackendReceiptsTableTableManager(
    _$QueueDatabase db,
    $BackendReceiptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackendReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackendReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackendReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> idempotencyKey = const Value.absent(),
                Value<DateTime> processedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BackendReceiptsCompanion(
                idempotencyKey: idempotencyKey,
                processedAt: processedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String idempotencyKey,
                required DateTime processedAt,
                Value<int> rowid = const Value.absent(),
              }) => BackendReceiptsCompanion.insert(
                idempotencyKey: idempotencyKey,
                processedAt: processedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BackendReceiptsTableProcessedTableManager =
    ProcessedTableManager<
      _$QueueDatabase,
      $BackendReceiptsTable,
      BackendReceipt,
      $$BackendReceiptsTableFilterComposer,
      $$BackendReceiptsTableOrderingComposer,
      $$BackendReceiptsTableAnnotationComposer,
      $$BackendReceiptsTableCreateCompanionBuilder,
      $$BackendReceiptsTableUpdateCompanionBuilder,
      (
        BackendReceipt,
        BaseReferences<_$QueueDatabase, $BackendReceiptsTable, BackendReceipt>,
      ),
      BackendReceipt,
      PrefetchHooks Function()
    >;
typedef $$SavingsGoalRowsTableCreateCompanionBuilder =
    SavingsGoalRowsCompanion Function({
      required String id,
      required String name,
      required String category,
      required int targetKobo,
      required int currentKobo,
      required int durationMonths,
      required String frequency,
      required int amountPerPeriodKobo,
      required DateTime createdAt,
      required String status,
      Value<int> rowid,
    });
typedef $$SavingsGoalRowsTableUpdateCompanionBuilder =
    SavingsGoalRowsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<int> targetKobo,
      Value<int> currentKobo,
      Value<int> durationMonths,
      Value<String> frequency,
      Value<int> amountPerPeriodKobo,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<int> rowid,
    });

class $$SavingsGoalRowsTableFilterComposer
    extends Composer<_$QueueDatabase, $SavingsGoalRowsTable> {
  $$SavingsGoalRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetKobo => $composableBuilder(
    column: $table.targetKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentKobo => $composableBuilder(
    column: $table.currentKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPerPeriodKobo => $composableBuilder(
    column: $table.amountPerPeriodKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsGoalRowsTableOrderingComposer
    extends Composer<_$QueueDatabase, $SavingsGoalRowsTable> {
  $$SavingsGoalRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetKobo => $composableBuilder(
    column: $table.targetKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentKobo => $composableBuilder(
    column: $table.currentKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPerPeriodKobo => $composableBuilder(
    column: $table.amountPerPeriodKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsGoalRowsTableAnnotationComposer
    extends Composer<_$QueueDatabase, $SavingsGoalRowsTable> {
  $$SavingsGoalRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get targetKobo => $composableBuilder(
    column: $table.targetKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentKobo => $composableBuilder(
    column: $table.currentKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get amountPerPeriodKobo => $composableBuilder(
    column: $table.amountPerPeriodKobo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$SavingsGoalRowsTableTableManager
    extends
        RootTableManager<
          _$QueueDatabase,
          $SavingsGoalRowsTable,
          SavingsGoalRow,
          $$SavingsGoalRowsTableFilterComposer,
          $$SavingsGoalRowsTableOrderingComposer,
          $$SavingsGoalRowsTableAnnotationComposer,
          $$SavingsGoalRowsTableCreateCompanionBuilder,
          $$SavingsGoalRowsTableUpdateCompanionBuilder,
          (
            SavingsGoalRow,
            BaseReferences<
              _$QueueDatabase,
              $SavingsGoalRowsTable,
              SavingsGoalRow
            >,
          ),
          SavingsGoalRow,
          PrefetchHooks Function()
        > {
  $$SavingsGoalRowsTableTableManager(
    _$QueueDatabase db,
    $SavingsGoalRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> targetKobo = const Value.absent(),
                Value<int> currentKobo = const Value.absent(),
                Value<int> durationMonths = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int> amountPerPeriodKobo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavingsGoalRowsCompanion(
                id: id,
                name: name,
                category: category,
                targetKobo: targetKobo,
                currentKobo: currentKobo,
                durationMonths: durationMonths,
                frequency: frequency,
                amountPerPeriodKobo: amountPerPeriodKobo,
                createdAt: createdAt,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                required int targetKobo,
                required int currentKobo,
                required int durationMonths,
                required String frequency,
                required int amountPerPeriodKobo,
                required DateTime createdAt,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => SavingsGoalRowsCompanion.insert(
                id: id,
                name: name,
                category: category,
                targetKobo: targetKobo,
                currentKobo: currentKobo,
                durationMonths: durationMonths,
                frequency: frequency,
                amountPerPeriodKobo: amountPerPeriodKobo,
                createdAt: createdAt,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsGoalRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$QueueDatabase,
      $SavingsGoalRowsTable,
      SavingsGoalRow,
      $$SavingsGoalRowsTableFilterComposer,
      $$SavingsGoalRowsTableOrderingComposer,
      $$SavingsGoalRowsTableAnnotationComposer,
      $$SavingsGoalRowsTableCreateCompanionBuilder,
      $$SavingsGoalRowsTableUpdateCompanionBuilder,
      (
        SavingsGoalRow,
        BaseReferences<_$QueueDatabase, $SavingsGoalRowsTable, SavingsGoalRow>,
      ),
      SavingsGoalRow,
      PrefetchHooks Function()
    >;

class $QueueDatabaseManager {
  final _$QueueDatabase _db;
  $QueueDatabaseManager(this._db);
  $$QueueRowsTableTableManager get queueRows =>
      $$QueueRowsTableTableManager(_db, _db.queueRows);
  $$BackendReceiptsTableTableManager get backendReceipts =>
      $$BackendReceiptsTableTableManager(_db, _db.backendReceipts);
  $$SavingsGoalRowsTableTableManager get savingsGoalRows =>
      $$SavingsGoalRowsTableTableManager(_db, _db.savingsGoalRows);
}
