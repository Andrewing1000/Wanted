import 'dart:convert';
import '../model/RequestHandler.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import '../widgets/pet_card.dart';

class PetsMeService {
  final RequestHandler requestHandler = RequestHandler();
  final AuthService authService = AuthService();

  /// Obtener todas las mascotas perdidas del usuario actual
  Future<List<Map<String, dynamic>>> fetchLostPets() async {
    try {
      final token = await authService.getToken();
      final email = await authService.getUserEmail();
      if (email == null) throw Exception('No se pudo obtener el email del usuario.');
      final response = await requestHandler.postRequest('post/lost-pets/',
        data: {"user": email},
        headers: {'Authorization': 'Token $token'},
      );

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Formato de respuesta no válido para mascotas perdidas.');
      }
    } catch (e) {
      print('Error al obtener mascotas perdidas: $e');
      return [];
    }
  }
//
//   Future<String> createLostPet({
//     required String petName,
//     required int species,
//     required int breed,
//     required String color,
//     required String description,
//     required String dateLost,
//     required String latitude,
//     required String longitude,
//     required String rewardAmount,
//   }) async {
//     try {
//       final token = await authService.getToken();
//       final email = await authService.getUserEmail();
//       if (email == null) throw Exception('No se pudo obtener el email del usuario.');
//
//       // Realiza la solicitud POST
//       final response = await requestHandler.postRequest(
//         'post/lost-pets/',
//         data: {
//           "user": email,
//           "pet_name": petName,
//           "species": species,
//           "breed": breed,
//           "color": color,
//           "description": description,
//           "date_lost": dateLost,
//           "latitude": latitude,
//           "longitude": longitude,
//           "reward_amount": rewardAmount,
//         },
//         headers: {
//           'Authorization': 'Token $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response != null && response['id'] != null) {
//         return 'Mascota perdida registrada exitosamente';
//       } else {
//         throw Exception('Error al registrar la mascota perdida. Respuesta inesperada.');
//       }
//     } catch (e) {
//       print('Error al registrar mascota perdida: $e');
//       return 'Error al registrar mascota perdida: ${e.toString()}';
//     }
//   }
//

 }

class PetsMeScreen extends StatefulWidget {
  @override
  _PetsMeScreenState createState() => _PetsMeScreenState();
}

class _PetsMeScreenState extends State<PetsMeScreen> {
  final PetsMeService petsMeService = PetsMeService();
  List<Map<String, dynamic>> userPets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserPets();
  }

  /// Cargar las mascotas perdidas del usuario
  Future<void> loadUserPets() async {
    try {
      setState(() {
        isLoading = true;
      });

      final pets = await petsMeService.fetchLostPets();
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
            status: pet['status'] ?? 'Desconocido',
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

// Función para mostrar detalles de una mascota perdida
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
