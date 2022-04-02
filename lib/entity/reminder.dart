import 'package:drift/drift.dart';
import 'appointment.dart';

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get reminderTime => dateTime()();
  IntColumn get appointmentId => integer().references(Appointments, #id)();
}
