import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mascotas_flutter/Services/auth.dart';
import '../model/RequestHandler.dart';
import '../Services/User.dart';

class UserMe {
  final RequestHandler Request = RequestHandler();
  final AuthService token = AuthService();
  Future<String> getUserName() async {
    try {
      final tokenUser = token.getToken();
      Request.getRequest('user/manage',
          headers: {'Authorization': 'Token $tokenUser'});
      return 'Done';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> ObtenerData(
      String email, String password, String nombre, bool Activo) async {
    try {
      final tokenUser = token.getToken();
      Request.putRequest('user/manage/',
          headers: {'Authorization': 'Token $tokenUser'});
      return 'Done';
    } catch (e) {
      return e.toString();
    }
  }
}
