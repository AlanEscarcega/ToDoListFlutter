import 'package:flutter/material.dart';
import 'package:todolist_app/screens/todo_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color.fromARGB(255, 3, 102, 44)),
      home: const TodoScreen(),
    );
  }
}
