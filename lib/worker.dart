import 'dart:math';

import 'package:calendar/Database/database.dart';
import 'package:calendar/Database/databaseProvider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const initializeReminderAction = "initializeReminder";
const fetchReminderAction = "fetchReminder";
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case initializeReminderAction:
        await Workmanager().registerPeriodicTask(
          "2",
          fetchReminderAction,
          frequency: const Duration(hours: 24),
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
        );
        break;
      case fetchReminderAction:
        // Code to run in background
        if (DatabaseProvider().getUser() == null) {
          break;
        }
        List<Appointment> reminders = await DatabaseProvider()
            .getDatabase()
            .getAppointmentsByUserId(DatabaseProvider().getUser()!);
        String message =
            'You will have ' + reminders.length.toString() + ' events today';
        await createNotification(message, DateTime.now());

        break;
    }
    return Future.value(true);
  });
}

Future<List<Reminder>> getReminders() async {
  if(DatabaseProvider().getUser() == null) {
    return <Reminder>[];
  }
  return await DatabaseProvider()
      .getDatabase()
      .getRemindersByUserAndDateRange(DatabaseProvider().getUser()!,
          DateTime.now(), DateTime.now().add(const Duration(minutes: 15)));
}

Future<void> createNotification(String message, DateTime date) async {
  tz.initializeTimeZones();
  await flutterLocalNotificationsPlugin.zonedSchedule(
      Random().nextInt(20000),
      'Event',
      message,
      tz.TZDateTime.from(date, tz.local),
      const NotificationDetails(
          android: AndroidNotificationDetails('channel_id', 'channel_name',
              channelDescription: 'channel_description')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}
Future<void> createNotificationFromReminder(Reminder reminder) async {
  String eventBody = 'You have one event in ' +
      reminder.eventStartDate.difference(reminder.reminderTime).inMinutes.toString()+
      ' minute(s) ';
  await createNotification(eventBody, reminder.reminderTime);
}