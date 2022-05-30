import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:task_1/models/task_model.dart';
import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

// SECONDARY CLASS ITERATION

class DBHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static const String tableName = "task";

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
  }

  static Future<int> insert(TaskModel task) async {
    print("INSERT FUNCTION CALLED DATA:" + task.toJson().toString());
    Database db = await DBHelper.instance.database;
    return await db.insert(DBHelper.tableName, task.toJson());
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("Query Function Called");
    Database db = await instance.database;
    return await db.query(tableName);
  }

  // Deletes a single element based on given id
  static delete(TaskModel task) async {
    print("DELETE FUNCTION CALLED");
    Database db = await instance.database;
    db.delete(tableName, where: 'id = ?', whereArgs: [task.id]);
  }

// Deletes everything in the table
  static deleteAll() async {
    Database db = await instance.database;
    return await db.rawDelete("Delete from $tableName");
  }

  // Updates a single row based on given id
  static updateRow(TaskModel task) async {
    print("UPDATE FUNCTION CALLED");
    Database db = await instance.database;
    db.update(DBHelper.tableName, task.toJson(),
        where: 'id = ?', whereArgs: [task.id]);
  }
}
