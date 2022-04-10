import 'database.dart';

class DatabaseProvider {
  static final DatabaseProvider _singleton = DatabaseProvider._internal();
  static late final Database _db;
  factory DatabaseProvider() {
    return _singleton;
  }

  DatabaseProvider._internal(){
    _db = Database();
  }

  Database getDatabase(){
    return _db;
  }
}
