import 'package:flutter/material.dart';
import '../widgets/HomeWidget/tab_bar_widget.dart';
import '../widgets/petDetailsModal.dart';
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
  bool _isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_filterPets);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPets(); // Cargar datos cada vez que se muestra la página
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchPets() async {
    setState(() {
      _isLoading = true;
    });

    final data = await _petService.fetchLostPets();
    setState(() {
      petData = data;
      filteredPetData = List.from(data);
      _isLoading = false; // Termina la carga
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
          TabBarWidget(tabController: _tabController), // TabBar personalizado
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Anuncios Recientes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _fetchPets, // Refrescar los datos
              child: petData.isEmpty
                  ? ListView(
                // Necesario para usar RefreshIndicator con contenido vacío
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
                    username: pet['user'] ?? 'Usuario desconocido',
                    petName: pet['pet_name'] ?? 'Autor desconocido',
                    status: 'Perdido',
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
