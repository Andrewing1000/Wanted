import 'package:flutter/material.dart';
import '../services/PetFind.dart';
import '../widgets/petDetailsModal.dart';
import '../widgets/pet_card.dart';
import '../services/Pet_Service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Mascotas petService = Mascotas();
  final PetFindService petFindService = PetFindService();

  List<Map<String, dynamic>> petData = []; // Mascotas perdidas (iniciales)
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLostPets();
  }

  /// Cargar mascotas perdidas y actualizarlas según su estado
  Future<void> fetchLostPets() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Obtener todas las mascotas perdidas
      final lostPets = await petFindService.fetchLostPetsWithStatus();

      setState(() {
        // Filtrar mascotas con estado "Perdido" o "Visto"
        petData = lostPets.where((pet) => pet['status'] == 'Perdido' || pet['status'] == 'Visto').toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar mascotas perdidas: $e');
    }
  }

  /// Mostrar detalles de la mascota
  void showPetDetailsModal(BuildContext context, Map<String, dynamic> pet) {
    showDialog(
      context: context,
      builder: (context) {
        return PetDetailsModal(pet: pet);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anuncios Recientes'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Eliminar flecha de regreso
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: fetchLostPets,
              child: petData.isEmpty
                  ? ListView(
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Text(
                        "No hay información disponible.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemCount: petData.length,
                itemBuilder: (context, index) {
                  final pet = petData[index];
                  return PetCard(
                    username: pet['user']?.toString() ?? 'Usuario desconocido',
                    petName: pet['pet_name'] ?? 'Sin nombre',
                    status: pet['status'], // Estado dinámico
                    imageUrl: pet['photo'] ?? 'assets/dummy.jpg',
                    dateLost: pet['creation_date'] ?? 'Fecha desconocida',
                    rewardAmount: pet['status'] == 'Perdido'
                        ? (pet['reward_amount'] ?? 'No aplica')
                        : 'No aplica',
                    onTap: () => showPetDetailsModal(context, pet),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
