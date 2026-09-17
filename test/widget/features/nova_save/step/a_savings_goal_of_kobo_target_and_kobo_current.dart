import 'package:flutter_test/flutter_test.dart';

import '_fixture.dart';

/// Usage: a savings goal of {100000} kobo target and {50000} kobo current
Future<void> aSavingsGoalOfKoboTargetAndKoboCurrent(
  WidgetTester tester,
  num param1,
  num param2,
) async {
  fixture.targetKobo = param1.toInt();
  fixture.currentKobo = param2.toInt();
}
