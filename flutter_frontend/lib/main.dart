// lib/main.dart
// lib/main.dart
import 'package:flutter/material.dart';
//import 'views/manager_screen.dart';
import 'Bienvenida.dart';
import 'model/RequestHandler.dart';
import 'Services/auth.dart';

void main() async {
  final reponse = RequestHandler();
  //await perro();
  WidgetsFlutterBinding.ensureInitialized();
  await checkServerConnection();
  //await Registro();
  runApp(MyApp());
}

//Future<void> perro() async{
//  final reponse = RequestHandler();
//  final servidor = AuthService();
//  servidor.Login('andres@hino.com', 'andres');
//  final token = await servidor.getToken();

//  var perro = reponse.postRequest('post/lost-pets/',
//    data: {
//      "pet_name": "tita",
//      "species": "albino",
//      "breed": "pequines",
//      "color": "blanco",
//     "description": "enano bonito",

//      "photo": null,
//      "date_lost": "2024-11-25",
//      "last_seen_location": "12,12",
//      "reward_amount": "400",
//    },
//    headers: {'Authorization': 'Token $token'},
//  );

//}

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
          "email": "mauricio@guti.com",
          "password": "123",
          "name": "mauricio",
          "phone_number": "606060606",
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
