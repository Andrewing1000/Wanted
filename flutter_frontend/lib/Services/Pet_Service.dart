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

  Future<String> registerPet({
    required String petName,
    required String species,
    required String breed,
    required String color,
    required String description,
    required String photo,
    required String dateLost,
    required String lastSeenLocation,
    required String rewardAmount,
  }) async {
    try {
      final token = await Auth.getToken();
      final response = await requestHandler.postRequest(
        'post/lost-pets/',
        data: {
          "pet_name": petName,
          "species": species,
          "breed": breed,
          "color": color,
          "description": description,
          "photo": photo,
          "date_lost": dateLost, 
          "last_seen_location": lastSeenLocation,
          "reward_amount": rewardAmount,
        },
        headers: {'Authorization': 'Token $token'},
      );

      // Verificar respuesta
      if (response != null && response['id'] != null) {
        return 'Mascota registrada exitosamente';
      } else {
        throw Exception('Error al registrar la mascota. Formato no válido.');
      }
    } catch (e) {
      if (e.toString().contains('400')) {
        try {
          final errorData = e.toString().split('- ')[1];
          return 'Error: ${errorData.trim()}';
        } catch (_) {
          return 'Ocurrió un error inesperado. ${e.toString()}';
        }
      }
      return 'Ocurrió un error inesperado. ${e.toString()}';
    }
  }
}