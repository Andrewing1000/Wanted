import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveMap extends StatefulWidget {
  final Stream<LatLng> coordinateStream; // Flujo de coordenadas
  final Widget Function(BuildContext, LatLng)? markerBuilder; // Personalizador del marcador

  const LiveMap({
    required this.coordinateStream,
    this.markerBuilder, // Widget para personalizar el marcador
    Key? key,
  }) : super(key: key);

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  LatLng _currentPosition = LatLng(-16.5038, -68.1193); // Coordenadas iniciales (La Paz)
  final MapController _mapController = MapController(); // Controlador del mapa

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el flujo de coordenadas
    widget.coordinateStream.listen((newPosition) {
      setState(() {
        _currentPosition = newPosition;
      });
      _mapController.move(newPosition, _mapController.zoom); // Centrar mapa en el marcador
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _currentPosition,
        zoom: 15.0,
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag, // Permitir arrastrar y acercar
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _currentPosition,
              width: 80,
              height: 80,
              builder: (context) {
                // Construir marcador personalizado si se proporciona, de lo contrario usar un marcador predeterminado
                return widget.markerBuilder != null
                    ? widget.markerBuilder!(context, _currentPosition)
                    : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Marcador',
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
          ],
        ),
      ],
    );
  }
}
