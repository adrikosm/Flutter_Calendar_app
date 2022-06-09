import 'package:get/get.dart';
import 'package:task_1/database/db_helper.dart';
import 'package:task_1/models/task_model.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  // Insert Data to table
  Future<int> addTask({TaskModel task}) async {
    return await DBHelper.insert(task);
  }

  // Task List for the Home Page
  var taskList = <TaskModel>[].obs;

  // Get Data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();

    taskList.assignAll(tasks.map((data) => TaskModel.fromJson(data)).toList());
  }

  // Delete Data from table
  static deleteTask(TaskModel task) {
    DBHelper.delete(task);
  }

  // Update Data
  static updateTask(TaskModel task) {
    DBHelper.updateRow(task);
  }
}
