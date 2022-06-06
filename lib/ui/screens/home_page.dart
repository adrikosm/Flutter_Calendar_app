import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_1/controllers/userdata_controller.dart';
import 'package:task_1/ui/screens/main_page.dart';
import 'package:task_1/ui/theme.dart';
import 'package:task_1/utils/colors_util.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double width = 0.0;
  double height = 0.0;
  // Task Controller to print info on bottom view
  final userController = Get.put(UserDataController());

  // Get user and password controller
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loggedIn = false;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    refresUserControllerData();
    return checkController();
  }

  checkController() {
    if (loggedIn == false) {
      return normalView();
    } else {
      return loggedInView();
    }
  }

  loggedInView() {
    refresUserControllerData();
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: HexColor("#2080ca"),
          image: DecorationImage(
            image: const AssetImage('assets/images/bgview.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.lighten),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Center(
                child: Column(children: [
                  userController.singleUser.first.usertype == 'user'
                      ? dataTableUser()
                      : dataTableAdmin(),
                ]),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            bottomButtons()
          ],
        ),
      ),
    );
  }

  DataTable dataTableUser() {
    return DataTable(
      columns: [
        DataColumn(
          label: Text('First Name', style: dataTableTitle),
        ),
        DataColumn(
          label: Text('Last Name', style: dataTableTitle),
        ),
        DataColumn(
          label: Text('email', style: dataTableTitle),
        ),
        DataColumn(
          label: Text(
            'Shift Start',
            style: dataTableTitle,
          ),
        ),
        DataColumn(
          label: Text(
            'Shift End',
            style: dataTableTitle,
          ),
        ),
      ],
      rows: [
        DataRow(
          cells: [
            dataCell(userController.singleUser.first.firstName.toString()),
            dataCell(userController.singleUser.first.lastName.toString()),
            dataCell(userController.singleUser.first.email.toString()),
            dataCell(userController.singleUser.first.startTime.toString()),
            dataCell(userController.singleUser.first.endTime.toString()),
          ],
        ),
      ],
    );
  }

  DataTable dataTableAdmin() {
    return DataTable(
      columns: [
        DataColumn(
          label: Text('id', style: dataTableTitle),
        ),
        DataColumn(
          label: Text('First Name', style: dataTableTitle),
        ),
        DataColumn(
          label: Text('Last Name', style: dataTableTitle),
        ),
        DataColumn(
          label: Text('email', style: dataTableTitle),
        ),
        DataColumn(
          label: Text('Color', style: dataTableTitle),
        ),
        DataColumn(
          label: Text('Shift Start', style: dataTableTitle),
        ),
        DataColumn(
          label: Text('Shift End', style: dataTableTitle),
        ),
        DataColumn(
          label: Text('User Type', style: dataTableTitle),
        ),
      ],
      rows: [
        DataRow(
          cells: [
            dataCell(userController.singleUser.first.id.toString()),
            dataCell(userController.singleUser.first.firstName.toString()),
            dataCell(userController.singleUser.first.lastName.toString()),
            dataCell(userController.singleUser.first.email.toString()),
            dataCell(userController.singleUser.first.color.toString()),
            dataCell(userController.singleUser.first.startTime.toString()),
            dataCell(userController.singleUser.first.endTime.toString()),
            dataCell(userController.singleUser.first.usertype.toString()),
          ],
        ),
      ],
    );
  }

  dataCell(String info) {
    return DataCell(
      Text(
        info,
        style: dataTableDescription,
      ),
    );
  }

  Row bottomButtons() {
    return Row(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          child: logoutButton(),
        ),
        const Spacer(),
        Container(
          alignment: Alignment.bottomRight,
          child: gotoMainPage(),
        ),
      ],
    );
  }

  gotoMainPage() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(top: height * 0.05),
      child: ElevatedButton(
        onPressed: () {
          Get.to(const MyMainPage());
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width * 0.3, 50),
          primary: HexColor('#2E86C1'),
          textStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            // fontWeight: FontWeight.bold,
          ),
        ),
        child: const Text(
          'Go to Main Page',
        ),
      ),
    );
  }

  Stack normalView() {
    return Stack(
      children: [
        homePageBackground(),
        checkUserController(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(),
                  height: height * 0.3,
                  child: const Center(
                    child: Text(
                      'Calendar App',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      loginView(),
                      const SizedBox(
                        height: 20,
                      ),
                      registerView(),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  logoutButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(top: height * 0.05),
      child: ElevatedButton(
        onPressed: () {
          logoutUser();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width * 0.3, 50),
          primary: HexColor('#2E86C1'),
          textStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            // fontWeight: FontWeight.bold,
          ),
        ),
        child: const Text(
          'Logout',
        ),
      ),
    );
  }

  // login view containing
  // username and password
  loginView() {
    return Column(
      children: [
        usernameField(),
        const SizedBox(
          height: 20,
        ),
        passwordField(),
        const SizedBox(
          height: 20,
        ),
        loginButton(),
      ],
    );
  }

  loginButton() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width * 0.5, 55),
          primary: HexColor('2E86C1'),
          textStyle: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            // fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          validateData();
        },
        child: const Text(
          'Login',
        ),
      ),
    );
  }

  passwordField() {
    return Container(
      width: width * 0.8,
      decoration: BoxDecoration(
          color: const Color.fromARGB(160, 226, 222, 222).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20)),
      child: TextField(
        controller: passwordController,
        style: loginPageSubtitle,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: InputBorder.none,
          hintText: "Password",
          hintStyle: loginPageTitle,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.lock_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        obscureText: true,
      ),
    );
  }

  usernameField() {
    return Container(
      width: width * 0.8,
      decoration: BoxDecoration(
          color: const Color.fromARGB(160, 226, 222, 222).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20)),
      child: TextField(
        controller: usernameController,
        style: loginPageSubtitle,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: InputBorder.none,
          hintText: "Email",
          hintStyle: loginPageTitle,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.email_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  // Register view redirects
  // the user to the register page
  registerView() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5.0),
      width: width * 0.6,
      child: Column(
        children: [
          Text(
            'Don\'t have an account?',
            style: loginPageSubtitle,
          ),
          GestureDetector(
              onTap: () => Get.toNamed('/RegisterPage'),
              child: Container(
                child: Text(
                  'Register Here',
                  style: loginPageSubtitle,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }

// Background image and shader
  homePageBackground() {
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        colors: [Colors.black, Colors.black12],
        begin: Alignment.topCenter,
        end: Alignment.center,
      ).createShader(rect),
      blendMode: BlendMode.darken,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/bgview.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.darken),
          ),
        ),
      ),
    );
  }

  validateData() {
    // IF user has entered the username and password
    // chech the database for the user

    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      // Check the database for the user
      // If the user is found
      // then redirect to the home page
      // else show an error message

      if (checkUserController() == false) {
        Get.snackbar(
          'Error',
          'Invalid UserName or Password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(122, 255, 255, 255),
          colorText: const Color.fromARGB(255, 175, 28, 18),
          icon: const Icon(Icons.warning_amber_rounded),
        );
      } else {
        setState(() {
          loggedIn = true;
        });
        setState(() {});
        // Get.to(const MyMainPage());
      }
    }

    if (usernameController.text.isEmpty && passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all the fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(122, 255, 255, 255),
        colorText: const Color.fromARGB(255, 175, 28, 18),
        icon: const Icon(Icons.warning_amber_rounded),
      );
    } else if (usernameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please input your username',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(122, 255, 255, 255),
        colorText: const Color.fromARGB(255, 175, 28, 18),
        icon: const Icon(Icons.warning_amber_rounded),
      );
    } else if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please input your password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(122, 255, 255, 255),
        colorText: const Color.fromARGB(255, 175, 28, 18),
        icon: const Icon(Icons.warning_amber_rounded),
      );
    }
  }

  checkUserController() async {
    // ignore: await_only_futures
    await userController.getUser(
        usernameController.text, passwordController.text);
    refresUserControllerData();
    if (userController.singleUser.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  refresUserControllerData() {
    userController.getAllUserData();
  }

  logoutUser() {
    userController.emptySingleUser();
    setState(() {
      loggedIn = false;
    });
  }
}
