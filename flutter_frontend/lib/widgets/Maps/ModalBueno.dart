import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../Services/MapAdapter.dart';

class PetDetailsModal extends StatelessWidget {
  final Map<String, dynamic> pet;

  const PetDetailsModal({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Coordenadas de la mascota
    final latitude = double.tryParse(pet['latitude'] ?? '') ?? 0.0;
    final longitude = double.tryParse(pet['longitude'] ?? '') ?? 0.0;

    // Controlador del MapAdapter
    final MapAdapterController mapController = MapAdapterController();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre de la mascota
              Text(
                pet['pet_name'] ?? 'Nombre desconocido',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Información básica
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Especie: ${pet['species'] ?? 'Desconocida'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Raza: ${pet['breed'] ?? 'Desconocida'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                'Color: ${pet['color'] ?? 'Desconocido'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Descripción
              Text(
                'Descripción:',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                pet['description'] ?? 'Sin descripción',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Fecha de pérdida
              Text(
                'Fecha de pérdida: ${pet['date_lost'] ?? 'Desconocida'}',
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),

              // Mapa
              Text(
                'Ubicación:',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 400, // Altura del mapa
                child: MapAdapter(
                  controller: mapController,
                  initialCameraPosition: {
                    'latitude': latitude,
                    'longitude': longitude,
                    'zoom': 15.0,
                  },
                  onMarkerClick: (markerId) {
                    print('Marcador clicado: $markerId');
                  },
                  onMapClick: (lat, lng) {
                    print('Mapa clicado: $lat, $lng');
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Botón para cerrar
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cerrar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
