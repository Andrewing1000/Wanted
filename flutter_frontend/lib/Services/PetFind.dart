import 'dart:convert';
import '../model/RequestHandler.dart';
import 'Pet_Service.dart';
import 'auth.dart';

class PetFindService {
  final RequestHandler requestHandler = RequestHandler();
  final AuthService authService = AuthService();
  final Mascotas petService = Mascotas();

  /// Obtener todos los avistamientos
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

  /// Obtener mascotas vistas enriquecidas con nombres
  Future<List<Map<String, dynamic>>> fetchEnrichedSightings() async {
    try {
      // Obtener los avistamientos
      final sightings = await fetchPetSightings();
      final enrichedSightings = <Map<String, dynamic>>[];

      for (final sighting in sightings) {
        // Buscar información de la mascota asociada
        final pet = await petService.fetchPetById(sighting['id']);

        // Validar si se encontró la mascota
        enrichedSightings.add({
          ...sighting,
          'pet_name': pet != null ? pet['pet_name'] : 'Sin nombre',
          'status': 'Visto', // Asignar estado "Visto" a los avistamientos
        });
      }

      return enrichedSightings;
    } catch (e) {
      print('Error al enriquecer avistamientos: $e');
      return [];
    }
  }

  /// Obtener todas las mascotas perdidas enriquecidas con estado
  Future<List<Map<String, dynamic>>> fetchLostPetsWithStatus() async {
    try {
      final lostPets = await petService.fetchLostPets();
      return lostPets.map((pet) {
        return {
          ...pet,
          'status': 'Perdido', // Asignar estado "Perdido" a las mascotas perdidas
        };
      }).toList();
    } catch (e) {
      print('Error al obtener mascotas perdidas enriquecidas: $e');
      return [];
    }
  }

  /// Crear un nuevo avistamiento
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
