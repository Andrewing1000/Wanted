import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveMapWithRadius extends StatefulWidget {
  final LatLng initialLocation;
  final double initialRadius; // Radio inicial en metros
  final Function(LatLng, double) onLocationUpdated; // Callback para la ubicación y el radio

  const LiveMapWithRadius({
    required this.initialLocation,
    this.initialRadius = 20, // Por defecto 20 metros
    required this.onLocationUpdated,
    Key? key,
  }) : super(key: key);

  @override
  _LiveMapWithRadiusState createState() => _LiveMapWithRadiusState();
}

class _LiveMapWithRadiusState extends State<LiveMapWithRadius> {
  late LatLng _currentLocation;
  late double _currentRadius;

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
    _currentRadius = widget.initialRadius.clamp(10, 5000); // Asegurar que el valor inicial esté dentro de los límites
  }

  /// Actualizar ubicación cuando el usuario toca el mapa
  void _onMapTapped(LatLng point) {
    setState(() {
      _currentLocation = point;
    });
    widget.onLocationUpdated(_currentLocation, _currentRadius);
  }

  /// Actualizar el radio dinámicamente
  void _updateRadius(double newRadius) {
    setState(() {
      _currentRadius = newRadius;
    });
    widget.onLocationUpdated(_currentLocation, _currentRadius);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: _currentLocation,
            zoom: 15,
            onTap: (_, point) => _onMapTapped(point),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            CircleLayer(
              circles: [
                CircleMarker(
                  point: _currentLocation,
                  color: Colors.blue.withOpacity(0.3),
                  borderStrokeWidth: 2,
                  borderColor: Colors.blue,
                  radius: _currentRadius, // Radio en metros
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentLocation,
                  width: 40,
                  height: 40,
                  builder: (context) => const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Ajustar Radio (metros)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _currentRadius,
                    min: 10, // Mínimo 10 metros
                    max: 750,
                    divisions: 100,
                    label: "${_currentRadius.toInt()} m",
                    onChanged: _updateRadius,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
