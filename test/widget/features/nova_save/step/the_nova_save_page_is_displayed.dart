import 'package:flutter_test/flutter_test.dart';

import '_fixture.dart';

/// Usage: the nova save page is displayed
Future<void> theNovaSavePageIsDisplayed(WidgetTester tester) async {
  // reset() is NOT called here — goal/offline state is set before this step.
  await tester.pumpWidget(fixture.buildPage());
  await tester.pumpAndSettle();
}
