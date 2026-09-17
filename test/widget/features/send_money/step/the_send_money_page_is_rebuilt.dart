import 'package:flutter_test/flutter_test.dart';

import '_fixture.dart';

/// Usage: the send money page is rebuilt
Future<void> theSendMoneyPageIsRebuilt(WidgetTester tester) async {
  // Capture key before rebuild — must be the same after.
  fixture.capturedIdempotencyKey = fixture.repo.items.isNotEmpty
      ? fixture.repo.items.last.idempotencyKey
      : null;
  // Rebuild by pumping the same widget tree again.
  await tester.pumpWidget(fixture.buildPage());
  await tester.pumpAndSettle();
}
