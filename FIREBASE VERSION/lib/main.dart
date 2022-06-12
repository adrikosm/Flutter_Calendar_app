import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_1/ui/screens/add_task_bar.dart';
import 'package:task_1/ui/screens/home_page.dart';
import 'package:task_1/ui/screens/register_form.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'ui/screens/main_page.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      home: const MyHomePage(title: 'Task 1'),
      initialRoute: '/',
      routes: {
        '/AddTaskPage': (context) => AddTaskPage(
              previousDate: DateTime.now(),
            ),
        '/MainPage': (context) => const MyMainPage(),
        '/RegisterPage': (context) => const CreateNewAccount(),
      },
    );
  }
}
