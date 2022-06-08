import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_1/controllers/task_controller.dart';
import 'package:task_1/controllers/userdata_controller.dart';
import 'package:task_1/models/task_model.dart';
import 'package:task_1/models/userdata_model.dart';
import 'package:task_1/ui/screens/add_task_bar.dart';
import 'package:task_1/ui/screens/home_page.dart';
import 'package:task_1/ui/widgets/task_tile.dart';
import 'package:task_1/ui/widgets/input_field.dart';
import '../../utils/colors_util.dart';
import '../theme.dart';

class MyMainPage extends StatefulWidget {
  final UserDataModel singleUser;
  const MyMainPage({Key key, this.singleUser}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<MyMainPage> createState() => _MyMainPageState(singleUser);
}

class _MyMainPageState extends State<MyMainPage> {
  @override
  initState() {
    super.initState();
    // On first run , first set the top view
    // in order to refresh the calendar
    // topView();
    // Fill the user list
    fillPeopleList();
  }

  double width = 0.0;
  double height = 0.0;
  double topViewHeight = 0.0;
  // User data from login page
  UserDataModel singleUser;
  _MyMainPageState(this.singleUser);

  // Selected date to be updated in the add task bar
  DateTime selectedDate = DateTime.now();

  // Calendar Format for the full calendar view
  CalendarFormat format = CalendarFormat.month;

  // Task Controller to print info on bottom view
  final taskController = Get.put(TaskController());

  // User controller to get user data
  final userController = Get.put(UserDataController());

  // Temporary values for the update function
  // Each time the user updates the task,
  // the values will be updated
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String defaultAssignee;
  DateTime defaultDate;
  String defaultStartTime;
  String defaultEndTime;
  int defaultReminder;
  String defaultColor;

  // _people will be updated from the database
  // _people will be used to fill the dropdown menu
  final List<Map<String, dynamic>> _people = [];
  // List of integer reminders
  List<int> remindList = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55];

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
    refreshTaskController();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: appBarView(),
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
            topView(),
            const SizedBox(
              height: 10,
            ),
            bottomView(),
          ],
        ),
      ),
      floatingActionButton: actionButton(),
    );
  }

  // APP bar view
  appBarView() {
    return AppBar(
      title: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          'assets/images/Logo.webp',
          height: 50,
          width: 120,
        ),
      ),
      actions: [
        // Make a log out button
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          iconSize: 34,
          onPressed: () {
            Get.to(const MyHomePage());
          },
        ),
      ],
    );
  }

  // Top view containing:
  //  Gradient Box which will be filled by dates
  Widget topView() {
    if (format == CalendarFormat.month) {
      setState(() {
        topViewHeight = height * 0.55;
      });
    } else if (format == CalendarFormat.twoWeeks) {
      setState(() {
        topViewHeight = height * 0.29;
      });
    } else if (format == CalendarFormat.week) {
      setState(() {
        topViewHeight = height * 0.22;
      });
    }
    return Container(
      height: topViewHeight,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              HexColor("23416c").withOpacity(0.7),
              HexColor("23416c").withOpacity(0.6),
              HexColor("23416c").withOpacity(0.4)
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: const [0.0, 0.5, 1.0],
            tileMode: TileMode.clamp),
        boxShadow: const [
          BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(4, 4),
              spreadRadius: 2)
        ],
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        titleView(),
        fullCalendarView(),
      ]),
    );
  }

  Widget fullCalendarView() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Color.fromARGB(146, 255, 255, 255),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: TableCalendar(
        focusedDay: selectedDate,
        firstDay: DateTime(2000),
        lastDay: DateTime(2100),
        calendarFormat: format,
        // Create an event loader for each day

        eventLoader: (date) {
          List<DateTime> events = [];
          // print(_getEventsForDay(date).toString());

          if (_getEventsForDay(date) != null) {
            print("DATE OF EVENT " + date.toString());
            events.add(_getEventsForDay(date));
          }
          return events;
        },

        // Change the format of the date
        // 2 weeks , 1 month , 1 week
        onFormatChanged: (CalendarFormat _format) {
          setState(() {
            format = _format;
          });
        },

        // Change selected date state if selected date is changed
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: (DateTime _date, DateTime _focus) {
          setState(() {
            selectedDate = _date;
          });
        },
        selectedDayPredicate: (DateTime _date) {
          return isSameDay(selectedDate, _date);
        },

        // Header Style
        headerStyle: const HeaderStyle(
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Day style
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Color.fromARGB(226, 0, 0, 0),
            fontSize: 13,
          ),
          weekendStyle: TextStyle(
            color: Color.fromARGB(226, 0, 0, 0),
            fontSize: 13,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          singleMarkerBuilder: ((context, day, _) {
            return Container(
              width: 10.0,
              height: 10.0,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 48, 174, 224),
              ),
            );
          }),
        ),
        // Calendar Style
        calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: HexColor('#2163a1'),
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
            ),
            todayDecoration: BoxDecoration(
              color: HexColor('#2163a1').withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            defaultTextStyle: const TextStyle(
              color: Colors.black,
            ),
            weekendTextStyle: const TextStyle(
              color: Colors.black,
            ),
            disabledTextStyle: const TextStyle(
              color: Colors.black,
            ),
            outsideTextStyle: const TextStyle(
              color: Colors.black,
            )),
      ),
    );
  }

