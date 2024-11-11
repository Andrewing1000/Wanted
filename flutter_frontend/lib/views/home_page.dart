import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/pet_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Lista original de todas las tarjetas
  final List<Map<String, String>> petData = [
    {"username": "usuario1", "petName": "Dama", "status": "Perdido", "imageUrl": "assets/dummy.jpg"},
    {"username": "usuario2", "petName": "Fede", "status": "Encontrado", "imageUrl": "assets/dummy.jpg"},
    {"username": "usuario3", "petName": "Kira", "status": "Perdido", "imageUrl": "assets/dummy.jpg"},
    {"username": "usuario4", "petName": "Kira", "status": "Perdido", "imageUrl": "assets/dummy.jpg"},
  ];

  List<Map<String, String>> filteredPetData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Cambiado a 3
    _tabController.addListener(_filterPets);
    filteredPetData = List.from(petData); // Inicialmente, mostramos todos
  }

  void _filterPets() {
    setState(() {
      switch (_tabController.index) {
        case 0: // Inicio
          filteredPetData = List.from(petData);
          break;
        case 1: // Perdidos
          filteredPetData = petData.where((pet) => pet['status'] == 'Perdido').toList();
          break;
        case 2: // Encontrados
          filteredPetData = petData.where((pet) => pet['status'] == 'Encontrado').toList();
          break;
        default:
          filteredPetData = List.from(petData);
          break;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(tabController: _tabController),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Anuncios Recientes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredPetData.length,
              itemBuilder: (context, index) {
                final pet = filteredPetData[index];
                return PetCard(
                  username: pet['username']!,
                  petName: pet['petName']!,
                  status: pet['status']!,
                  imageUrl: pet['imageUrl']!,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Guardados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuario',
          ),
        ],
      ),
    );
  }
}
