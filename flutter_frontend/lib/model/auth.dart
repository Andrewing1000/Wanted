
import '../Services/RequestHandler.dart';

Future<bool> LoginStart(String correo, String contrasenia) async {
  final requestHandler = RequestHandler();
  try {
    final login = await requestHandler.postRequest('user/token/', data: {
      'email': correo,
      'password': contrasenia,
    });
    if (login != null && login['token'] != null) {
      print('Token: ${login['token']}');
      return true;
    } else {
      print('Error: Credenciales incorrectas');
      return false;
    }
  } catch (e) {
    print('Error en el inicio de sesión: $e');
    return false;
  }
}

Future<bool> registerCreate(String correo,String contrasenia,String nombre, String telefono) async {
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
    return true;
  }catch(e){
    print('error');
    return false;
  }
}