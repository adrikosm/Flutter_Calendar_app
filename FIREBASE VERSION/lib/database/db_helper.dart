import 'package:firebase_database/firebase_database.dart';
import 'package:task_1/models/task_model.dart';
import 'package:task_1/models/userdata_model.dart';

// Import FIre base and firebase cloud store
class DBHelper {
  static const String tableName = "task";
  static const String loginTableName = 'userData';
  final databaseReference = FirebaseDatabase.instance.ref();

  // ---------------------------------------------------------------------------
  // Functions for Task Table

  // ---------------------------------------------------------------------------

  DatabaseReference insert(TaskModel task) {
    print('\n  TASK INSERRT CALLED: ${task.toJson()}');
    var id = databaseReference.child("$tableName/").push();
    id.set(task.toJson());
    return id;
  }

  // Query for the task Table
  static query() async {
    var result = await FirebaseDatabase.instance.ref().child(tableName).once();
    return result.snapshot.value;
  }

  // Deletes a single task  element based on given id
  static delete(TaskModel taskModel, String taskID) {
    print("\n TASK DELETE CALLED VALUE: ${taskModel.toJson()}");
    print("\n TASK DELETE CALLED KEY: $taskID");
    FirebaseDatabase.instance.ref().child("$tableName/$taskID").remove();
  }

  // Updates a single row based on given id
  static updateRow(TaskModel taskModel, String taskID) {
    print("\n TASK UPDATE CALLED VALUE: ${taskModel.toJson()}");
    print("\n TASK UPDATE CALLED KEY: $taskID");
    FirebaseDatabase.instance
        .ref()
        .child("$tableName/$taskID")
        .update(taskModel.toJson());
  }

  // ---------------------------------------------------------------------------
  // Functions for User Table

  // ---------------------------------------------------------------------------

  DatabaseReference insertLogin(UserDataModel user) {
    print("\n INSERT LOGIN CALLED WITH USER:  $user");
    var id = databaseReference.child("$loginTableName/").push();
    id.set(user.toJson());
    return id;
  }

  // Query for the user Table
  static queryLogin() async {
    var result =
        await FirebaseDatabase.instance.ref().child(loginTableName).once();
    return result.snapshot.value;
  }
}
