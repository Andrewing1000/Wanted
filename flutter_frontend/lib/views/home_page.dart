import 'package:flutter/material.dart';
import '../services/PetFind.dart';
import '../widgets/petDetailsModal.dart';
import '../widgets/pet_card.dart';
import '../widgets/pet_grid.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
        petData = lostPets;
        sightingsData = sightings;
        filteredPetData = List.from(lostPets + sightings);
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
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: fetchInitialData,
              child: PetGrid(
                petData: filteredPetData,
                onPetSelected: (pet) => showPetDetailsModal(context, pet),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
