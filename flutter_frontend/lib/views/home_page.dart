import 'package:flutter/material.dart';
import '../Services/PetFind.dart';
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
    tabController.addListener(filterPets); // Filtrar datos al cambiar de pestaña
    fetchInitialData(); // Cargar datos iniciales
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  /// Cargar datos iniciales
  Future<void> fetchInitialData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final lostPets = await petService.fetchLostPets();
      final sightings = await petFindService.fetchEnrichedSightings();

      setState(() {
        petData = lostPets.map((pet) {
          pet['status'] = 'Perdido'; // Asignar estado "Perdido"
          return pet;
        }).toList();

        sightingsData = sightings.map((sighting) {
          sighting['status'] = 'Visto'; // Asignar estado "Visto"
          return sighting;
        }).toList();

        filteredPetData = List.from(petData + sightingsData); // Mostrar ambas en "Inicio"
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar los datos iniciales: $e');
    }
  }

  /// Cargar mascotas perdidas
  Future<void> fetchLostPets() async {
    setState(() {
      isLoading = true;
    });

    try {
      final lostPets = await petService.fetchLostPets();
      setState(() {
        petData = lostPets.map((pet) {
          pet['status'] = 'Perdido'; // Asignar estado "Perdido"
          return pet;
        }).toList();

        if (tabController.index == 1) {
          filteredPetData = List.from(petData); // Filtrar para "Perdidos"
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

  /// Cargar avistamientos
  Future<void> fetchSightings() async {
    setState(() {
      isLoading = true;
    });

    try {
      final sightings = await petFindService.fetchEnrichedSightings();
      setState(() {
        sightingsData = sightings.map((sighting) {
          sighting['status'] = 'Visto'; // Asignar estado "Visto"
          return sighting;
        }).toList();

        if (tabController.index == 2) {
          filteredPetData = List.from(sightingsData); // Filtrar para "Vistos"
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

  /// Filtrar datos según la pestaña seleccionada
  void filterPets() {
    setState(() {
      switch (tabController.index) {
        case 0: // Inicio: Todas las mascotas (perdidas y vistas)
          filteredPetData = List.from(petData + sightingsData);
          break;
        case 1: // Perdidos: Solo mascotas perdidas
          filteredPetData = petData.isNotEmpty ? List.from(petData) : [];
          if (filteredPetData.isEmpty) fetchLostPets();
          break;
        case 2: // Vistos: Solo avistamientos
          filteredPetData = sightingsData.isNotEmpty ? List.from(sightingsData) : [];
          if (filteredPetData.isEmpty) fetchSightings();
          break;
      }
    });
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
              onRefresh: () async {
                switch (tabController.index) {
                  case 0:
                    await fetchInitialData();
                    break;
                  case 1:
                    await fetchLostPets();
                    break;
                  case 2:
                    await fetchSightings();
                    break;
                }
              },
              child: filteredPetData.isEmpty
                  ? ListView(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: const Text(
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
                    status: pet['status'], // Muestra el estado dinámicamente
                    imageUrl: pet['photo'] ?? 'assets/dummy.jpg',
                    dateLost: pet['date_lost'] ?? 'Fecha desconocida',
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
