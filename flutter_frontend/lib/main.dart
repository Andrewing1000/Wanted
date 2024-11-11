import 'package:flutter/material.dart';
import 'views/home_page.dart';

void main() {
  runApp(FindYourPetApp());
}

class FindYourPetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find You\'re Pet, go!',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      home: HomePage(),
    );
  }
}
