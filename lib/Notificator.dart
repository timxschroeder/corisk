import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificator {
  static final Notificator _instance = Notificator._internal();
  factory Notificator() => _instance;
  Notificator._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  void init() {
    final initIOS = IOSInitializationSettings(
      requestAlertPermission: false,
    );
    final initAndroid = AndroidInitializationSettings('@mipmpa/ic_launcher');
    final initPlugin = InitializationSettings(initAndroid, initIOS);
    _notifications.initialize(initPlugin);
  }

  Future showNotification(String message) async {
    final androidSpecifics = AndroidNotificationDetails(
        'corona_tracker_channel',
        'Corona Tracking',
        'Channel for tracking corona',
        importance: Importance.Max,
        priority: Priority.High);
    final iOSspecifics = IOSNotificationDetails();
    final platformSpecifics =
        NotificationDetails(androidSpecifics, iOSspecifics);
     await _notifications.show(0, 'Kritische Gefahr', message, platformSpecifics);
  }
}
