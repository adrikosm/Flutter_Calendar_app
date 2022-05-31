import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        homePageBackground(),
        Scaffold(
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
        Container(
          width: width * 0.8,
          decoration: BoxDecoration(
              color: Color.fromARGB(160, 226, 222, 222).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20)),
          child: TextField(
            style: loginPageSubtitle,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: InputBorder.none,
              hintText: "Username",
              hintStyle: loginPageTitle,
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10) ,
                child:Icon(Icons.account_circle_outlined,color: Colors.white,size: 32,),
                ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: width * 0.8,
          decoration: BoxDecoration(
              color: Color.fromARGB(160, 226, 222, 222).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20)),
          child: TextField(
            style: loginPageSubtitle,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: InputBorder.none,
              hintText: "Password",
              hintStyle: loginPageTitle,
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.lock_outlined,color: Colors.white,size: 32,),
                ),
            ),
          ),
        ),




      ],
    );
  }

  // Register view redirects
  // the user to the register page
  registerView() {
    return const Text(
      "Not a member? Register Here",
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }

  // Floating action button
  Widget actionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/MainPage');
      },
      child: const Icon(Icons.add),
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
}
