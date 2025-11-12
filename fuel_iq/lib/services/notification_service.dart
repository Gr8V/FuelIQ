import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _notifications.initialize(initSettings);
  }

  static Future<void> requestPermission() async {
    // For Android 13+ (Tiramisu, API 33)
    final androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();


    // iOS support (for completeness)
    final iosImplementation = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosImplementation?.requestPermissions(alert: true, badge: true, sound: true);
  }


  static Future<void> showNotification({
    required String title,
    required String body,
    int? id,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'fuel_iq_notifications',
      'FuelIQ Alerts',
      channelDescription: 'Notifications from the FuelIQ app',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    // If id isn’t provided, generate one based on timestamp
    final uniqueId = id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await _notifications.show(uniqueId, title, body, notificationDetails);
  }

  static Future<void> sendQueuedNotifications(List<Map<String, String>> notifications) async {
    for (int i = 0; i < notifications.length; i++) {
      final n = notifications[i];
      await Future.delayed(Duration(milliseconds: i * 300)); // 0.3 sec gap
      await NotificationService.showNotification(
        title: n['title']!,
        body: n['body']!,
      );
    }
  }


}
