import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract interface class AppNotificationService {
  Future<void> initialize();
  Future<void> show({required String title, required String body});
}

class LocalNotificationService implements AppNotificationService {
  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  var _nextId = 0;

  @override
  Future<void> initialize() async {
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
          macOS: DarwinInitializationSettings(),
        ),
      );
    } on Object {
      // Platform implementations are intentionally absent in pure widget tests.
    }
  }

  @override
  Future<void> show({required String title, required String body}) async {
    try {
      await _plugin.show(
        id: _nextId++,
        title: title,
        body: body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'nova_wallet_activity',
            'NovaWallet activity',
            channelDescription:
                'Updates about NovaWallet actions and transfers',
          ),
          iOS: DarwinNotificationDetails(),
          macOS: DarwinNotificationDetails(),
        ),
      );
    } on Object {
      // A notification failure must never block an already-confirmed transfer.
    }
  }
}
