import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I contribute {10000} kobo
Future<void> iContributeKobo(WidgetTester tester, num param1) async {
  await tester.enterText(
    find.byKey(const Key('contributionField')),
    '${param1.toInt()}',
  );
  await tester.pump();
  await tester.tap(find.byKey(const Key('contributeButton')));
  await tester.pumpAndSettle();
  // Confirmation screen
  await tester.tap(find.byKey(const Key('authorizeContributeButton')));
  await tester.pumpAndSettle();
  // PIN entry — correct PIN is 1234
  for (final digit in ['1', '2', '3', '4']) {
    await tester.tap(find.text(digit).last);
    await tester.pump();
  }
  await tester.pumpAndSettle();
}
