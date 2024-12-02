
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/RequestHandler.dart';

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
        await prefs.setString('email', login['email']);
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
      }

      await prefs.clear(); // Limpiar los datos
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  /// Obtener el nombre del usuario almacenado
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }


  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  /// Obtener el token almacenado
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }



  //// NO TOCAR
  Future<String> Connection() async {
    var con = RequestHandler();

    try {
      final response = con.getRequest('health_check');
      print('Respuesta obtenida: $response');

      final errorJson = jsonDecode(response as String)['status'];
      print('Estado decodificado: $errorJson');

      if (errorJson == 'Error al conectar con el servidor') {
        print('Error: No se pudo conectar al servidor.');
        return 'Error al conectar con el servidor';
      }

      print('Conexión exitosa.');
      return 'Conexión exitosa';
    } catch (e) {
      print('Excepción capturada: $e');
      return 'Error al procesar la solicitud';
    }
  }





}