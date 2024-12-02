import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/Maps/MapWithRadius.dart';
import '../services/LookUp.dart';
import '../widgets/start_button.dart';

class NearbySearchScreen extends StatefulWidget {
  @override
  _NearbySearchScreenState createState() => _NearbySearchScreenState();
}

class _NearbySearchScreenState extends State<NearbySearchScreen> {
  final LookUpService lookUpService = LookUpService();
  LatLng _selectedLocation = LatLng(-16.5038, -68.1193); // Coordenadas iniciales
  double _selectedRadius = 30.0; // Radio inicial en metros

  /// Método para manejar actualizaciones de ubicación y radio desde el mapa
  void _onLocationUpdated(LatLng location, double radius) {
    setState(() {
      _selectedLocation = location;
      _selectedRadius = radius;
    });
  }

  /// Método para realizar la búsqueda con los datos ingresados
  Future<void> _searchNearby() async {
    final radiusInKm = _selectedRadius / 1000.0; // Convertir metros a kilómetros

    try {
      final lostPets = await lookUpService.fetchLostPetsNearby(
        centerLatitude: _selectedLocation.latitude,
        centerLongitude: _selectedLocation.longitude,
        radius: radiusInKm,
      );

      final sightings = await lookUpService.fetchPetSightingsNearby(
        centerLatitude: _selectedLocation.latitude,
        centerLongitude: _selectedLocation.longitude,
        radius: radiusInKm,
      );

      // Mostrar resultados
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(lostPets: lostPets, sightings: sightings),
        ),
      );
    } catch (e) {
      print('Error al buscar datos cercanos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al buscar datos cercanos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Búsqueda Cercana',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: LiveMapWithRadius(
              initialLocation: _selectedLocation,
              initialRadius: _selectedRadius,
              onLocationUpdated: _onLocationUpdated,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Presiona el botón para buscar mascotas o avistamientos cercanos.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                StartButton(
                  onPressed: _searchNearby,
                  text: 'Buscar',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> lostPets;
  final List<Map<String, dynamic>> sightings;

  const ResultsScreen({
    required this.lostPets,
    required this.sightings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Resultados'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Mascotas Perdidas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (lostPets.isEmpty)
            const Text('No se encontraron mascotas perdidas.', style: TextStyle(color: Colors.grey)),
          ...lostPets.map((pet) => PetCard(data: pet)).toList(),
          const SizedBox(height: 16),
          const Text(
            'Avistamientos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (sightings.isEmpty)
            const Text('No se encontraron avistamientos.', style: TextStyle(color: Colors.grey)),
          ...sightings.map((sighting) => SightingCard(data: sighting)).toList(),
        ],
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const PetCard({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data['photo'] ?? 'https://via.placeholder.com/150'),
        ),
        title: Text(data['pet_name'] ?? 'Sin nombre'),
        subtitle: Text(data['description'] ?? 'Sin descripción'),
        trailing: Text('Recompensa: ${data['reward_amount'] ?? 'N/A'}'),
      ),
    );
  }
}

class SightingCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const SightingCard({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: const Icon(Icons.visibility, color: Colors.blue),
        title: Text('Avistado en ${data['date_sighted'] ?? 'Fecha desconocida'}'),
        subtitle: Text(data['description'] ?? 'Sin descripción'),
        trailing: Text('Color: ${data['color'] ?? 'N/A'}'),
      ),
    );
  }
}
