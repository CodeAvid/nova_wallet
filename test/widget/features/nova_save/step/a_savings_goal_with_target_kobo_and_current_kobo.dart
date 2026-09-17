import 'package:flutter_test/flutter_test.dart';

import '_fixture.dart';

/// Usage: a savings goal with target `<target>` kobo
/// and current `<current>` kobo
Future<void> aSavingsGoalWithTargetKoboAndCurrentKobo(
  WidgetTester tester,
  dynamic target,
  dynamic current,
) async {
  fixture.targetKobo = (target as num).toInt();
  fixture.currentKobo = (current as num).toInt();
}