// Bottom view containing:
// Todo List
  Widget bottomView() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: taskController.taskList.length,
          itemBuilder: (_, index) {
            if (taskController.taskList[index].date ==
                DateFormat.yMd().format(selectedDate)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 300),
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            editTaskView(
                                context, taskController.taskList[index]);
                          },
                          child: TaskTile(taskController.taskList[index]),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

// Format date
  formatEventDate(String dateString) {
    final splitted = dateString.split('/');
    String date;
    if (dateString != null) {
      if (splitted[0].length == 1 && splitted[1].length == 1) {
        date = splitted[2] + '-' + '0' + splitted[0] + '-' + '0' + splitted[1];
      } else if (splitted[1].length == 1) {
        date = splitted[2] + '-' + splitted[0] + '-' + '0' + splitted[1];
      } else if (splitted[0].length == 1) {
        date = splitted[2] + '-' + '0' + splitted[0] + '-' + splitted[1];
      }
    }
    DateTime dateTime = DateTime.parse(date);

    return dateTime;
  }

  _getEventsForDay(DateTime day) {
    for (int i = 0; i < taskController.taskList.length; i++) {
      if (singleUser.usertype == 'admin'){
        return formatEventDate(taskController.taskList[i].date);
      }
      if (taskController.taskList[i].date == DateFormat.yMd().format(day)) {
        if (singleUser.id.toString() ==
            taskController.taskList[i].userID.toString()) {
          return formatEventDate(taskController.taskList[i].date);
        } else {
          return null;
        }
      }
    }
  }

  // Edit task view is a bottom sheet with editable data
  editTaskView(BuildContext context, TaskModel task) {
    refreshTaskController();
    // Refresh default values to the current task data
    refreshDefaultValues(task);

    Get.bottomSheet(StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          height: height * 0.8,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/taskedit.jpg'),
                fit: BoxFit.cover),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: bottomSheet(task, setState),
          ),
        );
      },
    ));
  }

  bottomSheet(TaskModel task, StateSetter setState) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              deleteButton(task),
            ],
          ),
          printTaskData(task, setState),
          const SizedBox(
            height: 10,
          ),
          taskCompletedButton(task),
          const SizedBox(
            height: 15,
          ),
          bottomRowButtons(task),
        ],
      ),
    );
  }

  bottomRowButtons(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(children: <Widget>[
        cancelButton(),
        const Spacer(),
        updateButton(task),
      ]),
    );
  }

  updateButton(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Center(
        child: ElevatedButton(
          child: const Text(
            "Update",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            primary: HexColor('#2386C1'),
            elevation: 0,
            shadowColor: Colors.black,
          ),
          onPressed: () {
            setState(() {
              task.title = titleController.text;
              task.description = descriptionController.text;
              task.assign = defaultAssignee;
              task.date = DateFormat.yMd().format(defaultDate);
              task.startTime = defaultStartTime;
              task.endTime = defaultEndTime;
              task.remind = defaultReminder;
              task.color = defaultColor;
              TaskController.updateTask(task);
              Get.back();
            });
          },
        ),
      ),
    );
  }

  cancelButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: Center(
        child: ElevatedButton(
          child: const Text("Cancel",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            primary: HexColor('#CB4335'),
            elevation: 0,
            shadowColor: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
    );
  }

  deleteButton(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () {
            TaskController.deleteTask(task);
            refreshTaskController();
            Get.back();
          }),
    );
  }

  taskCompletedButton(TaskModel task) {
    if (task.isCompleted == 0) {
      return GestureDetector(
        onTap: () {
          setState(() {
            task.isCompleted = 1;
          });
          TaskController.updateTask(task);
          Get.back();
        },
        child: Container(
          height: 50,
          width: 150,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: HexColor('#447fac'),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: const Center(
            child: Text(
              'Mark as Completed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            task.isCompleted = 0;
          });
          TaskController.updateTask(task);
          Get.back();
        },
        child: Container(
          height: 50,
          width: 150,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: HexColor('#03a497'),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: const Center(
            child: Text(
              'Set as in Progress',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }
  }

  // Prints out the Task data into the bottom sheet
  printTaskData(TaskModel task, StateSetter setState) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: MyInputField(
            title: 'Title',
            hint: task.title.toString(),
            whiteText: true,
            fullSize: false,
            controller: titleController,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: MyInputField(
            title: 'Description',
            hint: task.description.toString(),
            whiteText: true,
            fullSize: false,
            controller: descriptionController,
          ),
        ),
        _assingTaskView(setState),
        MyInputField(
          title: 'Date',
          hint: DateFormat.yMd().format(defaultDate),
          whiteText: true,
          fullSize: false,
          widget: IconButton(
            onPressed: () {
              // When user presses calendar icon, show date picker
              _getDateFromUser(setState);

              // Get.back();
            },
            icon: const Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
          ),
        ),
        _startAndEndTimeView(setState),
        const SizedBox(
          height: 10,
        ),
        _reminderView(setState),
        _colorView(setState),
      ],
    );
  }

  // Drop down list containing availab
  _colorView(StateSetter setState) {
    return MyInputField(
      whiteText: true,
      selectedHintColor: true,
      fullSize: false,
      hintColor: defaultColor,
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
            defaultColor = newValue;
          });
        },
      ),
    );
  }

  // Drop down list containing reminder options
  _reminderView(StateSetter setState) {
    return MyInputField(
      whiteText: true,
      fullSize: false,
      title: 'Remind',
      hint: '$defaultReminder minutes before',
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
        style: taskBasicStyle,
        items: remindList.map<DropdownMenuItem<String>>(
          (int value) {
            return DropdownMenuItem<String>(
              value: value.toString(),
              child: Text(
                value.toString(),
                style: const TextStyle(color: Colors.black),
              ),
            );
          },
        ).toList(),
        onChanged: (String newValue) {
          setState(
            () {
              defaultReminder = int.parse(newValue);
            },
          );
        },
      ),
    );
  }

  _assingTaskView(StateSetter setState) {
    return MyInputField(
      whiteText: true,
      fullSize: false,
      title: 'Assign',
      hint: 'Assign Task to ${defaultAssignee.toString()}',
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
        style: taskBasicStyle,
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
        onChanged: (dynamic newValue) {
          setState(() {
            defaultAssignee = newValue['name'].toString();
          });
        },
      ),
    );
  }

  _startAndEndTimeView(StateSetter setState) {
    return Row(
      children: [
        Expanded(
          child: MyInputField(
            whiteText: true,
            fullSize: false,
            title: 'Start Time',
            hint: defaultStartTime,
            widget: IconButton(
              onPressed: () {
                _getTimeFromUser(true, setState);
              },
              icon: const Icon(Icons.access_time, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: MyInputField(
            whiteText: true,
            fullSize: false,
            title: 'End Time',
            hint: defaultEndTime,
            widget: IconButton(
              onPressed: () {
                _getTimeFromUser(false, setState);
              },
              icon: const Icon(Icons.access_time, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  _getTimeFromUser(bool isStartTime, StateSetter setState) async {
    var pickedTime = await _showTimePicker(isStartTime);

    // Format pickedTime to 24 hour format using the extension function
    String _formatedTime = TimeOfDayConverter(pickedTime).to24hours();

    if (pickedTime == null) {
      return;
    } else if (isStartTime) {
      setState(() {
        defaultStartTime = _formatedTime;
      });
    } else {
      setState(() {
        defaultEndTime = _formatedTime;
      });
    }
  }

  _showTimePicker(bool isStartTime) {
    int displayHour;
    int displayMinute;

    if (isStartTime) {
      displayHour = DateFormat('HH:mm').parse(defaultStartTime).hour;
      displayMinute = DateFormat('HH:mm').parse(defaultStartTime).minute;
    } else {
      displayHour = DateFormat('HH:mm').parse(defaultEndTime).hour;
      displayMinute = DateFormat('HH:mm').parse(defaultEndTime).minute;
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

  _getDateFromUser(StateSetter setState) async {
    DateTime _pickerDate = await showDatePicker(
        context: context,
        initialDate: defaultDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));

    if (_pickerDate != null) {
      setState(() {
        defaultDate = _pickerDate;
      });
    }
  }

  Widget titleView() {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      child: Center(
        child: Text(
          DateFormat.yMMMMd().format(DateTime.now()),
          textAlign: TextAlign.center,
          style: headerStyle,
        ),
      ),
    );
  }

  // Floating Action button that adds to the todo list
  Widget actionButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        child: Container(
          width: 100.0,
          height: 100.0,
          child: const Icon(
            Icons.add,
            size: 35,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: [
                  HexColor("009FFD"),
                  HexColor("2A2A72"),
                  HexColor("842E09")
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: const [0.0, 0.5, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        onPressed: () async {
          await Get.to(AddTaskPage(
            previousDate: selectedDate,
            singleUser: singleUser,
          ));
          taskController.getTasks();
        },
      ),
    );
  }

  // Refreses the todo list
  void refreshTaskController() {
    taskController.getTasks();
  }

  void refreshDefaultValues(TaskModel task) {
    setState(() {
      titleController = TextEditingController(text: task.title.toString());
      descriptionController =
          TextEditingController(text: task.description.toString());
      defaultAssignee = task.assign.toString();
      defaultDate = formatEventDate(task.date);
      defaultStartTime = task.startTime;
      defaultEndTime = task.endTime;
      defaultReminder = task.remind;
      defaultColor = task.color;
    });
  }

  fillPeopleList() {
    for (var i = 0; i < userController.userList.length; i++) {
      print(userController.userList[i].toJson());
      print("""
        FILL PEOPLE LIST SINGLE USER INFO 
        TYPE OF USER ${singleUser.usertype}
      """);

      if (singleUser.usertype == userController.userList[i].usertype) {
        String nameController = (userController.userList[i].firstName +
                ' ' +
                userController.userList[i].lastName)
            .toString();
        setState(() {
          _people.add(
            {
              "id": userController.userList[i].id,
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
              "id": userController.userList[i].id,
              "name": nameController,
              "color": userController.userList[i].color,
            },
          );
        });
      }
    }
  }
}
