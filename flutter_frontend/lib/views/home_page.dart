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

  List<Map<String, dynamic>> petData = [];
  List<Map<String, dynamic>> sightingsData = [];
  List<Map<String, dynamic>> filteredPetData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final lostPets = await petFindService.fetchLostPetsWithStatus();
      final sightings = await petFindService.fetchEnrichedSightings();

      setState(() {
        petData = lostPets.where((pet) => pet['status'] == 'Perdido').toList();
        sightingsData = sightings.where((sighting) => sighting['status'] == 'Visto').toList();
        filteredPetData = List.from(petData + sightingsData);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar los datos iniciales: $e');
    }
  }

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
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: fetchInitialData,
              child: filteredPetData.isEmpty
                  ? ListView(
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Text(
                        "No hay información disponible.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
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
                itemCount: filteredPetData.length,
                itemBuilder: (context, index) {
                  final pet = filteredPetData[index];
                  return PetCard(
                    username: pet['user']?.toString() ?? 'Usuario desconocido',
                    petName: pet['pet_name'] ?? 'Sin nombre',
                    status: pet['status'],
                    imageUrl: pet['photo'] ?? 'assets/dummy.jpg',
                    dateLost: pet['creation_date'] ?? 'Fecha desconocida',
                    rewardAmount: petFindService.getRewardForPet(pet),
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
