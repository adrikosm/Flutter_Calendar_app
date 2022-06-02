import 'package:get/get.dart';
import 'package:task_1/models/userdata_model.dart';

class UserDataController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  // User List for the Home Page
  var userList = <UserDataModel>[].obs;
}
