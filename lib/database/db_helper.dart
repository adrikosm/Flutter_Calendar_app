import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:task_1/models/task_model.dart';
import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:task_1/models/userdata_model.dart';

// SECONDARY CLASS ITERATION

class DBHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static const String tableName = "task";
  static const String loginTableName = 'userData';

  // make this a singleton class
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await initDb();
    return _database;
  }

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    // Create table for tasks
    await db.execute('''
        CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title STRING,
        description STRING,
        assign STRING,
        date STRING,
        startTime STRING,
        endTime STRING,
        color STRING,
        remind INTEGER,
        isCompleted INTEGER
        )
                        ''');
    // Create table for login
    await db.execute(''' 
    CREATE TABLE $loginTableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      firstName STRING,
      lastName STRING,
      email STRING,
      password STRING,
      color STRING,
      startTime STRING,
      endTime STRING,
      usertype STRING,
      isLoggedIn STRING
    )
    ''');
  }

  // HELPER METHODS FOR TASK TABLE
  static Future<int> insert(TaskModel task) async {
    // print("TASK INSERT:" + task.toJson().toString());
    Database db = await DBHelper.instance.database;
    return await db.insert(DBHelper.tableName, task.toJson());
  }

  static Future<List<Map<String, dynamic>>> query() async {
    // print("TASK QUERY CALLED");
    Database db = await instance.database;
    return await db.query(tableName);
  }

  // Deletes a single element based on given id
  static delete(TaskModel task) async {
    // print("TASK DELETE CALLED");
    Database db = await instance.database;
    db.delete(tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  // Updates a single row based on given id
  static updateRow(TaskModel task) async {
    // print("TASK UPDATE CALLED");
    Database db = await instance.database;
    db.update(DBHelper.tableName, task.toJson(),
        where: 'id = ?', whereArgs: [task.id]);
  }

  // HELPER METHODS FOR LOGIN TABLE

  // Inserts a single row in the table with all the user data
  static Future<int> insertLogin(UserDataModel user) async {
    // print("LOGIN INSERT :" + user.toJson().toString());
    Database db = await DBHelper.instance.database;
    return await db.insert(DBHelper.loginTableName, user.toJson());
  }

  static Future<List<Map<String, dynamic>>> queryLogin() async {
    // print("LOGIN QUERY CALLED");
    Database db = await instance.database;
    return await db.query(loginTableName);
  }

  static Future<List<Map<String, dynamic>>> checkUser(
      String email, String password) async {
    Database db = await instance.database;
    return db.rawQuery(
        'SELECT * FROM $loginTableName WHERE email = ? AND password = ?',
        [email, password]);
  }
}
// Deletes everything in both tables
// static deleteAll() async {
//   print("DELETE ALL FUNCTION CALLED");
//   Database db = await instance.database;
//   await db.rawDelete("Delete from $tableName");
//   await db.rawDelete("Delete from $loginTableName");
// }
