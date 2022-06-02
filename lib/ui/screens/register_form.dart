import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  // Working Hours
  String startTime = '08:00';
  String endTime = '16:00';

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
            title: 'Email',
            controller: _emailController,
            hint: 'Enter your email',
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
          startAndEndTimeView(),
          const SizedBox(
            height: 20,
          ),
          bottomButtons(),
        ],
      ),
    );
  }

  // Cancel and Create account buttons
  bottomButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(width * 0.3, 50),
                primary: HexColor('#CB4335'),
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text(
                'Cancel',
              ),
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                validateData();
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
                'Create',
              ),
            ),
          ),
        ),
      ],
    );
  }

  validateData() {}

  // TIME VIEW
  startAndEndTimeView() {
    return Row(
      children: [
        Expanded(
          child: MyInputField(
            title: 'Start Time',
            hint: startTime,
            whiteText: true,
            fullSize: false,
            widget: IconButton(
              onPressed: () {
                getTimeFromUser(true);
              },
              icon: const Icon(Icons.access_time, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: MyInputField(
            title: 'End Time',
            whiteText: true,
            fullSize: false,
            hint: endTime,
            widget: IconButton(
              onPressed: () {
                getTimeFromUser(false);
              },
              icon: const Icon(Icons.access_time, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  getTimeFromUser(bool isStartTime) async {
    var pickedTime = await _showTimePicker(isStartTime);

    // Format pickedTime to 24 hour format using the extension function
    String _formatedTime = TimeOfDayConverter(pickedTime).to24hours();

    if (pickedTime == null) {
      return;
    } else if (isStartTime) {
      setState(() {
        startTime = _formatedTime;
      });
    } else {
      setState(() {
        endTime = _formatedTime;
      });
    }
  }

  _showTimePicker(bool isStartTime) {
    int displayHour;
    int displayMinute;

    if (isStartTime) {
      displayHour = DateFormat('HH:mm').parse(startTime).hour;
      displayMinute = DateFormat('HH:mm').parse(startTime).minute;
    } else {
      displayHour = DateFormat('HH:mm').parse(endTime).hour;
      displayMinute = DateFormat('HH:mm').parse(endTime).minute;
    }

    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: displayHour,
          minute: displayMinute,
        ),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget);
        });
  }

  // Color view containing list of hexcolors
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

// Extension to convert TimeOfDay to 24 hour format
extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    // ignore: unnecessary_this
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}
