// lib/views/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_bar.dart';
import '../widgets/pet_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> petData = [
    {
      "username": "usuario1",
      "petName": "Dama",
      "status": "Perdido",
      "imageUrl": "assets/dummy.jpg",
      "description": "Dama se perdió en el parque.",
      "lastSeen": LatLng(37.7749, -122.4194)
    },
    {
      "username": "usuario2",
      "petName": "Fede",
      "status": "Encontrado",
      "imageUrl": "assets/dummy.jpg",
      "description": "Fede fue encontrado cerca de la tienda.",
      "lastSeen": LatLng(34.0522, -118.2437)
    },
    {
      "username": "usuario3",
      "petName": "Kira",
      "status": "Perdido",
      "imageUrl": "assets/dummy.jpg",
      "description": "Kira se escapó durante una caminata.",
      "lastSeen": LatLng(40.7128, -74.0060)
    },
    {
      "username": "usuario4",
      "petName": "Kira",
      "status": "Perdido",
      "imageUrl": "assets/dummy.jpg",
      "description": "Kira fue vista por última vez en el centro.",
      "lastSeen": LatLng(51.5074, -0.1278)
    },
  ];

  List<Map<String, dynamic>> filteredPetData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_filterPets);
    filteredPetData = List.from(petData);
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
              petData.where((pet) => pet['status'] == 'Encontrado').toList();
          break;
        default:
          filteredPetData = List.from(petData);
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
                  pet['petName'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Descripción: ${pet['description']}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "Último lugar visto:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200,
                  child: FlutterMap(
                    options: MapOptions(
                      center:
                          pet['lastSeen'], // Coordenadas de la última ubicación
                      zoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: pet['lastSeen'],
                            width: 80,
                            height: 80,
                            builder: (ctx) => Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      openGoogleMaps(pet['lastSeen']);
                    },
                    child: Text("Abrir en Google Maps"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> openGoogleMaps(LatLng coordinates) async {
    final googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${coordinates.latitude},${coordinates.longitude}";
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw "No se pudo abrir Google Maps";
    }
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
                  username: pet['username'],
                  petName: pet['petName'],
                  status: pet['status'],
                  imageUrl: pet['imageUrl'],
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
