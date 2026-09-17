import 'package:flutter_test/flutter_test.dart';

import '_fixture.dart';

/// Usage: the idempotency key has not changed
Future<void> theIdempotencyKeyHasNotChanged(WidgetTester tester) async {
  expect(fixture.capturedIdempotencyKey, isNotNull);
  expect(
    fixture.repo.items.last.idempotencyKey,
    fixture.capturedIdempotencyKey,
    reason: 'Idempotency key must not be regenerated on rebuild',
  );
}
