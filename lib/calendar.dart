import 'package:calendar/eventView.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'editAccountDetails.dart';
import 'login.dart';
import 'eventView.dart';

class CalendarSection extends StatefulWidget {
  const CalendarSection({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  final CalendarController _controller = CalendarController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: SfCalendar(
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
        //initialSelectedDate: DateTime(2021, 03, 01, 08, 30),
        dataSource: MeetingDataSource(getAppointments()),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 120.0,
              child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    'Hello User Test!',
                    style: TextStyle(color: Colors.white, fontSize: 23.0),
                  )),
            ),
            ListTile(
              title: const Text('Edit account'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const EditAccountDetailsSection()));
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
          // Add your onPressed code here!
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
      inspect(CalendarElement.appointment);
      inspect(calendarTapDetails);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventViewSection(
                  event: calendarTapDetails.appointments?[0])));
    }
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
  DateTime endTime = startTime.add(const Duration(hours: 6));

  for (int i = 0; i < 10; i++) {
    startTime = startTime.add(const Duration(days: 1));
    endTime = endTime.add(const Duration(days: 1));
    meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Board Meeting $i',
      location: 'location $i',
      color: Colors.blue,
      // recurrenceRule: 'FREQ=DAILY;COUNT=10',
      // isAllDay: false
    ));
  }
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
