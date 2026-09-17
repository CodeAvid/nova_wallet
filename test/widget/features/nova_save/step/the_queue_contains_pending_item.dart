import 'package:flutter_test/flutter_test.dart';

import '_fixture.dart';

/// Usage: the queue contains {1} pending item
Future<void> theQueueContainsPendingItem(
  WidgetTester tester,
  num param1,
) async {
  expect(fixture.repo.pendingItems.length, param1.toInt());
}
