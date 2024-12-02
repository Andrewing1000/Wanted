// lib/main.dart
// lib/main.dart
import 'package:flutter/material.dart';
//import 'views/manager_screen.dart';
import 'Bienvenida.dart';
import 'Services/Pet_Service.dart';
import 'model/RequestHandler.dart';
import 'Services/auth.dart';

void main() async {



  final reponse = RequestHandler();
  //await perro();
  WidgetsFlutterBinding.ensureInitialized();
  await checkServerConnection();
  AuthService res = AuthService();


  //await Registro();
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



Future<void> Registro() async{
  final request = RequestHandler();
  try{
    var usuario = await request.postRequest('user/create/',
        data :{
          "email": "andres@hino.com",
          "password": "andres",
          "name": "Andres Hino",
          "phone_number": "7884262",
          "is_active": true,
          "is_staff": true,}
    );
  }catch(e){
    print(e.toString());
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
