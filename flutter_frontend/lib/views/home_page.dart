import 'package:flutter/material.dart';
import '../services/PetFind.dart';
import '../widgets/HomeWidget/tab_bar_widget.dart';
import '../widgets/petDetailsModal.dart';
import '../widgets/pet_card.dart';
import '../services/Pet_Service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final Mascotas petService = Mascotas();
  final PetFindService petFindService = PetFindService();

  List<Map<String, dynamic>> petData = []; // Mascotas perdidas
  List<Map<String, dynamic>> sightingsData = []; // Avistamientos
  List<Map<String, dynamic>> filteredPetData = []; // Mascotas filtradas
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this); // Inicio, Perdidos, Vistos
    tabController.addListener(filterPets);
    fetchInitialData();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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

  Future<void> fetchLostPets() async {
    setState(() {
      isLoading = true;
    });

    try {
      final lostPets = await petFindService.fetchLostPetsWithStatus();
      setState(() {
        petData = lostPets.where((pet) => pet['status'] == 'Perdido').toList();
        if (tabController.index == 1) {
          filteredPetData = petData;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar las mascotas perdidas: $e');
    }
  }

  Future<void> fetchSightings() async {
    setState(() {
      isLoading = true;
    });

    try {
      final sightings = await petFindService.fetchEnrichedSightings();
      setState(() {
        sightingsData = sightings.where((sighting) => sighting['status'] == 'Visto').toList();
        if (tabController.index == 2) {
          filteredPetData = sightingsData;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar los avistamientos: $e');
    }
  }

  void filterPets() {
    setState(() {
      switch (tabController.index) {
        case 0:
          filteredPetData = List.from(petData + sightingsData);
          break;
        case 1:
          filteredPetData = List.from(petData);
          if (filteredPetData.isEmpty) fetchLostPets();
          break;
        case 2:
          filteredPetData = List.from(sightingsData);
          if (filteredPetData.isEmpty) fetchSightings();
          break;
      }
    });
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBarWidget(tabController: tabController),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Anuncios Recientes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
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
                    rewardAmount: pet['reward_amount'] ?? '0.00',
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
