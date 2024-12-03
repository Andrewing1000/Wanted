import 'dart:convert';
import '../model/RequestHandler.dart';
import 'auth.dart';
import 'dart:typed_data';

class Mascotas {
  final RequestHandler requestHandler = RequestHandler();
  final AuthService Auth = AuthService();

  /// Obtener todas las mascotas perdidas
  Future<List<Map<String, dynamic>>> fetchLostPets() async {
    try {
      final token = await Auth.getToken();
      final response = await requestHandler.getRequest(
        'post/lost-pets/',
        headers: {'Authorization': 'Token $token'},
      );

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Formato de respuesta no válido.');
      }
    } catch (e) {
      print('Error al obtener mascotas perdidas: $e');
      return [];
    }
  }
//crear mascota perdida
  Future<String> registerPet({
    required String petName,
    required int species,
    required int breed,
    required String color,
    required String description,
    required String? photo,
    required String dateLost,
    required String lat,
    required String long,
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
          "date_lost": dateLost,
          "latitude": lat,
          "longitude": long,
          "reward_amount": rewardAmount,
        },
        headers: {'Authorization': 'Token $token'},
      );

      if (response != null && response['id'] != null) {
        final int petId = response['id'];


        if (photo != null) {
          final uploadResponse = await uploadPetPhoto(petId: petId, photoBytes: base64Decode(photo));
          if (uploadResponse != "Foto subida exitosamente") {
            throw Exception('yo'+uploadResponse);
          }
        }

        return 'Mascota registrada exitosamente con foto';
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

  /// Obtener mascota por ID
  Future<Map<String, dynamic>?> fetchPetById(int petId) async {
    try {
      final token = await Auth.getToken();
      final response = await requestHandler.getRequest(
        'post/lost-pets/$petId/',
        headers: {'Authorization': 'Token $token'},
      );

      if (response is Map<String, dynamic>) {
        return response;
      } else {
        throw Exception('Formato de respuesta no válido.');
      }
    } catch (e) {
      print('Error al obtener mascota por ID: $e');
      return null;
    }
  }

  /// Eliminar una mascota perdida
  Future<String> deleteLostPet(int petId) async {
    try {
      final token = await Auth.getToken();
      await requestHandler.deleteRequest(
        'post/lost-pets/$petId/',
        headers: {'Authorization': 'Token $token'},
      );
      return 'Mascota eliminada de mascotas perdidas';
    } catch (e) {
      print('Error al eliminar mascota perdida: $e');
      return 'Error al eliminar mascota perdida: ${e.toString()}';
    }
  }
//actualizar Mascota
  Future<String> updatePet({ required int petId, required String petName, required int species, required int breed, required String color, required String description,
    String? photo,
    required String dateLost,
    required String lat,
    required String long,
    String? rewardAmount,
  }) async {
    try {
      final authToken = await AuthService().getToken(); // Obtén el token del usuario autenticado.

      // Datos que se enviarán al servidor.
      final Map<String, dynamic> data = {
        "pet_name": petName,
        "species": species,
        "breed": breed,
        "color": color,
        "description": description,
        "date_lost": dateLost,
        "latitude": lat,
        "longitude": long,
        "reward_amount": rewardAmount ?? '',
      };

      // Incluye la imagen si está disponible.
      if (photo != null) {
        data["photo"] = photo;
      }

      // Realizar la solicitud PUT.
      final response = await requestHandler.putRequest(
        'post/lost-pets/$petId/',
        data: data,
        headers: {
          'Authorization': 'Token $authToken',
        },
      );

      // Devuelve la respuesta en caso de éxito.
      return "Mascota actualizada con éxito";
    } catch (e) {
      print("Error al actualizar la mascota: $e");
      throw Exception("Error al actualizar la mascota");
    }
  }
//subir foto
  Future<String> uploadPetPhoto({
    required int petId,
    required Uint8List photoBytes,
  }) async {
    final token = await Auth.getToken();
    try {
      // Codifica la imagen en base64
      final String base64Image = base64Encode(photoBytes);

      // Realiza la solicitud POST
      final response = await requestHandler.postRequest(
        'post/lost-pets/$petId/photos/upload/',
        data: {
          "photo": base64Image,
          "post": petId,
        },
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response != null && response['photo'] != null) {
        return '';
      } else {
        throw Exception('Error al subir la foto. Formato no válido.');
      }
    } catch (e) {
      return 'Error al subir la foto: ${e.toString()}';
    }
  }

  //
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
}
