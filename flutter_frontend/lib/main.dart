// lib/main.dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'views/manager_screen.dart';
import 'Services/RequestHandler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkServerConnection();
  runApp(MyApp());
}

// Método para comprobar la conexión al servidor
Future<void> checkServerConnection() async {
  final requestHandler = RequestHandler();
  try {
    final response = await requestHandler.getRequest('health_check');
    print('Conexión al servidor exitosa: $response');
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
      home: ManagerScreen(),
    );
  }
}
