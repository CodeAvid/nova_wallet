import 'package:flutter_test/flutter_test.dart';

import '_fixture.dart';

/// Usage: the send money page is displayed
Future<void> theSendMoneyPageIsDisplayed(WidgetTester tester) async {
  fixture.reset();
  await tester.pumpWidget(fixture.buildPage());
  await tester.pumpAndSettle();
}
