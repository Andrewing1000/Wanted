import 'dart:async';
import 'package:mascotas_flutter/Services/auth.dart';
import '../model/RequestHandler.dart';

class EditosMascotas {
  final RequestHandler request = RequestHandler();
  final AuthService authService = AuthService();

  /// Obtiene los datos de una mascota específica por su ID.
  Future<Map<String, dynamic>> obtenerMascotaPorId(int petId) async {
    try {
      final tokenUser = await authService.getToken();
      final response = await request.getRequest(
        'post/lost-pets/$petId/',
        headers: {
          'Authorization': 'Token $tokenUser',
        },
      );

      if (response is Map<String, dynamic>) {
        return response;
      } else {
        throw Exception('Formato de respuesta inválido');
      }
    } catch (e) {
      print('Error al obtener los datos de la mascota: $e');
      throw Exception('Error al obtener los datos de la mascota');
    }
  }

  /// Modifica los datos de una mascota específica por su ID.
  Future<String> modificarMascota({
    required int petId,
    required String petName,
    required int species,
    required int breed,
    required String color,
    required String description,
    required String dateLost,
    required String latitude,
    required String longitude,
    String rewardAmount = '',
  }) async {
    try {
      final tokenUser = await authService.getToken();

      await request.putRequest(
        'post/lost-pets/$petId/',
        data: {
          "pet_name": petName,
          "species": species,
          "breed": breed,
          "color": color,
          "description": description,
          "date_lost": dateLost,
          "latitude": latitude,
          "longitude": longitude,
          "reward_amount": rewardAmount,
        },
        headers: {
          'Authorization': 'Token $tokenUser',
        },
      );

      return 'Mascota modificada con éxito';
    } catch (e) {
      print('Error al modificar mascota: $e');
      return 'Error al modificar mascota: $e';
    }
  }
}
