import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  static Future _notificationDetails() async{
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled=false})async{
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    tz.initializeTimeZones();

    await _notifications.initialize(settings,
    onSelectNotification: (payload) async {},);
  }
  static Future showScheduledNotification({
      int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate
  })async =>
      _notifications.zonedSchedule(id,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          await _notificationDetails(),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
      );

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  })async =>
      _notifications.show(id,
          title,
          body,
          await _notificationDetails(),
          payload: payload,

      );
}