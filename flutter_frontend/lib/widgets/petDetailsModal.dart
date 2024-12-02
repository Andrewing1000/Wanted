import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import '../widgets/Maps/live_map.dart';
import '../services/pet_service.dart';
import '../services/PetFind.dart'; // Importar el servicio para el historial
import '../views/PetSightingScreen.dart'; // Importar la pantalla de avistamientos

class PetDetailsModal extends StatefulWidget {
  final Map<String, dynamic> pet;

  const PetDetailsModal({Key? key, required this.pet}) : super(key: key);

  @override
  _PetDetailsModalState createState() => _PetDetailsModalState();
}

class _PetDetailsModalState extends State<PetDetailsModal> {
  String? breedName;
  String? speciesName;
  bool isLoading = true;
  List<Map<String, dynamic>> sightingsHistory = [];

  @override
  void initState() {
    super.initState();
    _loadPetDetails();
    _loadSightingsHistory();
  }

  Future<void> _loadPetDetails() async {
    try {
      final petService = Mascotas();

      // Obtener las listas de razas y especies
      final breeds = await petService.fetchBreeds();
      final species = await petService.fetchSpecies();

      // Buscar los nombres literales de la raza y la especie
      breedName = breeds.firstWhere(
            (breed) => breed['id'] == widget.pet['breed'],
        orElse: () => {'value': 'Desconocida'},
      )['value'];

      speciesName = species.firstWhere(
            (species) => species['id'] == widget.pet['species'],
        orElse: () => {'value': 'Desconocida'},
      )['value'];
    } catch (e) {
      print("Error al cargar detalles de la mascota: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadSightingsHistory() async {
    try {
      final petFindService = PetFindService();
      final history = await petFindService.fetchSightingsForLostPet(widget.pet);

      setState(() {
        sightingsHistory = history;
      });
    } catch (e) {
      print("Error al cargar el historial de avistamientos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Coordenadas de la mascota
    final latitude = double.tryParse(widget.pet['latitude'] ?? '') ?? 0.0;
    final longitude = double.tryParse(widget.pet['longitude'] ?? '') ?? 0.0;
    final Stream<LatLng> coordinateStream = Stream.value(LatLng(latitude, longitude));

    // Extraer color
    final String colorHex = widget.pet['color'] ?? '#FFFFFF';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.grey.withOpacity(1), // Fondo más oscuro
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre de la mascota
            Text(
              widget.pet['pet_name'] ?? 'Nombre desconocido',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Información básica
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Especie: $speciesName',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'Raza: $breedName',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Color con barra de color
            Row(
              children: [
                const Text(
                  'Color:',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _hexToColor(colorHex),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.black26),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Descripción
            const Text(
              'Descripción:',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              widget.pet['description'] ?? 'Sin descripción',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Fecha de pérdida
            Text(
              'Fecha de pérdida: ${widget.pet['date_lost'] ?? 'Desconocida'}',
              style: const TextStyle(
                  fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Mapa
            const Text(
              'Ubicación:',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: LiveMap(
                coordinateStream: coordinateStream,
                markerBuilder: (context, position) => const Icon(
                  Icons.pets,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetSightingScreen(
                          pet: widget.pet,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Generar Avistamiento",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    _showSightingsHistory(context);
                  },
                  child: const Text(
                    "Ver Apariciones",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cerrar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSightingsHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sightingsHistory.length,
            itemBuilder: (context, index) {
              final sighting = sightingsHistory[index];
              return ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue),
                title: Text('Fecha: ${sighting['date_sighted']}'),
                subtitle: Text('Ubicación: ${sighting['latitude']}, ${sighting['longitude']}'),
              );
            },
          ),
        );
      },
    );
  }

  /// Convierte un string hexadecimal en un color
  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Añadir opacidad si no está presente
    }
    return Color(int.parse(hex, radix: 16));
  }
}
