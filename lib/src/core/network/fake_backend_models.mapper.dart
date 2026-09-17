// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fake_backend_models.dart';

class FakeBackendSeedMapper extends ClassMapperBase<FakeBackendSeed> {
  FakeBackendSeedMapper._();

  static FakeBackendSeedMapper? _instance;
  static FakeBackendSeedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FakeBackendSeedMapper._());
      WalletMapper.ensureInitialized();
      TransactionMapper.ensureInitialized();
      SavingsGoalMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FakeBackendSeed';

  static Wallet _$wallet(FakeBackendSeed v) => v.wallet;
  static const Field<FakeBackendSeed, Wallet> _f$wallet = Field(
    'wallet',
    _$wallet,
  );
  static List<Transaction> _$transactions(FakeBackendSeed v) => v.transactions;
  static const Field<FakeBackendSeed, List<Transaction>> _f$transactions =
      Field('transactions', _$transactions);
  static List<SavingsGoal> _$goals(FakeBackendSeed v) => v.goals;
  static const Field<FakeBackendSeed, List<SavingsGoal>> _f$goals = Field(
    'goals',
    _$goals,
  );

  @override
  final MappableFields<FakeBackendSeed> fields = const {
    #wallet: _f$wallet,
    #transactions: _f$transactions,
    #goals: _f$goals,
  };

  static FakeBackendSeed _instantiate(DecodingData data) {
    return FakeBackendSeed(
      wallet: data.dec(_f$wallet),
      transactions: data.dec(_f$transactions),
      goals: data.dec(_f$goals),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FakeBackendSeed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FakeBackendSeed>(map);
  }

  static FakeBackendSeed fromJson(String json) {
    return ensureInitialized().decodeJson<FakeBackendSeed>(json);
  }
}

mixin FakeBackendSeedMappable {
  String toJson() {
    return FakeBackendSeedMapper.ensureInitialized()
        .encodeJson<FakeBackendSeed>(this as FakeBackendSeed);
  }

  Map<String, dynamic> toMap() {
    return FakeBackendSeedMapper.ensureInitialized().encodeMap<FakeBackendSeed>(
      this as FakeBackendSeed,
    );
  }

  FakeBackendSeedCopyWith<FakeBackendSeed, FakeBackendSeed, FakeBackendSeed>
  get copyWith =>
      _FakeBackendSeedCopyWithImpl<FakeBackendSeed, FakeBackendSeed>(
        this as FakeBackendSeed,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FakeBackendSeedMapper.ensureInitialized().stringifyValue(
      this as FakeBackendSeed,
    );
  }

  @override
  bool operator ==(Object other) {
    return FakeBackendSeedMapper.ensureInitialized().equalsValue(
      this as FakeBackendSeed,
      other,
    );
  }

  @override
  int get hashCode {
    return FakeBackendSeedMapper.ensureInitialized().hashValue(
      this as FakeBackendSeed,
    );
  }
}

