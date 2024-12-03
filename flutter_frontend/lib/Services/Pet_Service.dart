import 'dart:convert';

import '../model/RequestHandler.dart';
import 'auth.dart';
import 'dart:typed_data';

class Mascotas {
  final RequestHandler requestHandler = RequestHandler();
  final AuthService Auth = AuthService();
  
  Future<List<Map<String, dynamic>>> fetchLostPets() async {
    try {
      final token = await Auth.getToken();
      final response = await requestHandler.getRequest('post/lost-pets/',
          headers: {'Authorization': 'Token $token'});
      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Formato de respuesta no válido');
      }
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> registerPet({
    required String petName,
    required int species,
    required int breed,
    required String color,
    required String description,
    required String dateLost,
    required double lat,
    required double long,
    required double rewardAmount,
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
          "date_lost": dateLost,
          "latitude": lat,
          "longitude": long,
          "reward_amount": rewardAmount,
        },
        headers: {'Authorization': 'Token $token'},
      );



      // Verificar respuesta
      if (response != null && response['id'] != null) {
        return response;
      } else {
        throw Exception('Error al registrar la mascota. Formato no válido.');
      }
    } catch (e) {
      if (e.toString().contains('400')) {
        try {
          final errorData = e.toString().split('- ')[1];
          return {'error': 'Error: ${errorData.trim()}'};
        } catch (_) {
          return {'error': ''};
        }
      }
      return{'error': 'Ocurrió un error inesperado. ${e.toString()}'};
    }
  }



  Future<String> uploadPetPhoto({
    required int petId,
    required Uint8List photoBytes,
  }) async {
    final token = await Auth.getToken();
    try {
      // Codifica la imagen en base64
      final String base64Image = base64Encode(photoBytes);

      // Realiza la solicitud POST
      final response = await requestHandler.multipartPostRequest(
        'post/lost-pets/$petId/photos/upload/',
        imageField: 'photo',
        binaryImage: photoBytes,  
        data: {
          "post": "$petId",
        },
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response != null && response['photo'] != null) {
        return 'Foto subida exitosamente';
      } else {
        throw Exception('Error al subir la foto. Formato no válido.');
      }
    } catch (e) {
      return 'Error al subir la foto: ${e.toString()}';
    }
  }





  Future<List<Map<String, dynamic>>> fetchBreeds() async {
    try {
      final token = await Auth.getToken();
      final response = await requestHandler.getRequest(
        'post/breeds/',
        headers: {'Authorization': 'Token $token'},
      );

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Formato de respuesta no válido para breeds.');
      }
    } catch (e) {
      print('Error al obtener breeds: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchSpecies() async {
    try {
      final token = await Auth.getToken();
      final response = await requestHandler.getRequest(
        'post/species/',
        headers: {'Authorization': 'Token $token'},
      );

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Formato de respuesta no válido para species.');
      }
    } catch (e) {
      print('Error al obtener species: $e');
      return [];
    }
  }


  Future<List<String>> fetchPetSightingPhotos({required int id}) async {
    try {
      final token = await Auth.getToken();
      final response = await requestHandler.getRequest(
        'post/pet-sightings/$id/photos/',
        headers: {'Authorization': 'Token $token'},
      );

      if (response is List) {
        // Mapea las URLs de las fotos
        return response
            .map((item) => item['photo']?.toString() ?? '')
            .where((url) => url.isNotEmpty)
            .toList();
      } else {
        throw Exception('Formato de respuesta no válido para pet sightings photos.');
      }
    } catch (e) {
      print('Error al obtener pet sightings photos: $e');
      return [];
    }
  }

  Future<List<String>> fetchLostPetPhotos({required int id}) async {
    try {
      final token = await Auth.getToken();
      final response = await requestHandler.getRequest(
        'post/lost-pets/$id/photos/',
        headers: {'Authorization': 'Token $token'},
      );

      if (response is List) {
        // Mapea las URLs de las fotos
        return response
            .map((item) => item['photo']?.toString() ?? '')
            .where((url) => url.isNotEmpty)
            .toList();
      } else {
        throw Exception('Formato de respuesta no válido para lost pets photos.');
      }
    } catch (e) {
      print('Error al obtener lost pets photos: $e');
      return [];
    }
  }


}
