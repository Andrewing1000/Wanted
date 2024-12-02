import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveMap extends StatefulWidget {
  final Stream<LatLng> coordinateStream; // Flujo de coordenadas
  final Widget Function(BuildContext, LatLng)? markerBuilder; // Personalizador del marcador

  const LiveMap({
    required this.coordinateStream,
    this.markerBuilder,
    Key? key,
  }) : super(key: key);

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> with TickerProviderStateMixin {
  LatLng _currentPosition = LatLng(-16.5038, -68.1193); // Coordenadas iniciales (La Paz)
  final MapController _mapController = MapController(); // Controlador del mapa
  late AnimationController _heartbeatController; // Controlador para la animación de latidos
  late Animation<double> _heartbeatAnimation; // Animación de escala para el ícono

  @override
  void initState() {
    super.initState();

    // Configurar el controlador y la animación de latidos
    _heartbeatController = AnimationController(
      duration: const Duration(milliseconds: 800), // Duración de cada latido
      vsync: this,
    )..repeat(reverse: true); // Animación de ida y vuelta

    _heartbeatAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _heartbeatController, curve: Curves.easeInOut),
    );

    // Escuchar cambios en el flujo de coordenadas
    widget.coordinateStream.listen((newPosition) {
      setState(() {
        _currentPosition = newPosition;
      });
      _animatedMapMove(newPosition, _mapController.zoom); // Transición suave
    });
  }

  @override
  void dispose() {
    _heartbeatController.dispose(); // Liberar recursos
    super.dispose();
  }

  /// Transición suave del mapa
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
      begin: _mapController.center.latitude,
      end: destLocation.latitude,
    );

    final lngTween = Tween<double>(
      begin: _mapController.center.longitude,
      end: destLocation.longitude,
    );

    final zoomTween = Tween<double>(
      begin: _mapController.zoom,
      end: destZoom,
    );

    final animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    animationController.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animationController.forward().then((_) => animationController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _currentPosition,
        zoom: 15.0,
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
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
                    : AnimatedBuilder(
                  animation: _heartbeatAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _heartbeatAnimation.value,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
