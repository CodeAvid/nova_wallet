// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'wallet.dart';

class WalletMapper extends ClassMapperBase<Wallet> {
  WalletMapper._();

  static WalletMapper? _instance;
  static WalletMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WalletMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Wallet';

  static int _$balanceKobo(Wallet v) => v.balanceKobo;
  static const Field<Wallet, int> _f$balanceKobo = Field(
    'balanceKobo',
    _$balanceKobo,
  );
  static String _$ownerName(Wallet v) => v.ownerName;
  static const Field<Wallet, String> _f$ownerName = Field(
    'ownerName',
    _$ownerName,
  );

  @override
  final MappableFields<Wallet> fields = const {
    #balanceKobo: _f$balanceKobo,
    #ownerName: _f$ownerName,
  };

  static Wallet _instantiate(DecodingData data) {
    return Wallet(
      balanceKobo: data.dec(_f$balanceKobo),
      ownerName: data.dec(_f$ownerName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Wallet fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Wallet>(map);
  }

  static Wallet fromJson(String json) {
    return ensureInitialized().decodeJson<Wallet>(json);
  }
}

mixin WalletMappable {
  String toJson() {
    return WalletMapper.ensureInitialized().encodeJson<Wallet>(this as Wallet);
  }

  Map<String, dynamic> toMap() {
    return WalletMapper.ensureInitialized().encodeMap<Wallet>(this as Wallet);
  }

  WalletCopyWith<Wallet, Wallet, Wallet> get copyWith =>
      _WalletCopyWithImpl<Wallet, Wallet>(this as Wallet, $identity, $identity);
  @override
  String toString() {
    return WalletMapper.ensureInitialized().stringifyValue(this as Wallet);
  }

  @override
  bool operator ==(Object other) {
    return WalletMapper.ensureInitialized().equalsValue(this as Wallet, other);
  }

  @override
  int get hashCode {
    return WalletMapper.ensureInitialized().hashValue(this as Wallet);
  }
}

extension WalletValueCopy<$R, $Out> on ObjectCopyWith<$R, Wallet, $Out> {
  WalletCopyWith<$R, Wallet, $Out> get $asWallet =>
      $base.as((v, t, t2) => _WalletCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class WalletCopyWith<$R, $In extends Wallet, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? balanceKobo, String? ownerName});
  WalletCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _WalletCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Wallet, $Out>
    implements WalletCopyWith<$R, Wallet, $Out> {
  _WalletCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Wallet> $mapper = WalletMapper.ensureInitialized();
  @override
  $R call({int? balanceKobo, String? ownerName}) => $apply(
    FieldCopyWithData({
      if (balanceKobo != null) #balanceKobo: balanceKobo,
      if (ownerName != null) #ownerName: ownerName,
    }),
  );
  @override
  Wallet $make(CopyWithData data) => Wallet(
    balanceKobo: data.get(#balanceKobo, or: $value.balanceKobo),
    ownerName: data.get(#ownerName, or: $value.ownerName),
  );

  @override
  WalletCopyWith<$R2, Wallet, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _WalletCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

