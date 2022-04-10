import 'package:calendar/Database/database.dart' as DB;
import 'package:calendar/addEditEvent.dart';
import 'package:calendar/eventView.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'Database/databaseProvider.dart';
import 'editAccountDetails.dart';
import 'login.dart';
import 'eventView.dart';
import 'Classes/calendarAppointment.dart';

class CalendarSection extends StatefulWidget {
  CalendarSection({Key? key, required this.title, required this.user})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final DB.User user;
  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  DatabaseProvider dbProvider = DatabaseProvider();
  final CalendarController _controller = CalendarController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var helloText = 'Hello ' + widget.user.username.toString() + '!';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: FutureBuilder<List<CalendarAppointment>>(
        future: getAppointments(dbProvider.getDatabase(), widget.user.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<CalendarAppointment>> snapshot) {
          if (snapshot.hasData) {
            return SfCalendar(
              view: CalendarView.month,
              allowedViews: const [
                CalendarView.day,
                CalendarView.month,
                CalendarView.week,
                CalendarView.schedule
              ],
              onTap: calendarTapped,
              allowDragAndDrop: true,
              firstDayOfWeek: 1,
              controller: _controller,
              initialDisplayDate: DateTime.now(),
              dataSource: MeetingDataSource(snapshot.data),
            );
          } else {
            return const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 120.0,
              child: DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: Text(
                    helloText,
                    style: const TextStyle(color: Colors.white, fontSize: 23.0),
                  )),
            ),
            ListTile(
              title: const Text('Edit account'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditAccountDetailsSection(
                              user: widget.user,
                            )));
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginSection()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DateTime today = DateTime.now();
          DateTime startTime = DateTime(
              today.year, today.month, today.day, today.hour, today.minute);
          DateTime endTime = startTime.add(const Duration(days: 1));

          CalendarAppointment event = CalendarAppointment(
              appointmentId: -1,
              startTime: startTime,
              endTime: endTime,
              subject: '',
              location: '',
              color: Colors.blue[300],
              reminders: [startTime.add(const Duration(minutes: 10))]);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEditEventSection(
                        event: event,
                        isEdit: false,
                        user: widget.user,
                      )));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell &&
        _controller.view == CalendarView.month) {
      _controller.view = CalendarView.day;
    }
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventViewSection(
                  event: calendarTapDetails.appointments?[0],
                  user: widget.user)));
    }
  }
}

Future<List<CalendarAppointment>> getAppointments(
    DB.Database _db, int userId) async {
  var apps = await _db.getAppointmentsByUserId(userId);
  List<CalendarAppointment> meetings = <CalendarAppointment>[];
  for (DB.Appointment app in apps) {
    var reminders = await _db.getRemindersByAppointmentId(app.id);
    List<DateTime> appointmentReminders = [];
    if (reminders.isNotEmpty) {
      for (DB.Reminder reminder in reminders) {
        appointmentReminders.add(reminder.reminderTime);
      }
    }
    meetings.add(CalendarAppointment(
        appointmentId: app.id,
        reminders: appointmentReminders,
        location: app.location,
        endTime: app.endTime,
        color: Colors.blue,
        startTime: app.startTime,
        subject: app.subject));
  }

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<CalendarAppointment>? source) {
    appointments = source;
  }
}
