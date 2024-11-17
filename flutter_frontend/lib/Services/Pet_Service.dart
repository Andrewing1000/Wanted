import '../model/RequestHandler.dart';
import 'auth.dart';
class Mascotas{
  final RequestHandler requestHandler = RequestHandler();
  final AuthService Auth = AuthService();
  Future<List<Map<String, dynamic>>> fetchLostPets() async {

    try {
      final token = await Auth.getToken();
      final response = await requestHandler.getRequest('post/lost-pets/',
          headers: {'Authorization':'Token $token'});
      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Formato de respuesta no válido');
      }
    } catch (e) {
      return [];
    }
  }
  
}