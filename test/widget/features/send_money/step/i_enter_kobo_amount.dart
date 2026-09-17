import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I enter {10000} kobo amount
Future<void> iEnterKoboAmount(WidgetTester tester, num param1) async {
  await tester.enterText(
    find.byKey(const Key('amountField')),
    '${param1.toInt()}',
  );
  await tester.pump();
}
