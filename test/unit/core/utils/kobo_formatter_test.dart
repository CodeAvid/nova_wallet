import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/src/core/utils/kobo_formatter.dart';

void main() {
  group('formatKobo', () {
    test('0 kobo formats to ₦0.00', () => expect(formatKobo(0), '₦0.00'));
    test('1 kobo formats to ₦0.01', () => expect(formatKobo(1), '₦0.01'));
    test('100 kobo formats to ₦1.00', () => expect(formatKobo(100), '₦1.00'));
    test(
      '99999 kobo formats to ₦999.99',
      () => expect(formatKobo(99999), '₦999.99'),
    );
    test(
      '500000 kobo formats to ₦5,000.00',
      () => expect(formatKobo(500000), '₦5,000.00'),
    );
  });
}
