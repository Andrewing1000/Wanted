// lib/main.dart
// lib/main.dart
import 'package:flutter/material.dart';
//import 'views/manager_screen.dart';
import 'Bienvenida.dart';
import 'model/RequestHandler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkServerConnection();
  runApp(MyApp());
}

Future<void> checkServerConnection() async {
  final requestHandler = RequestHandler();
  try {
    final response = await requestHandler.getRequest('health_check');

  } catch (e) {
    print('Error al conectar con el servidor: $e');
  }
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
      home: WelcomeScreen(),
    );
  }
}
