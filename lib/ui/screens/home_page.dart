import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  // Get user and password controller
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        homePageBackground(),
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
                // Column(
                //   children: [
                //     loginView(),
                //     const SizedBox(
                //       height: 50,
                //     ),
                //     registerView(),
                //   ],
                // ),
              ],
            ),
          ),
        )
      ],
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
      Get.toNamed('/MainPage');
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
}
