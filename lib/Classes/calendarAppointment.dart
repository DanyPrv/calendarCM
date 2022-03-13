import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarAppointment extends Appointment {
  List<DateTime> reminders = [];
  CalendarAppointment(
      {startTime, endTime, subject, location, color, required this.reminders})
      : super(
            startTime: startTime,
            endTime: endTime,
            subject: subject,
            location: location,
            color: color);
}
