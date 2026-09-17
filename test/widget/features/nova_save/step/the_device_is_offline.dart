import 'package:flutter_test/flutter_test.dart';

import '_fixture.dart';

/// Usage: the device is offline
Future<void> theDeviceIsOffline(WidgetTester tester) async {
  fixture.isOffline = true;
}
