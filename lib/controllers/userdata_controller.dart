import 'package:get/get.dart';
import 'package:task_1/database/db_helper.dart';
import 'package:task_1/models/userdata_model.dart';

class UserDataController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  // User List containing all user datafor the Home Page
  var userList = <UserDataModel>[].obs;

  // Single user containing logged in user data
  var singleUser = <UserDataModel>[].obs;

// Insert user data into userData table
  Future<int> addUserData({UserDataModel userData}) async {
    return await DBHelper.insertLogin(userData);
  }

// Get Data from userData table
  void getAllUserData() async {
    List<Map<String, dynamic>> userData = await DBHelper.queryLogin();

    userList.assignAll(
        userData.map((data) => UserDataModel.fromJson(data)).toList());
  }

  void getUser(String email, String password) async {
    var userData = await DBHelper.checkUser(email, password);
    if (userData.isNotEmpty) {
      singleUser.assignAll(
          userData.map((data) => UserDataModel.fromJson(data)).toList());
    } else {
      emptySingleUser();
    }
  }

  // Empty single user list
  void emptySingleUser() {
    singleUser.clear();
  }
}
