import 'package:flutter_test/flutter_test.dart';

import '_fixture.dart';

/// Usage: the wallet balance is {500000} kobo
Future<void> theWalletBalanceIsKobo(WidgetTester tester, num param1) async {
  fixture.walletBalanceKobo = param1.toInt();
}
