import 'package:nova_wallet/app/app.dart';
import 'package:nova_wallet/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
