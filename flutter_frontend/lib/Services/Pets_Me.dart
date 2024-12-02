import 'package:flutter/material.dart';
import '../Services/auth.dart';
import '../model/RequestHandler.dart';
import '../widgets/pet_card.dart';
import 'package:flutter/material.dart';

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

  Future<List<Map<String, dynamic>>> fetchUserLostPets(String userEmail) async {
    final request = RequestHandler();
    try {
      final response = await request.postRequest('post/lost-pets/',
        data: {
          "user": userEmail,
        },
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
              // Aquí puedes agregar la funcionalidad para mostrar detalles
              showPetDetailsModal(context, pet);
            },
          );
        },
      ),
    );
  }
}
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