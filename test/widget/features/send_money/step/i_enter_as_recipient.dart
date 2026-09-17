import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I enter {'ACC-001'} as recipient
Future<void> iEnterAsRecipient(WidgetTester tester, String param1) async {
  await tester.enterText(find.byKey(const Key('recipientField')), param1);
  await tester.pump();
}
