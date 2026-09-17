import 'package:intl/intl.dart';

final _fmt = NumberFormat('#,##0.00', 'en_US');

String formatKobo(int kobo) => '₦${_fmt.format(kobo / 100)}';
