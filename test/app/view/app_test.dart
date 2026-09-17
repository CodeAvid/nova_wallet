import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/app/app.dart';
import 'package:nova_wallet/src/features/wallet_home/presentation/pages/wallet_home_page.dart';

void main() {
  group('App', () {
    testWidgets('renders WalletHomePage', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.byType(WalletHomePage), findsOneWidget);
    });
  });
}
