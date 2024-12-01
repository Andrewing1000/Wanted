import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/HomeWidget/tab_bar_widget.dart';
import '../widgets/pet_card.dart';
import '../services/Pet_Service.dart';
import 'PetLocationMap.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Mascotas _petService = Mascotas();

  List<Map<String, dynamic>> petData = [];
  List<Map<String, dynamic>> filteredPetData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_filterPets);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPets(); // Refresca los datos cuando la página se carga
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchPets() async {
    final data = await _petService.fetchLostPets();
    setState(() {
      petData = data;
      filteredPetData = List.from(data);
    });
  }

  void _filterPets() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          filteredPetData = List.from(petData);
          break;
        case 1:
          filteredPetData =
              petData.where((pet) => pet['status'] == 'Perdido').toList();
          break;
        case 2:
          filteredPetData =
              petData.where((pet) => pet['status'] == 'Visto').toList();
          break;
      }
    });
  }

  void showPetDetailsModal(BuildContext context, Map<String, dynamic> pet) {
    bool isFavorite = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            pet['pet_name'] ?? 'Nombre desconocido',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Descripción: ${pet['description'] ?? 'Sin descripción'}",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            // Llama a fetchLastSeenLocation para obtener los datos
                            final lastSeenData = await fetchLastSeenLocation(1); // Simula petId = 1
                            final coordinates = lastSeenData['coordinates'];
                            final LatLng petLocation = LatLng(
                              coordinates['lat'],
                              coordinates['lng'],
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PetLocationMap(
                                  petLocation: petLocation,
                                  petName: pet['pet_name'] ?? "Sin nombre",
                                  petDescription: pet['description'] ?? "Sin descripción",
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.location_on),
                          label: Text("Última ubicación"),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("Cerrar"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBarWidget(tabController: _tabController), // TabBar personalizado
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Anuncios Recientes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: petData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredPetData.length,
              itemBuilder: (context, index) {
                final pet = filteredPetData[index];
                return PetCard(
                  username: pet['email'] ?? 'Usuario desconocido',
                  petName: pet['pet_name'] ?? 'Autor desconocido',
                  status: pet['status'] ?? 'Desconocido',
                  imageUrl: pet['photo'] ?? 'assets/dummy.jpg',
                  dateLost: pet['date_lost'] ?? 'Fecha desconocida',
                  rewardAmount: pet['reward_amount'] ?? '0.00',
                  onTap: () => showPetDetailsModal(context, pet),

                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
void showLastSeenModal(BuildContext context, int petId) async {
  // Simula la obtención de datos de la última ubicación
  final Map<String, dynamic> lastSeenData = await fetchLastSeenLocation(petId);

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Última ubicación",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Fecha: ${lastSeenData['date']}",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Hora: ${lastSeenData['time']}",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Lugar: ${lastSeenData['location']}",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Coordenadas: ${lastSeenData['coordinates'][' -16.5038']}, ${lastSeenData['coordinates']['-68.1193']}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cerrar"),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}



