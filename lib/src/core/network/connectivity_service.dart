import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nova_wallet/src/core/network/fake_api_client.dart';

abstract interface class ConnectivityService {
  Stream<bool> get online;
  Future<bool> get isOnline;
}

class DeviceConnectivityService implements ConnectivityService {
  DeviceConnectivityService(this._connectivity, this._apiClient);

  final Connectivity _connectivity;
  final FakeApiClient _apiClient;

  Future<bool> _verify(List<ConnectivityResult> results) async =>
      results.any((result) => result != ConnectivityResult.none) &&
      await _apiClient.health();

  @override
  Future<bool> get isOnline async =>
      _verify(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get online =>
      _connectivity.onConnectivityChanged.asyncMap(_verify).distinct();
}
