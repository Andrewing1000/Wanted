import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PetLocationMap extends StatelessWidget {
  final LatLng petLocation;
  final String petName;
  final String petDescription;

  const PetLocationMap({
    required this.petLocation,
    required this.petName,
    required this.petDescription,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicación de ${petName}"),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: petLocation, // Aquí usamos la ubicación que se pasa correctamente
          zoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: petLocation,
                width: 80,
                height: 80,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(petName),
                            content: Text(petDescription),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cerrar"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.place,
                      color: Colors.green,
                      size: 40,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
Future<Map<String, dynamic>> fetchLastSeenLocation(int petId) async {

  return Future.delayed(Duration(seconds: 1), () {
    return {
      "date": "2024-11-20",
      "time": "15:30",
      "location": "Plaza Central, La Paz",
      "coordinates": {
        "lat": -16.5038,
        "lng": -68.1193,}
    };
  });
}