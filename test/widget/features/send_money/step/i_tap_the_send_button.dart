import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I tap the send button
Future<void> iTapTheSendButton(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('sendButton')));
  await tester.pumpAndSettle();
}
