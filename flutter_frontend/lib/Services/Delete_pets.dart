import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth.dart';
import '../model/RequestHandler.dart';

class DeletePetsService {
  final RequestHandler requestHandler = RequestHandler();
  final AuthService authService = AuthService();

  // Función para eliminar una publicación de mascota
  Future<bool> deletePet(int petId) async {
    try {
      final token = await authService.getToken();

      final response = await requestHandler.deleteRequest(
        'post/lost-pets/$petId/', // Endpoint para eliminar la mascota
        headers: {'Authorization': 'Token $token'},
      );

      if (response != null && response['id'] == petId) {
        return true; // Publicación eliminada exitosamente
      } else {
        throw Exception('No se pudo eliminar la publicación');
      }
    } catch (e) {
      print('Error al eliminar la publicación: $e');
      return false;
    }
  }
}
