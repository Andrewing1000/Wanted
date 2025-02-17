import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../widgets/Maps/live_map.dart';

class WidgetsTestScreen extends StatefulWidget {
  @override
  _WidgetsTestScreenState createState() => _WidgetsTestScreenState();
}

class _WidgetsTestScreenState extends State<WidgetsTestScreen> {
  late Stream<LatLng> _coordinateStream;

  @override
  void initState() {
    super.initState();
    _coordinateStream = _generateCoordinates();
  }

  Stream<LatLng> _generateCoordinates() async* {
    final coordinates = [
      LatLng(-16.5038, -68.1193), // Plaza Murillo
      LatLng(-16.5110, -68.1231), // Sopocachi
      LatLng(-16.4977, -68.1330), // Miraflores
      LatLng(-16.4960, -68.1120), // El Prado
      LatLng(-16.5149, -68.1212), // Parque Urbano Central
    ];

    int index = 0;
    while (true) {
      await Future.delayed(Duration(seconds: 3));
      yield coordinates[index];
      index = (index + 1) % coordinates.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prueba de Widgets"),
      ),
      body: LiveMap(
        coordinateStream: _coordinateStream,
        markerBuilder: (context, position) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Icon(
                    Icons.pets,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Doggo',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
