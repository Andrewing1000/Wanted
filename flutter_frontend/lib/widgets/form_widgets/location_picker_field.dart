import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerField extends StatefulWidget {
  final LatLng? initialLocation; // Ubicación inicial opcional
  final Function(LatLng) onLocationPicked;

  const LocationPickerField({
    this.initialLocation,
    required this.onLocationPicked,
    Key? key,
  }) : super(key: key);

  @override
  _LocationPickerFieldState createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation ?? LatLng(0.0, 0.0);
  }

  void _onMapTapped(LatLng point) {
    setState(() {
      _selectedLocation = point;
    });
    widget.onLocationPicked(point); // Notifica al formulario la ubicación seleccionada
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ubicación",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FlutterMap(
            options: MapOptions(
              center: _selectedLocation,
              zoom: 13,
              onTap: (_, point) => _onMapTapped(point),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 40,
                      height: 40,
                      builder: (ctx) => Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(height: 8),
        if (_selectedLocation != null)
          Text(
            "Latitud: ${_selectedLocation!.latitude.toStringAsFixed(5)}, Longitud: ${_selectedLocation!.longitude.toStringAsFixed(5)}",
            style: TextStyle(color: Colors.grey[700]),
          ),
      ],
    );
  }
}
