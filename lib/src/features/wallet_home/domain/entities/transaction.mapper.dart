// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'transaction.dart';

class TransactionCategoryMapper extends EnumMapper<TransactionCategory> {
  TransactionCategoryMapper._();

  static TransactionCategoryMapper? _instance;
  static TransactionCategoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TransactionCategoryMapper._());
    }
    return _instance!;
  }

  static TransactionCategory fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  TransactionCategory decode(dynamic value) {
    switch (value) {
      case r'transfer':
        return TransactionCategory.transfer;
      case r'savings':
        return TransactionCategory.savings;
      case r'airtime':
        return TransactionCategory.airtime;
      case r'data':
        return TransactionCategory.data;
      case r'topUp':
        return TransactionCategory.topUp;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(TransactionCategory self) {
    switch (self) {
      case TransactionCategory.transfer:
        return r'transfer';
      case TransactionCategory.savings:
        return r'savings';
      case TransactionCategory.airtime:
        return r'airtime';
      case TransactionCategory.data:
        return r'data';
      case TransactionCategory.topUp:
        return r'topUp';
    }
  }
}

extension TransactionCategoryMapperExtension on TransactionCategory {
  String toValue() {
    TransactionCategoryMapper.ensureInitialized();
    return MapperContainer.globals.toValue<TransactionCategory>(this) as String;
  }
}

class TransactionMapper extends ClassMapperBase<Transaction> {
  TransactionMapper._();

  static TransactionMapper? _instance;
  static TransactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TransactionMapper._());
      TransactionCategoryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Transaction';

  static String _$id(Transaction v) => v.id;
  static const Field<Transaction, String> _f$id = Field('id', _$id);
  static String _$title(Transaction v) => v.title;
  static const Field<Transaction, String> _f$title = Field('title', _$title);
  static String _$counterparty(Transaction v) => v.counterparty;
  static const Field<Transaction, String> _f$counterparty = Field(
    'counterparty',
    _$counterparty,
  );
  static int _$amountKobo(Transaction v) => v.amountKobo;
  static const Field<Transaction, int> _f$amountKobo = Field(
    'amountKobo',
    _$amountKobo,
  );
  static DateTime _$date(Transaction v) => v.date;
  static const Field<Transaction, DateTime> _f$date = Field('date', _$date);
  static TransactionCategory _$category(Transaction v) => v.category;
  static const Field<Transaction, TransactionCategory> _f$category = Field(
    'category',
    _$category,
  );
  static bool _$isPending(Transaction v) => v.isPending;
  static const Field<Transaction, bool> _f$isPending = Field(
    'isPending',
    _$isPending,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<Transaction> fields = const {
    #id: _f$id,
    #title: _f$title,
    #counterparty: _f$counterparty,
    #amountKobo: _f$amountKobo,
    #date: _f$date,
    #category: _f$category,
    #isPending: _f$isPending,
  };

  static Transaction _instantiate(DecodingData data) {
    return Transaction(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      counterparty: data.dec(_f$counterparty),
      amountKobo: data.dec(_f$amountKobo),
      date: data.dec(_f$date),
      category: data.dec(_f$category),
      isPending: data.dec(_f$isPending),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Transaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Transaction>(map);
  }

  static Transaction fromJson(String json) {
    return ensureInitialized().decodeJson<Transaction>(json);
  }
}

mixin TransactionMappable {
  String toJson() {
    return TransactionMapper.ensureInitialized().encodeJson<Transaction>(
      this as Transaction,
    );
  }

  Map<String, dynamic> toMap() {
    return TransactionMapper.ensureInitialized().encodeMap<Transaction>(
      this as Transaction,
    );
  }

  TransactionCopyWith<Transaction, Transaction, Transaction> get copyWith =>
      _TransactionCopyWithImpl<Transaction, Transaction>(
        this as Transaction,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TransactionMapper.ensureInitialized().stringifyValue(
      this as Transaction,
    );
  }

  @override
  bool operator ==(Object other) {
    return TransactionMapper.ensureInitialized().equalsValue(
      this as Transaction,
      other,
    );
  }

  @override
  int get hashCode {
    return TransactionMapper.ensureInitialized().hashValue(this as Transaction);
  }
}

extension TransactionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, Transaction, $Out> {
  TransactionCopyWith<$R, Transaction, $Out> get $asTransaction =>
      $base.as((v, t, t2) => _TransactionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TransactionCopyWith<$R, $In extends Transaction, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? title,
    String? counterparty,
    int? amountKobo,
    DateTime? date,
    TransactionCategory? category,
    bool? isPending,
  });
  TransactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TransactionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Transaction, $Out>
    implements TransactionCopyWith<$R, Transaction, $Out> {
  _TransactionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Transaction> $mapper =
      TransactionMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? title,
    String? counterparty,
    int? amountKobo,
    DateTime? date,
    TransactionCategory? category,
    bool? isPending,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (counterparty != null) #counterparty: counterparty,
      if (amountKobo != null) #amountKobo: amountKobo,
      if (date != null) #date: date,
      if (category != null) #category: category,
      if (isPending != null) #isPending: isPending,
    }),
  );
  @override
  Transaction $make(CopyWithData data) => Transaction(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    counterparty: data.get(#counterparty, or: $value.counterparty),
    amountKobo: data.get(#amountKobo, or: $value.amountKobo),
    date: data.get(#date, or: $value.date),
    category: data.get(#category, or: $value.category),
    isPending: data.get(#isPending, or: $value.isPending),
  );

  @override
  TransactionCopyWith<$R2, Transaction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TransactionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

