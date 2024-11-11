// lib/main.dart
import 'package:flutter/material.dart';
import 'views/manager_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find You\'re Pet, go!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ManagerScreen(),
    );
  }
}
