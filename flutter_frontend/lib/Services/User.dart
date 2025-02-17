import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mascotas_flutter/Services/auth.dart';
import '../model/RequestHandler.dart';
import '../Services/User.dart';

class UserMe {
  final RequestHandler Request = RequestHandler();
  final AuthService token = AuthService();
  Future<Map<String, dynamic>> ObtenerData() async {
    try {
      final tokenUser = await token.getToken();
      final response = await Request.getRequest('user/me', headers: {
        'Authorization': 'Token $tokenUser',
      });

      if (response is Map<String, dynamic>) {
        return response;
      } else {
        throw Exception('Formato de respuesta inválido');
      }
    } catch (e) {
      print('Error al obtener los datos del usuario: $e');
      throw Exception('Error al obtener los datos del usuario');
    }
  }

  Future<String> GuardarCambios(
      String email, String password, String nombre, String numero) async {
    try {
      final tokenUser = await token.getToken();
      print('Token User: $tokenUser');

      await Request.putRequest(
        'user/me/',
        data: {
          "email": email,
          "password": password,
          "name": nombre,
          "phone_number": numero,
          "is_active": true,
        },
        headers: {
          'Authorization': 'Token $tokenUser',
        },
      );

      return 'Done';
    } catch (e) {
      return e.toString();
    }
  }
}
