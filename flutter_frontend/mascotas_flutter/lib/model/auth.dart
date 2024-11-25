
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/RequestHandler.dart';

class AuthService{
  Future<bool> Login(String correo, String contrasenia) async {
    final requestHandler = RequestHandler();
    try {
      final login = await requestHandler.postRequest('user/token/', data: {
        'email': correo,
        'password': contrasenia,
      });
      if (login != null && login['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', login['token']);
        await prefs.setString('userName', login['name']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

Future<String> registerCreate(String correo,String contrasenia,String nombre, String telefono) async {
  final resquesthandler = RequestHandler();
  try{
    final register = await resquesthandler.postRequest('user/create/',
        data:{
          "email": correo,
          "password": contrasenia,
          "name": nombre,
          "phone_number": telefono,
          "is_active": true,
          "is_staff": false,
        });
    return 'Registro';
  }catch(e){
    if (e.toString().contains('400')) {
      try {
        final errorJson = jsonDecode(e.toString().split('-')[1]);
        if (errorJson.containsKey('email')) {
          return errorJson['email'][0];
        }
        return errorJson;
      } catch (_) {
        return 'Ocurrio un error inesperado. ${e.toString()}';
      }
    }
    return 'Ocurrio un error inesperado. ${e.toString()}.';
  }
}


  Future<void> logout() async {
    final requestHandler = RequestHandler();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        await requestHandler.postRequest(
          'user/logout/',
          headers: {'Authorization': 'Token $token'},
        );
        await prefs.clear(); 
      }
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }




}