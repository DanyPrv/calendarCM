import 'dart:io';

import 'package:calendar/entity/appointment.dart';
import 'package:calendar/entity/reminder.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../entity/user.dart';
import '../entity/appointment.dart';
import '../entity/reminder.dart';

part 'database.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Users, Appointments, Reminders])
class Database extends _$Database {
  Database() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 3;

  // users
  Future<List<User>> getUsers() async {
    return await select(users).get();
  }

  Future<User?> getUser(String email) async {
    try {
      User user = await (select(users)..where((tbl) => tbl.email.equals(email)))
          .getSingle();
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<int> registerUser(UsersCompanion entity) async {
    return await into(users).insert(entity);
  }

  Future<bool> updateUser(UsersCompanion entity) async {
    return await update(users).replace(entity);
  }

  // appointments
  Future<List<Appointment>> getAppointments() async {
    return await select(appointments).get();
  }

  Future<Appointment> getAppointmentById(int id) async {
    return await (select(appointments)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<List<Appointment>> getAppointmentsByUserId(int userId) async {
    return await (select(appointments)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
  }

  Future<List<Appointment>> getAppointmentsTodayByUserId(int userId) async {

    List<Appointment> apps =  await (select(appointments)
      ..where((tbl) => tbl.userId.equals(userId)))
        .get();
    List<Appointment> filtered = <Appointment>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for(Appointment app in apps){
      final dateToCheck = DateTime(app.startTime.year, app.startTime.month, app.startTime.day);
      if(dateToCheck == today) {
        filtered.add(app);
      }
    }
    return filtered;
  }

  Future<int> insertAppointment(AppointmentsCompanion entity) async {
    return await into(appointments).insert(entity);
  }

  Future<bool> updateAppointment(AppointmentsCompanion entity) async {
    return await update(appointments).replace(entity);
  }

  Future<int> deleteAppointment(int id) async {
    return await (delete(appointments)..where((tbl) => tbl.id.equals(id))).go();
  }

  // reminders
  Future<List<Reminder>> getRemindersByAppointmentId(int appointmentId) async {
    return await (select(reminders)
          ..where((tbl) => tbl.appointmentId.equals(appointmentId)))
        .get();
  }

  Future<List<Reminder>> getRemindersByUserAndDateRange(
      int userId, DateTime start, DateTime end) async {
    List<Appointment> apps = await (select(appointments)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
    List<int> appoinmentsId = <int>[];
    for (Appointment app in apps) {
      appoinmentsId.add(app.id);
    }
    List<Reminder> remindersList = await (select(reminders)
          ..where((tbl) => tbl.appointmentId.isIn(appoinmentsId)))
        .get();
    List<Reminder> finalList = <Reminder>[];
    for (Reminder rem in remindersList) {
      if (rem.reminderTime.isAfter(start) && rem.reminderTime.isBefore(end)) {
        finalList.add(rem);
      }
    }

    return finalList;
  }

  Future<int> insertReminder(RemindersCompanion entity) async {
    return await into(reminders).insert(entity);
  }

  Future<int> deleteReminders(int id) async {
    return await delete(reminders).go();
  }
}