extension FakeBackendSeedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FakeBackendSeed, $Out> {
  FakeBackendSeedCopyWith<$R, FakeBackendSeed, $Out> get $asFakeBackendSeed =>
      $base.as((v, t, t2) => _FakeBackendSeedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FakeBackendSeedCopyWith<$R, $In extends FakeBackendSeed, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  WalletCopyWith<$R, Wallet, Wallet> get wallet;
  ListCopyWith<
    $R,
    Transaction,
    TransactionCopyWith<$R, Transaction, Transaction>
  >
  get transactions;
  ListCopyWith<
    $R,
    SavingsGoal,
    SavingsGoalCopyWith<$R, SavingsGoal, SavingsGoal>
  >
  get goals;
  $R call({
    Wallet? wallet,
    List<Transaction>? transactions,
    List<SavingsGoal>? goals,
  });
  FakeBackendSeedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FakeBackendSeedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FakeBackendSeed, $Out>
    implements FakeBackendSeedCopyWith<$R, FakeBackendSeed, $Out> {
  _FakeBackendSeedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FakeBackendSeed> $mapper =
      FakeBackendSeedMapper.ensureInitialized();
  @override
  WalletCopyWith<$R, Wallet, Wallet> get wallet =>
      $value.wallet.copyWith.$chain((v) => call(wallet: v));
  @override
  ListCopyWith<
    $R,
    Transaction,
    TransactionCopyWith<$R, Transaction, Transaction>
  >
  get transactions => ListCopyWith(
    $value.transactions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(transactions: v),
  );
  @override
  ListCopyWith<
    $R,
    SavingsGoal,
    SavingsGoalCopyWith<$R, SavingsGoal, SavingsGoal>
  >
  get goals => ListCopyWith(
    $value.goals,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(goals: v),
  );
  @override
  $R call({
    Wallet? wallet,
    List<Transaction>? transactions,
    List<SavingsGoal>? goals,
  }) => $apply(
    FieldCopyWithData({
      if (wallet != null) #wallet: wallet,
      if (transactions != null) #transactions: transactions,
      if (goals != null) #goals: goals,
    }),
  );
  @override
  FakeBackendSeed $make(CopyWithData data) => FakeBackendSeed(
    wallet: data.get(#wallet, or: $value.wallet),
    transactions: data.get(#transactions, or: $value.transactions),
    goals: data.get(#goals, or: $value.goals),
  );

  @override
  FakeBackendSeedCopyWith<$R2, FakeBackendSeed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FakeBackendSeedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SubmissionResultMapper extends ClassMapperBase<SubmissionResult> {
  SubmissionResultMapper._();

  static SubmissionResultMapper? _instance;
  static SubmissionResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubmissionResultMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SubmissionResult';

  static bool _$accepted(SubmissionResult v) => v.accepted;
  static const Field<SubmissionResult, bool> _f$accepted = Field(
    'accepted',
    _$accepted,
  );
  static bool _$alreadyProcessed(SubmissionResult v) => v.alreadyProcessed;
  static const Field<SubmissionResult, bool> _f$alreadyProcessed = Field(
    'alreadyProcessed',
    _$alreadyProcessed,
  );

  @override
  final MappableFields<SubmissionResult> fields = const {
    #accepted: _f$accepted,
    #alreadyProcessed: _f$alreadyProcessed,
  };

  static SubmissionResult _instantiate(DecodingData data) {
    return SubmissionResult(
      accepted: data.dec(_f$accepted),
      alreadyProcessed: data.dec(_f$alreadyProcessed),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SubmissionResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SubmissionResult>(map);
  }

  static SubmissionResult fromJson(String json) {
    return ensureInitialized().decodeJson<SubmissionResult>(json);
  }
}

mixin SubmissionResultMappable {
  String toJson() {
    return SubmissionResultMapper.ensureInitialized()
        .encodeJson<SubmissionResult>(this as SubmissionResult);
  }

  Map<String, dynamic> toMap() {
    return SubmissionResultMapper.ensureInitialized()
        .encodeMap<SubmissionResult>(this as SubmissionResult);
  }

  SubmissionResultCopyWith<SubmissionResult, SubmissionResult, SubmissionResult>
  get copyWith =>
      _SubmissionResultCopyWithImpl<SubmissionResult, SubmissionResult>(
        this as SubmissionResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SubmissionResultMapper.ensureInitialized().stringifyValue(
      this as SubmissionResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return SubmissionResultMapper.ensureInitialized().equalsValue(
      this as SubmissionResult,
      other,
    );
  }

  @override
  int get hashCode {
    return SubmissionResultMapper.ensureInitialized().hashValue(
      this as SubmissionResult,
    );
  }
}

extension SubmissionResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SubmissionResult, $Out> {
  SubmissionResultCopyWith<$R, SubmissionResult, $Out>
  get $asSubmissionResult =>
      $base.as((v, t, t2) => _SubmissionResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SubmissionResultCopyWith<$R, $In extends SubmissionResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? accepted, bool? alreadyProcessed});
  SubmissionResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SubmissionResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SubmissionResult, $Out>
    implements SubmissionResultCopyWith<$R, SubmissionResult, $Out> {
  _SubmissionResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SubmissionResult> $mapper =
      SubmissionResultMapper.ensureInitialized();
  @override
  $R call({bool? accepted, bool? alreadyProcessed}) => $apply(
    FieldCopyWithData({
      if (accepted != null) #accepted: accepted,
      if (alreadyProcessed != null) #alreadyProcessed: alreadyProcessed,
    }),
  );
  @override
  SubmissionResult $make(CopyWithData data) => SubmissionResult(
    accepted: data.get(#accepted, or: $value.accepted),
    alreadyProcessed: data.get(#alreadyProcessed, or: $value.alreadyProcessed),
  );

  @override
  SubmissionResultCopyWith<$R2, SubmissionResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SubmissionResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

