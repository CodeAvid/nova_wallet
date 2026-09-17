import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I tap the next button
Future<void> iTapTheNextButton(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('nextButton')));
  await tester.pumpAndSettle();
}
