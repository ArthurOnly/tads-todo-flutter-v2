import 'package:flutter/material.dart';
import 'package:tads_todo_v2/src/tasks/db/local_db.dart';
import 'package:tads_todo_v2/src/tasks/presentation/tasks_list_screen.dart';
import 'package:tads_todo_v2/src/tasks/presentation/tasks_create_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/tasks': (context) => const TaskListScreen(),
        '/tasks/create': (context) => const TaskCreateScreen()
      },
      initialRoute: '/tasks',
    );
  }
}