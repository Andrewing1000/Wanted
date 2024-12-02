import 'dart:convert';
import '../model/RequestHandler.dart';
import 'auth.dart';

class PetFindService {
  final RequestHandler requestHandler = RequestHandler();
  final AuthService authService = AuthService();

  /// Obtener todos los avistamientos de mascotas
  Future<List<Map<String, dynamic>>> fetchPetSightings() async {
    try {
      final token = await authService.getToken();
      final response = await requestHandler.getRequest(
        'post/pet-sightings/',
        headers: {'Authorization': 'Token $token'},
      );

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Formato de respuesta no válido para avistamientos.');
      }
    } catch (e) {
      print('Error al obtener avistamientos: $e');
      return [];
    }
  }

  /// Registrar un nuevo avistamiento de mascota
  Future<String> createPetSighting({
    required int species,
    required int breed,
    required String color,
    required String description,
    required String dateSighted,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final token = await authService.getToken();

      // Realiza la solicitud POST
      final response = await requestHandler.postRequest(
        'post/pet-sightings/',
        data: {
          "species": species,
          "breed": breed,
          "color": color,
          "description": description,
          "date_sighted": dateSighted,
          "latitude": latitude,
          "longitude": longitude,
        },
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response != null && response['id'] != null) {
        return 'Avistamiento registrado exitosamente';
      } else {
        throw Exception('Error al registrar el avistamiento. Formato no válido.');
      }
    } catch (e) {
      print('Error al registrar avistamiento: $e');
      return 'Error al registrar avistamiento: ${e.toString()}';
    }
  }
}
