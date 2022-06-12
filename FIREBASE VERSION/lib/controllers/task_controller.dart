import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:task_1/database/db_helper.dart';
import 'package:task_1/models/task_model.dart';

class TaskController extends GetxController {
  // Insert Data to table
  DatabaseReference addTask({TaskModel task}) {
    var db = DBHelper();
    return db.insert(task);
  }

  // Task List for the Home Page
  var taskList = <TaskModel>[].obs;
  var taskID = <String>[].obs;
  // Get Data from table
  // void getTasks() async {
  //   List<Map<String, dynamic>> tasks = await DBHelper.query();

  //   taskList.assignAll(tasks.map((data) => TaskModel.fromJson(data)).toList());
  // }

  void getTasks() async {
    taskList.clear();
    taskID.clear();
    var tasks = await DBHelper.query();
    Map<dynamic, dynamic> values = tasks;
    values.forEach((key, value) {
      taskList.add(TaskModel.fromJson(value));
      taskID.add(key);
    });
  }

  // Delete Data from table
  static deleteTask(TaskModel task, String taskID) {
    DBHelper.delete(task, taskID);
  }

  // Update Data
  static updateTask(TaskModel task, String taskID) {
    DBHelper.updateRow(task, taskID);
  }
}
