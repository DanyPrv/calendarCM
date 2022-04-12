import 'database.dart';

class DatabaseProvider {
  static final DatabaseProvider _singleton = DatabaseProvider._internal();
  static late final Database _db;
  static late int? userId;
  factory DatabaseProvider() {
    return _singleton;
  }

  DatabaseProvider._internal(){
    _db = Database();
    userId = null;
  }
  void setUserId(int? id){
    userId = id;
  }
  Database getDatabase(){
    return _db;
  }
  int? getUser(){
    return userId;
  }
}
