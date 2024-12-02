import 'dart:convert';
import '../model/RequestHandler.dart';
import 'auth.dart';

class LookUpService {
  final RequestHandler requestHandler = RequestHandler();
  final AuthService authService = AuthService();

  /// Método para obtener mascotas perdidas cercanas
  /// [centerLatitude]: Latitud central
  /// [centerLongitude]: Longitud central
  /// [radius]: Radio en kilómetros
  Future<List<Map<String, dynamic>>> fetchLostPetsNearby({
    required double centerLatitude,
    required double centerLongitude,
    required double radius,
  }) async {
    try {
      final token = await authService.getToken();

      final response = await requestHandler.getRequest(
        'post/lost-pets/near/',
        params: {
          'center_latitude': centerLatitude.toStringAsFixed(7),
          'center_longitude': centerLongitude.toStringAsFixed(7),
          'radius': radius.toString(),
        },
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Formato de respuesta no válido para mascotas cercanas.');
      }
    } catch (e) {
      print('Error al obtener mascotas cercanas: $e');
      return [];
    }
  }

  /// Método para obtener avistamientos cercanos
  /// [centerLatitude]: Latitud central
  /// [centerLongitude]: Longitud central
  /// [radius]: Radio en kilómetros
  Future<List<Map<String, dynamic>>> fetchPetSightingsNearby({
    required double centerLatitude,
    required double centerLongitude,
    required double radius,
  }) async {
    try {
      final token = await authService.getToken();

      final response = await requestHandler.getRequest(
        'post/pet-sightings/near/',
        params: {
          'center_latitude': centerLatitude.toStringAsFixed(7),
          'center_longitude': centerLongitude.toStringAsFixed(7),
          'radius': radius.toString(),
        },
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Formato de respuesta no válido para avistamientos cercanos.');
      }
    } catch (e) {
      print('Error al obtener avistamientos cercanos: $e');
      return [];
    }
  }
}
