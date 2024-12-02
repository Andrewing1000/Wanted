import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../Maps/live_map.dart';

class SightingsHistoryDialog extends StatelessWidget {
  final List<Map<String, dynamic>> sightings;

  const SightingsHistoryDialog({Key? key, required this.sightings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: sightings.isEmpty
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No hay avistamientos registrados.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ),
      )
          : ListView.builder(
        shrinkWrap: true,
        itemCount: sightings.length,
        itemBuilder: (context, index) {
          final sighting = sightings[index];
          final latitude = double.tryParse(sighting['latitude'].toString()) ?? 0.0;
          final longitude = double.tryParse(sighting['longitude'].toString()) ?? 0.0;

          return ListTile(
            leading: const Icon(Icons.location_on, color: Colors.blue),
            title: Text('Fecha: ${sighting['date_sighted'] ?? 'Desconocida'}'),
            subtitle: GestureDetector(
              onTap: () {
                _showSightingMap(context, LatLng(latitude, longitude));
              },
              child: const Text(
                'Ver mapa',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Muestra un mapa con la ubicación del avistamiento seleccionado
  void _showSightingMap(BuildContext context, LatLng location) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Mapa del Avistamiento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: LiveMap(
                    coordinateStream: Stream.value(location),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
