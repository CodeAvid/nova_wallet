// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'savings_goal.dart';

class SavingsGoalMapper extends ClassMapperBase<SavingsGoal> {
  SavingsGoalMapper._();

  static SavingsGoalMapper? _instance;
  static SavingsGoalMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SavingsGoalMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SavingsGoal';

  static int _$targetKobo(SavingsGoal v) => v.targetKobo;
  static const Field<SavingsGoal, int> _f$targetKobo = Field(
    'targetKobo',
    _$targetKobo,
  );
  static int _$currentKobo(SavingsGoal v) => v.currentKobo;
  static const Field<SavingsGoal, int> _f$currentKobo = Field(
    'currentKobo',
    _$currentKobo,
  );
  static String _$id(SavingsGoal v) => v.id;
  static const Field<SavingsGoal, String> _f$id = Field(
    'id',
    _$id,
    opt: true,
    def: 'emergency-fund',
  );
  static String _$name(SavingsGoal v) => v.name;
  static const Field<SavingsGoal, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
    def: 'Emergency Fund',
  );
  static DateTime? _$targetDate(SavingsGoal v) => v.targetDate;
  static const Field<SavingsGoal, DateTime> _f$targetDate = Field(
    'targetDate',
    _$targetDate,
    opt: true,
  );
  static String _$category(SavingsGoal v) => v.category;
  static const Field<SavingsGoal, String> _f$category = Field(
    'category',
    _$category,
    opt: true,
    def: 'target',
  );
  static int _$durationMonths(SavingsGoal v) => v.durationMonths;
  static const Field<SavingsGoal, int> _f$durationMonths = Field(
    'durationMonths',
    _$durationMonths,
    opt: true,
    def: 12,
  );
  static String _$frequency(SavingsGoal v) => v.frequency;
  static const Field<SavingsGoal, String> _f$frequency = Field(
    'frequency',
    _$frequency,
    opt: true,
    def: 'monthly',
  );
  static int _$amountPerPeriodKobo(SavingsGoal v) => v.amountPerPeriodKobo;
  static const Field<SavingsGoal, int> _f$amountPerPeriodKobo = Field(
    'amountPerPeriodKobo',
    _$amountPerPeriodKobo,
    opt: true,
    def: 0,
  );
  static String _$status(SavingsGoal v) => v.status;
  static const Field<SavingsGoal, String> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: 'active',
  );
  static DateTime? _$createdAt(SavingsGoal v) => v.createdAt;
  static const Field<SavingsGoal, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    opt: true,
  );

  @override
  final MappableFields<SavingsGoal> fields = const {
    #targetKobo: _f$targetKobo,
    #currentKobo: _f$currentKobo,
    #id: _f$id,
    #name: _f$name,
    #targetDate: _f$targetDate,
    #category: _f$category,
    #durationMonths: _f$durationMonths,
    #frequency: _f$frequency,
    #amountPerPeriodKobo: _f$amountPerPeriodKobo,
    #status: _f$status,
    #createdAt: _f$createdAt,
  };

  static SavingsGoal _instantiate(DecodingData data) {
    return SavingsGoal(
      targetKobo: data.dec(_f$targetKobo),
      currentKobo: data.dec(_f$currentKobo),
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      targetDate: data.dec(_f$targetDate),
      category: data.dec(_f$category),
      durationMonths: data.dec(_f$durationMonths),
      frequency: data.dec(_f$frequency),
      amountPerPeriodKobo: data.dec(_f$amountPerPeriodKobo),
      status: data.dec(_f$status),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SavingsGoal fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SavingsGoal>(map);
  }

  static SavingsGoal fromJson(String json) {
    return ensureInitialized().decodeJson<SavingsGoal>(json);
  }
}

mixin SavingsGoalMappable {
  String toJson() {
    return SavingsGoalMapper.ensureInitialized().encodeJson<SavingsGoal>(
      this as SavingsGoal,
    );
  }

  Map<String, dynamic> toMap() {
    return SavingsGoalMapper.ensureInitialized().encodeMap<SavingsGoal>(
      this as SavingsGoal,
    );
  }

  SavingsGoalCopyWith<SavingsGoal, SavingsGoal, SavingsGoal> get copyWith =>
      _SavingsGoalCopyWithImpl<SavingsGoal, SavingsGoal>(
        this as SavingsGoal,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SavingsGoalMapper.ensureInitialized().stringifyValue(
      this as SavingsGoal,
    );
  }

  @override
  bool operator ==(Object other) {
    return SavingsGoalMapper.ensureInitialized().equalsValue(
      this as SavingsGoal,
      other,
    );
  }

  @override
  int get hashCode {
    return SavingsGoalMapper.ensureInitialized().hashValue(this as SavingsGoal);
  }
}

extension SavingsGoalValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SavingsGoal, $Out> {
  SavingsGoalCopyWith<$R, SavingsGoal, $Out> get $asSavingsGoal =>
      $base.as((v, t, t2) => _SavingsGoalCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SavingsGoalCopyWith<$R, $In extends SavingsGoal, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? targetKobo,
    int? currentKobo,
    String? id,
    String? name,
    DateTime? targetDate,
    String? category,
    int? durationMonths,
    String? frequency,
    int? amountPerPeriodKobo,
    String? status,
    DateTime? createdAt,
  });
  SavingsGoalCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SavingsGoalCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SavingsGoal, $Out>
    implements SavingsGoalCopyWith<$R, SavingsGoal, $Out> {
  _SavingsGoalCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SavingsGoal> $mapper =
      SavingsGoalMapper.ensureInitialized();
  @override
  $R call({
    int? targetKobo,
    int? currentKobo,
    String? id,
    String? name,
    Object? targetDate = $none,
    String? category,
    int? durationMonths,
    String? frequency,
    int? amountPerPeriodKobo,
    String? status,
    Object? createdAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (targetKobo != null) #targetKobo: targetKobo,
      if (currentKobo != null) #currentKobo: currentKobo,
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (targetDate != $none) #targetDate: targetDate,
      if (category != null) #category: category,
      if (durationMonths != null) #durationMonths: durationMonths,
      if (frequency != null) #frequency: frequency,
      if (amountPerPeriodKobo != null)
        #amountPerPeriodKobo: amountPerPeriodKobo,
      if (status != null) #status: status,
      if (createdAt != $none) #createdAt: createdAt,
    }),
  );
  @override
  SavingsGoal $make(CopyWithData data) => SavingsGoal(
    targetKobo: data.get(#targetKobo, or: $value.targetKobo),
    currentKobo: data.get(#currentKobo, or: $value.currentKobo),
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    targetDate: data.get(#targetDate, or: $value.targetDate),
    category: data.get(#category, or: $value.category),
    durationMonths: data.get(#durationMonths, or: $value.durationMonths),
    frequency: data.get(#frequency, or: $value.frequency),
    amountPerPeriodKobo: data.get(
      #amountPerPeriodKobo,
      or: $value.amountPerPeriodKobo,
    ),
    status: data.get(#status, or: $value.status),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  SavingsGoalCopyWith<$R2, SavingsGoal, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SavingsGoalCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

