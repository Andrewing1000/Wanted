import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import '../widgets/Maps/live_map.dart';
import '../Services/Pet_Service.dart'; // Asegúrate de importar correctamente

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

  @override
  void initState() {
    super.initState();
    _loadPetDetails();
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

  @override
  Widget build(BuildContext context) {
    // Coordenadas de la mascota
    final latitude = double.tryParse(widget.pet['latitude'] ?? '') ?? 0.0;
    final longitude = double.tryParse(widget.pet['longitude'] ?? '') ?? 0.0;
    final Stream<LatLng> coordinateStream =
    Stream.value(LatLng(latitude, longitude));

    // Extraer color
    final String colorHex = widget.pet['color'] ?? '#FFFFFF';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
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
              style:
              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Información básica
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Especie: $speciesName',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Raza: $breedName',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Color con barra de color
            Row(
              children: [
                Text(
                  'Color:',
                  style: const TextStyle(fontSize: 16),
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
            Text(
              'Descripción:',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.pet['description'] ?? 'Sin descripción',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Fecha de pérdida
            Text(
              'Fecha de pérdida: ${widget.pet['date_lost'] ?? 'Desconocida'}',
              style: const TextStyle(
                  fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),

            // Mapa
            Text(
              'Ubicación:',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: LiveMap(
                coordinateStream: coordinateStream,
                markerBuilder: (context, position) => Icon(
                  Icons.pets,
                  color: Colors.blue,
                  size: 40,
                ),
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
