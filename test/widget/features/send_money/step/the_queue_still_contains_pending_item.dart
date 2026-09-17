import 'package:flutter_test/flutter_test.dart';

import '_fixture.dart';

/// Usage: the queue still contains {1} pending item
Future<void> theQueueStillContainsPendingItem(
  WidgetTester tester,
  num param1,
) async {
  // Rebuild must not duplicate the queue entry.
  expect(fixture.repo.items.length, param1.toInt());
}
