import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_1/controllers/task_controller.dart';
import 'package:task_1/controllers/userdata_controller.dart';
import 'package:task_1/models/task_model.dart';
import 'package:task_1/models/userdata_model.dart';
import 'package:task_1/ui/widgets/button.dart';
import 'package:task_1/ui/widgets/input_field.dart';
import '../theme.dart';

class AddTaskPage extends StatefulWidget {
  final DateTime previousDate;
  final UserDataModel singleUser;

  const AddTaskPage({Key key, this.previousDate, this.singleUser})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskPageState createState() =>
      // ignore: no_logic_in_create_state
      _AddTaskPageState(previousDate, singleUser);
}

class _AddTaskPageState extends State<AddTaskPage> {
  // On initialize fill the lists
  @override
  initState() {
    super.initState();
    // On first run , first set the top view
    // in order to refresh the calendar
    fillPeopleList();
  }

  // Get date and user from previous page
  DateTime previousDate;
  UserDataModel singleUser;
  _AddTaskPageState(this.previousDate, this.singleUser);

  // Get all user data
  var userController = Get.put(UserDataController());

  // Date and hours for the task
  DateTime selectedDate;
  String startTime = DateFormat('HH:mm').format(DateTime.now()).toString();
  // Make end Time at least one hour after start time
  String endTime = DateFormat('HH:mm')
      .format(DateTime.now().add(const Duration(hours: 1)))
      .toString();

  // Reminder List contains all the reminder options
  int selectedReminder = 5;
  List<int> remindList = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55];

  // Set default assignee
  String defaultAssignee = 'None';

  // Set default id
  String defaultId;

  // Dynamic list containing all neccesary user data
  // It is populated with the user data from the database
  final List<Map<String, dynamic>> _people = [];

  // Default color selection
  int selectedColorIndex = 0;
  String defaultColor;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Initialize the controller

  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    refreshUserController();
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
                        _getTotalHours() + 'Total Duration of Task \n    ',
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

  _colorView() {
    _findAssigneeColor(defaultId);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: MyInputField(
        selectedHintColor: true,
        hintColor: defaultColor,
        title: 'Task Color',
        hint: 'Color',
        widget: IconButton(
          onPressed: () {
            _findAssigneeColor(defaultId);
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
        items: _people
            .map<DropdownMenuItem<dynamic>>(
                (person) => DropdownMenuItem<dynamic>(
                      value: person,
                      child: Text(
                        person['name'].toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ))
            .toList(),
        onChanged: (dynamic value) {
          setState(() {
            defaultAssignee = value['name'].toString();
            defaultId = value['id'];
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
    DateTime pickerDate = await showDatePicker(
        context: context,
        initialDate: previousDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));

    if (pickerDate != null) {
      setState(() {
        selectedDate = pickerDate;
        previousDate = pickerDate;
      });
    } else {
      selectedDate = previousDate;
    }
  }

  _getTimeFromUser(bool isStartTime) async {
    var pickedTime = await _showTimePicker(isStartTime);

    // Format pickedTime to 24 hour format using the extension function
    String formatedTime = TimeOfDayConverter(pickedTime).to24hours();

    if (pickedTime == null) {
      return;
    } else if (isStartTime) {
      setState(() {
        startTime = formatedTime;
      });
    } else {
      setState(() {
        endTime = formatedTime;
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

  _findAssigneeColor(String userid) {
    final index1 = _people.indexWhere((element) => element["id"] == userid);
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
      // DBHelper.cleanDatabase();
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
  _addTaskToDB() {
    TaskModel task = TaskModel(
      title: titleController.text.toString(),
      userID: defaultId,
      description: descriptionController.text.toString(),
      assign: defaultAssignee,
      isCompleted: 0,
      date: DateFormat.yMd().format(selectedDate),
      startTime: startTime,
      endTime: endTime,
      remind: selectedReminder,
      color: defaultColor,
    );
    task.setID(_taskController.addTask(task: task));
  }

  setSelectedDate() {
    setState(() {
      selectedDate = previousDate;
    });
  }

  void refreshUserController() {
    userController.getAllUserData();
  }

  // Fill the _people dynamic list with all the users
  // from the userController
  // If the current user is an admin he can assign tasks
  // to other admins and users
  // Users can only see other users
  fillPeopleList() {
    for (var i = 0; i < userController.userList.length; i++) {
      if (singleUser.usertype == userController.userList[i].usertype) {
        String nameController = (userController.userList[i].firstName +
                ' ' +
                userController.userList[i].lastName)
            .toString();
        setState(() {
          _people.add(
            {
              "id": userController.userListID[i],
              "name": nameController,
              "color": userController.userList[i].color,
            },
          );
        });
      } else if (singleUser.usertype == 'admin') {
        String nameController = (userController.userList[i].firstName +
                ' ' +
                userController.userList[i].lastName)
            .toString();
        setState(() {
          _people.add(
            {
              "id": userController.userListID[i],
              "name": nameController,
              "color": userController.userList[i].color,
            },
          );
        });
      }
    }
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
