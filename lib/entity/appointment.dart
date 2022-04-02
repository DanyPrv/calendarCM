import 'package:drift/drift.dart';
import 'user.dart';

class Appointments extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get subject => text()();
  TextColumn get location => text()();
  IntColumn get userId => integer().references(Users, #id)();
}
