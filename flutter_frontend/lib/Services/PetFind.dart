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
      final sightings = await fetchPetSightings();
      final lostPets = await petService.fetchLostPets();
      final enrichedSightings = <Map<String, dynamic>>[];

      for (final sighting in sightings) {
        // Buscar coincidencia entre descripción y usuario
        final matchingPet = lostPets.firstWhere(
              (pet) =>
          pet['description'] == sighting['description'] &&
              pet['user'] == sighting['user'] &&
              pet['species'] == sighting['species'] &&
              pet['breed'] == sighting['breed'], // Agregar más filtros si es necesario
          orElse: () => {'pet_name': 'Sin nombre'}, // Valor predeterminado
        );

        // Agregar información adicional
        enrichedSightings.add({
          ...sighting,
          'pet_name': matchingPet['pet_name'] ?? 'Sin nombre',
          'status': 'Visto',
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
      final sightings = await fetchPetSightings();

      // Excluir mascotas con avistamientos coincidentes
      final matchedDescriptions = sightings.map((sighting) => sighting['description']).toSet();
      final matchedUsers = sightings.map((sighting) => sighting['user']).toSet();

      return lostPets.map((pet) {
        final isSeen = matchedDescriptions.contains(pet['description']) &&
            matchedUsers.contains(pet['user']);

        return {
          ...pet,
          'status': isSeen ? 'Visto' : 'Perdido',
        };
      }).toList();
    } catch (e) {
      print('Error al obtener mascotas perdidas enriquecidas: $e');
      return [];
    }
  }

  /// Obtener historial de avistamientos para una mascota perdida
  Future<List<Map<String, dynamic>>> fetchSightingsForLostPet(Map<String, dynamic> pet) async {
    try {
      final sightings = await fetchPetSightings();
      return sightings.where((sighting) {
        return sighting['description'] == pet['description'] &&
            sighting['user'] == pet['user'] &&
            sighting['species'] == pet['species'] &&
            sighting['breed'] == pet['breed']; // Filtros adicionales
      }).toList();
    } catch (e) {
      print('Error al obtener historial de avistamientos: $e');
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
