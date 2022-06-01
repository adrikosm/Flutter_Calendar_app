// ignore_for_file: unused_field

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:task_1/ui/theme.dart';
import 'package:task_1/ui/widgets/input_field.dart';
import 'package:task_1/utils/colors_util.dart';

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
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  // Working Hours
  String startTime = '08:00';
  String endTime = '16:00';
  // Date of birth
  final DateTime _dateOfBirth = DateTime.now();
  // Color selected by user
  String _color = '#9E9E9E';

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
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.08,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 20),
                    child: Center(
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: CircleAvatar(
                            radius: width * 0.12,
                            backgroundColor:
                                HexColor('2E86C1').withOpacity(0.4),
                            child: Icon(Icons.person,
                                size: width * 0.12, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  inputFields(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  inputFields() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          MyInputField(
            title: 'Username',
            controller: _usernameController,
            hint: 'Enter your username',
            whiteText: true,
            fullSize: false,
          ),
          MyInputField(
            title: 'Email',
            controller: _emailController,
            hint: 'Enter your email',
            whiteText: true,
            fullSize: false,
          ),
          MyInputField(
            title: 'First Name',
            controller: _firstNameController,
            hint: 'Enter your first name',
            whiteText: true,
            fullSize: false,
          ),
          MyInputField(
            title: 'Last Name',
            controller: _lastNameController,
            hint: 'Enter your last name',
            whiteText: true,
            fullSize: false,
          ),
          MyInputField(
            title: 'Password',
            controller: _passwordController,
            hint: 'Enter your password',
            whiteText: true,
            fullSize: false,
          ),
          MyInputField(
            title: 'Confirm Password',
            controller: _passwordConfirmController,
            hint: 'Confirm your password',
            whiteText: true,
            fullSize: false,
          ),
          colorView(),
        ],
      ),
    );
  }

  colorView() {
    return MyInputField(
      whiteText: true,
      selectedHintColor: true,
      fullSize: false,
      hintColor: _color,
      title: 'Color',
      hint: 'Selected Color',
      widget: DropdownButton(
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
        ),
        iconSize: 32,
        elevation: 4,
        underline: Container(
          width: 0,
        ),
        // Create Dropw down menu item
        // each field is container filled with color
        items: colorList.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 120,
                  height: 80,
                  decoration: BoxDecoration(
                    color: HexColor(value),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            );
          },
        ).toList(),
        onChanged: (String newValue) {
          setState(() {
            _color = newValue;
          });
        },
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
