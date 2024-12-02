import 'package:flutter/material.dart';
import '../widgets/HomeWidget/tab_bar_widget.dart';
import '../widgets/petDetailsModal.dart';
import '../widgets/pet_card.dart';
import '../services/Pet_Service.dart';
import '../services/PetFind.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final Mascotas petService = Mascotas();
  final PetFindService petFindService = PetFindService();

  List<Map<String, dynamic>> petData = []; // Todas las mascotas perdidas
  List<Map<String, dynamic>> sightingsData = []; // Todas las mascotas vistas
  List<Map<String, dynamic>> filteredPetData = []; // Mascotas filtradas por estado
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this); // Inicio, Perdidos, Vistos
    tabController.addListener(() {
      filterPets(); // Filtrar mascotas según la pestaña activa
    });
    fetchInitialData(); // Cargar datos iniciales
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
      final lostPets = await petService.fetchLostPets(); // Mascotas perdidas
      final sightings = await petFindService.fetchPetSightings(); // Mascotas vistas

      setState(() {
        petData = lostPets.map((pet) {
          pet['status'] = 'Perdido';
          return pet;
        }).toList();

        sightingsData = sightings.map((sighting) {
          sighting['status'] = 'Visto';
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

  Future<void> fetchLostPets() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await petService.fetchLostPets();
      setState(() {
        petData = data.map((pet) {
          pet['status'] = 'Perdido';
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

  Future<void> fetchSightings() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await petFindService.fetchPetSightings();
      setState(() {
        sightingsData = data.map((sighting) {
          sighting['status'] = 'Visto';
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

  void filterPets() {
    setState(() {
      switch (tabController.index) {
        case 0: // Inicio: Mascotas perdidas y vistas
          filteredPetData = List.from(petData + sightingsData);
          break;
        case 1: // Perdidos: Solo mascotas perdidas
          if (petData.isEmpty) {
            fetchLostPets(); // Si está vacío, cargar desde el servicio
          } else {
            filteredPetData = List.from(petData);
          }
          break;
        case 2: // Vistos: Solo mascotas vistas
          if (sightingsData.isEmpty) {
            fetchSightings(); // Si está vacío, cargar desde el servicio
          } else {
            filteredPetData = List.from(sightingsData);
          }
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
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: () async {
                if (tabController.index == 0) {
                  await fetchInitialData(); // Actualizar todo en "Inicio"
                } else if (tabController.index == 1) {
                  await fetchLostPets(); // Actualizar "Perdidos"
                } else if (tabController.index == 2) {
                  await fetchSightings(); // Actualizar "Vistos"
                }
              },
              child: filteredPetData.isEmpty
                  ? ListView(
                children: [
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
