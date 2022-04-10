import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarAppointment extends Appointment {
  List<DateTime> reminders = [];
  int appointmentId = 0;
  CalendarAppointment(
      {startTime,
      endTime,
      subject,
      location,
      color,
      required this.reminders,
      required this.appointmentId})
      : super(
            startTime: startTime,
            endTime: endTime,
            subject: subject,
            location: location,
            color: color);
}
