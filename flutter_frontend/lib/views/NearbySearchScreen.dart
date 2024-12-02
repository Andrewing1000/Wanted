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
  double _selectedRadius = 25.0; // Radio inicial en metros

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
      _showResultsDialog(lostPets, sightings);
    } catch (e) {
      print('Error al buscar datos cercanos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al buscar datos cercanos')),
      );
    }
  }

  /// Mostrar un cuadro de diálogo con los resultados
  void _showResultsDialog(List<Map<String, dynamic>> lostPets, List<Map<String, dynamic>> sightings) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resultados'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mascotas perdidas cercanas:', style: TextStyle(fontWeight: FontWeight.bold)),
                if (lostPets.isEmpty)
                  const Text('No se encontraron mascotas perdidas.'),
                ...lostPets.map((pet) => Text('• ${pet['name'] ?? 'Sin nombre'}')).toList(),
                const SizedBox(height: 16),
                const Text('Avistamientos cercanos:', style: TextStyle(fontWeight: FontWeight.bold)),
                if (sightings.isEmpty)
                  const Text('No se encontraron avistamientos.'),
                ...sightings.map((sighting) => Text('• ${sighting['description'] ?? 'Sin descripción'}')).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
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
