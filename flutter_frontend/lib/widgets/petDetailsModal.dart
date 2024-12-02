import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import '../widgets/Maps/live_map.dart';
import '../services/pet_service.dart';
import '../services/PetFind.dart';
import '../views/PetSightingScreen.dart';
import 'HomeWidget/pet_details_section.dart';
import 'HomeWidget/sightings_history_dialo.dart';

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
      final breeds = await petService.fetchBreeds();
      final species = await petService.fetchSpecies();

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
    final latitude = double.tryParse(widget.pet['latitude'] ?? '') ?? 0.0;
    final longitude = double.tryParse(widget.pet['longitude'] ?? '') ?? 0.0;
    final Stream<LatLng> coordinateStream = Stream.value(LatLng(latitude, longitude));

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PetDetailsSection(
                pet: widget.pet,
                breedName: breedName,
                speciesName: speciesName,
              ),
              const SizedBox(height: 16),
              const Text(
                'Ubicación:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent.withOpacity(0.8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        const SizedBox(height: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent.withOpacity(0.8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => SightingsHistoryDialog(sightings: sightingsHistory),
            );
          },
          child: const Text(
            "Ver Apariciones",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent.withOpacity(0.8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cerrar",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
