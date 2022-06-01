import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_1/controllers/task_controller.dart';
import 'package:task_1/models/task_model.dart';
import 'package:task_1/ui/widgets/button.dart';
import 'package:task_1/ui/widgets/input_field.dart';
import '../theme.dart';

class AddTaskPage extends StatefulWidget {
  final DateTime previousDate;

  const AddTaskPage({Key key, this.previousDate}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _AddTaskPageState createState() => _AddTaskPageState(previousDate);
}

class _AddTaskPageState extends State<AddTaskPage> {
  // Get Date from home page
  DateTime previousDate;
  _AddTaskPageState(this.previousDate);

  DateTime selectedDate;

  String startTime = DateFormat('HH:mm').format(DateTime.now()).toString();
  // Make end Time at least one hour after start time
  String endTime = DateFormat('HH:mm')
      .format(DateTime.now().add(const Duration(hours: 1)))
      .toString();

  // Set a reminder time at five minutes before end time
  int selectedReminder = 5;
  List<int> remindList = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55];

  // Create a list for the dropdown menu for task assignees
  // Later on, this list will be populated with the names of the users
  String defaultAssignee = 'None';
  List<String> assigneeList = ['John', 'Jane', 'Jack', 'Jill', 'No one'];

  // Dynamic String with all necessary user Data
  final List<Map<String, dynamic>> _people = [
    {"id": "c1", "name": 'John', "color": '#00bcd4'},
    {"id": "c2", "name": "Jane", "color": '#ff9800'},
    {"id": "c3", "name": "Jack", "color": '#9c27b0'},
    {"id": "c4", "name": "Jill", "color": '#ff5722'},
    {"id": "c5", "name": "No one", "color": '#707b7C'},
  ];

