import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const fetchReminder = "fetchReminder";
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchReminder:
      // Code to run in background
        List<DateTime> reminders = getReminders();
        tz.initializeTimeZones();

        for(int i=0; i<reminders.length; i++) {
          String eventBody = 'You have one event in ' +
              reminders[i].difference(DateTime.now()).inMinutes.toString() +
              ' minute(s) ' + reminders[i].toString();
          await flutterLocalNotificationsPlugin.zonedSchedule(
              i,
              'Event',
              eventBody,
              tz.TZDateTime.from(reminders[i], tz.local),
              const NotificationDetails(
                  android: AndroidNotificationDetails(
                      'channel_id', 'channel_name',
                      channelDescription: 'channel_description')),
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
        }
        break;
    }
    return Future.value(true);
  });
}

List<DateTime> getReminders() {
  final DateTime today = DateTime.now();
  return [
    today.add(const Duration(minutes: 4)),
    today.add(const Duration(minutes: 3)),
    today.add(const Duration(minutes: 2))
  ];
}

