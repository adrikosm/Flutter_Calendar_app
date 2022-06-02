import 'package:get/get.dart';
import 'package:task_1/database/db_helper.dart';
import 'package:task_1/models/userdata_model.dart';

class UserDataController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  // User List for the Home Page
  var userList = <UserDataModel>[].obs;

// Insert user data into userData table
  Future<int> addUserData({UserDataModel userData}) async {
    return await DBHelper.insertLogin(userData);
  }

// Get Data from userData table
  void getUserData() async {
    List<Map<String, dynamic>> userData = await DBHelper.queryLogin();

    userList.assignAll(
        userData.map((data) => UserDataModel.fromJson(data)).toList());
  }
}
