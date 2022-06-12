import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:task_1/database/db_helper.dart';
import 'package:task_1/models/userdata_model.dart';

class UserDataController extends GetxController {
  // User List containing all user datafor the Home Page
  var userList = <UserDataModel>[].obs;
  var userListID = <String>[].obs;

  // Single user containing logged in user data
  var singleUser = <UserDataModel>[].obs;
  var singleUserID = <String>[].obs;

// Insert user data into userData table
  DatabaseReference addUserData({UserDataModel userData}) {
    var db = DBHelper();
    return db.insertLogin(userData);
  }

// Get Data from userData table
  void getAllUserData() async {
    userList.clear();
    userListID.clear();
    var userData = await DBHelper.queryLogin();
    Map<dynamic, dynamic> values = userData;
    values.forEach((key, value) {
      userList.add(UserDataModel.fromJson(value));
      userListID.add(key);
    });
  }

  // Gets a single user data from userData table
  // Based on email and password
  void getSingleUser(dynamic email, dynamic password) async {
    bool found = false;
    // var userData = await DBHelper.checkUser(email, password);
    for (int i = 0; i < userList.length; i++) {
      if (userList[i].email == email && userList[i].password == password) {
        print("USER FOUND");
        found = true;
        singleUser.assign(userList[i]);
        singleUserID.assign(userListID[i]);

        print("USER INFO: ${userList[i].toJson()}");
        print("USER KEY: $singleUserID");
      }
      if (found == false) {
        print("USER NOT FOUND SO EMPTYING SINGLE USER");
        emptySingleUser();
      }
    }
  }

  // Empty single user list
  void emptySingleUser() {
    singleUser.clear();
    singleUserID.clear();
  }
}
