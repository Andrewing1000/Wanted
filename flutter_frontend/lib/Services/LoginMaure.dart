import '../model/RequestHandler.dart';

class login{
  RequestHandler respuesta = RequestHandler();

  String InicioSesion(String correo, String password){
    try{
      respuesta.postRequest('user/token',data: {
        'email':correo,
        'password':password,
  });

      return 'Si';

  }catch(e){
  return e.toString();

  }
//home page
//peth cart
}
}