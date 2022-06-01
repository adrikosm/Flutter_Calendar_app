// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class CreateNewAccount extends StatefulWidget {
  const CreateNewAccount({Key key}) : super(key: key);

  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  // Get screen sizes
  double width = 0.0;
  double height = 0.0;

  // Controllers for the text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  // Working Hours
  String startTime = '08:00';
  String endTime = '16:00';
  // Date of birth
  final DateTime _dateOfBirth = DateTime.now();
  // Color selected by user
  Color _color;

  // List of HexColors
  List<String> colorList = [
    '#F44336',
    '#E91E63',
    '#9C27B0',
    '#673AB7',
    '#3F51B5',
    '#2196F3',
    '#03A9F4',
    '#00BCD4',
    '#009688',
    '#4CAF50',
    '#8BC34A',
    '#CDDC39',
    '#FFEB3B',
    '#FFC107',
    '#FF9800',
    '#FF5722',
    '#795548',
    '#9E9E9E',
    '#607D8B'
  ];

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          homePageBackground(),
          Container(
            alignment: Alignment.center,
            width: width * 0.8,
            height: height * 0.1,
            child: const Text(
              "REGISTER PAGE IN PROGRESS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          )
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
}
