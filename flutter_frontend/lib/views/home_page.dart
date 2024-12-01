import 'package:flutter/material.dart';
import '../widgets/HomeWidget/tab_bar_widget.dart';
import '../widgets/pet_card.dart';
import '../services/Pet_Service.dart';

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
                  pet['pet_name'] ?? 'Nombre desconocido',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Descripción: ${pet['description'] ?? 'Sin descripción'}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cerrar"),
                ),
              ],
            ),
          ),
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
                  username: pet['owner'] ?? 'Usuario desconocido',
                  petName: pet['pet_name'] ?? 'Mascota desconocida',
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
