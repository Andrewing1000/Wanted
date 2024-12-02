import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/pet_card.dart';

// Clase para manejar peticiones HTTP
class RequestHandler {
  final String baseUrl = 'https://tuapi.com/'; // Cambia por tu base URL

  Future<dynamic> postRequest(String endpoint, {Map<String, dynamic>? data}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Error en la petición POST: $e');
    }
  }
}

// Función para obtener el email del usuario en sesión
Future<String?> getUserEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

// Clase del widget principal
class PetsMeScreen extends StatefulWidget {
  @override
  _PetsMeScreenState createState() => _PetsMeScreenState();
}

class _PetsMeScreenState extends State<PetsMeScreen> {
  List<Map<String, dynamic>> userPets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserPets();
  }

  // Función para obtener las publicaciones del usuario
  Future<List<Map<String, dynamic>>> fetchUserLostPets(String userEmail) async {
    final request = RequestHandler();
    try {
      final response = await request.postRequest(
        'post/lost-pets/',
        data: {"user": userEmail},
      );

      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Formato de respuesta inesperado');
      }
    } catch (e) {
      print('Error al obtener publicaciones: ${e.toString()}');
      return [];
    }
  }

  // Cargar publicaciones del usuario
  Future<void> loadUserPets() async {
    try {
      final userEmail = await getUserEmail();
      if (userEmail == null) throw Exception('Email no encontrado');

      final pets = await fetchUserLostPets(userEmail);
      setState(() {
        userPets = pets;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar publicaciones: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis publicaciones'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userPets.isEmpty
          ? Center(child: Text('No tienes publicaciones.'))
          : ListView.builder(
        itemCount: userPets.length,
        itemBuilder: (context, index) {
          final pet = userPets[index];
          return PetCard(
            username: pet['user'] ?? 'Usuario desconocido',
            petName: pet['pet_name'] ?? 'Nombre desconocido',
            status: pet['status'] ?? 'Estado desconocido',
            imageUrl: pet['photo'] ?? 'assets/dummy.jpg',
            dateLost: pet['date_lost'] ?? 'Fecha desconocida',
            rewardAmount: pet['reward_amount'] ?? '0.00',
            onTap: () {
              showPetDetailsModal(context, pet);
            },
          );
        },
      ),
    );
  }
}


// Función para mostrar el modal con los detalles de la mascota
void showPetDetailsModal(BuildContext context, Map<String, dynamic> pet) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pet['pet_name'] ?? 'Sin nombre',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(pet['description'] ?? 'Sin descripción'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    },
  );
}