  // Default color selection
  int selectedColorIndex = 0;
  String defaultColor;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Initialize the controller

  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    setSelectedDate();
    return Scaffold(
      appBar: _appBarView(context),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/taskbg.jpg'),
                  fit: BoxFit.cover),
            ),
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 0),
                    child: Text(
                      'Add Task',
                      style: taskHeader,
                    ),
                  ),
                  MyInputField(
                    title: 'Title',
                    hint: 'Give title',
                    controller: titleController,
                  ),
                  MyInputField(
                    title: 'Description',
                    hint: 'Give description',
                    controller: descriptionController,
                  ),

                  // Create a dropdown menu for task assignees
                  _assingTaskView(),
                  // Put previously selected data
                  MyInputField(
                    title: 'Date',
                    hint: DateFormat.yMd().format(previousDate),
                    widget: IconButton(
                      onPressed: () {
                        // When user presses calendar icon, show date picker
                        _getDateFromUser();
                      },
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // Create a row with start time and end time fields
                  _startAndEndTimeView(),

                  // Get total Hours between start and end time
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Opacity(
                      opacity: 0.6,
                      child: Text(
                        'Total Duration of Task \n    ' + _getTotalHours(),
                        style: taskSubtitle,
                      ),
                    ),
                  ),
                  // Create a dropdown menu for Reminder
                  _reminderView(),
                  // Add task button, validates the data then sends it to db
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _colorView(),
                        MyButton(
                          label: "+ Add Task",
                          onTap: () => _validateData(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _appBarView(BuildContext context) {
    return AppBar(
      title: Container(
        margin: const EdgeInsets.only(top: 10, left: 15, bottom: 5),
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          'assets/images/Logo.webp',
          height: 50,
          width: 120,
        ),
      ),
    );
  }

  // _colorView() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Color of Task',
  //         style: taskHeader,
  //       ),
  //       const SizedBox(height: 10),
  //       Wrap(
  //         children: List<Widget>.generate(3, (int index) {
  //           return GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 selectedColorIndex = index;
  //               });
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.only(right: 8.0),
  //               child: CircleAvatar(
  //                 radius: 14,
  //                 backgroundColor: index == 0
  //                     ? HexColor(
  //                         _findAssigneeColor(defaultAssignee),
  //                       )
  //                     : index == 1
  //                         ? HexColor('#2E86C1')
  //                         : HexColor('#239B56'),
  //                 child: selectedColorIndex == index
  //                     ? const Icon(Icons.done, color: Colors.white, size: 16)
  //                     : Container(),
  //               ),
  //             ),
  //           );
  //         }),
  //       ),
  //     ],
  //   );
  // }

  _colorView() {
    _findAssigneeColor(defaultAssignee);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: MyInputField(
        selectedHintColor: true,
        hintColor: defaultColor,
        title: 'Task Color',
        hint: 'Color',
        widget: IconButton(
          onPressed: () {
            _findAssigneeColor(defaultAssignee);
          },
          icon: const Icon(Icons.palette_outlined, color: Colors.grey),
        ),
      ),
    );
  }

  _assingTaskView() {
    return MyInputField(
      title: 'Assign',
      hint: 'Assign Task to $defaultAssignee',
      widget: DropdownButton(
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.grey,
        ),
        iconSize: 32,
        elevation: 4,
        underline: Container(
          width: 0,
        ),
        style: taskBasicStyle,
        // Traverse dynamic people list and
        // print out the name of the person
        items: assigneeList.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value.toString(),
              child: Text(
                value.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            );
          },
        ).toList(),
        onChanged: (String newValue) {
          setState(() {
            defaultAssignee = newValue.toString();
          });
        },
      ),
    );
  }

  _startAndEndTimeView() {
    return Row(
      children: [
        Expanded(
          child: MyInputField(
            title: 'Start Time',
            hint: startTime,
            widget: IconButton(
              onPressed: () {
                _getTimeFromUser(true);
              },
              icon: const Icon(Icons.access_time, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: MyInputField(
            title: 'End Time',
            hint: endTime,
            widget: IconButton(
              onPressed: () {
                _getTimeFromUser(false);
              },
              icon: const Icon(Icons.access_time, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  _reminderView() {
    return MyInputField(
      title: 'Remind',
      hint: '$selectedReminder minutes before',
      widget: DropdownButton(
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.grey,
        ),
        iconSize: 32,
        elevation: 4,
        underline: Container(
          width: 0,
        ),
        style: taskBasicStyle,
        items: remindList.map<DropdownMenuItem<String>>(
          (int value) {
            return DropdownMenuItem<String>(
              value: value.toString(),
              child: Text(
                value.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            );
          },
        ).toList(),
        onChanged: (String newValue) {
          setState(
            () {
              selectedReminder = int.parse(newValue);
            },
          );
        },
      ),
    );
  }

  _getDateFromUser() async {
    DateTime _pickerDate = await showDatePicker(
        context: context,
        initialDate: previousDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));

    if (_pickerDate != null) {
      setState(() {
        selectedDate = _pickerDate;
        previousDate = _pickerDate;
      });
    } else {
      selectedDate = previousDate;
    }
  }

  _getTimeFromUser(bool isStartTime) async {
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

  _getTotalHours() {
    DateTime sTime = DateFormat("HH:mm").parse(startTime);
    DateTime ttime = DateFormat("HH:mm").parse(endTime);
    Duration difference = ttime.difference(sTime);
    final thours = difference.inHours;
    final tminutes = difference.inMinutes % 60;
    return ('$thours hours $tminutes minutes');
  }

  _findAssigneeColor(String assignee) {
    final index1 = _people.indexWhere((element) => element["name"] == assignee);
    if (index1 != -1) {
      setState(() {
        defaultColor = _people[index1]["color"];
      });
    } else {
      setState(() {
        defaultColor = '#707b7C';
      });
    }
  }

  // Checks whether the title and the description of the task
  // are not empty
  // Then sends the data to the database
  _validateData() {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      _addTaskToDB();
      // DBHelper.deleteAll();
      Get.back();
    } else if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all the fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(122, 255, 255, 255),
        colorText: const Color.fromARGB(255, 175, 28, 18),
        icon: const Icon(Icons.warning_amber_rounded),
      );
    }
  }

  // After data validation, this function is called
  _addTaskToDB() async {
    await _taskController.addTask(
      task: TaskModel(
        title: titleController.text.toString(),
        description: descriptionController.text.toString(),
        assign: defaultAssignee,
        isCompleted: 0,
        date: DateFormat.yMd().format(selectedDate),
        startTime: startTime,
        endTime: endTime,
        remind: selectedReminder,
        color: defaultColor,
      ),
    );
  }

  setSelectedDate() {
    setState(() {
      selectedDate = previousDate;
    });
  }
}

// Extension function to convert TimeOfDay to 24 hour format without shitespaces
// Based on https://www.technicalfeeder.com/2022/02/flutter-convert-timeofday-to-24-hours-format/
extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    // ignore: unnecessary_this
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}
