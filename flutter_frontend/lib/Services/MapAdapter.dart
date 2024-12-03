import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapAdapter extends StatefulWidget {
  final MapAdapterController controller;
  final Function(String markerId)? onMarkerClick;
  final Function(double latitude, double longitude)? onMapClick;
  final Function(double latitude, double longitude)? onStreetViewChange;
  final Function(double latitude, double longitude, double zoom)? onCameraIdle;
  final Map<String, dynamic>? initialCameraPosition;
  final double height;
  final VoidCallback? onMapReady; // Añadido

  const MapAdapter({
    Key? key,
    required this.controller,
    this.onMarkerClick,
    this.onMapClick,
    this.onStreetViewChange,
    this.onCameraIdle,
    this.initialCameraPosition,
    this.height = 400.0,
    this.onMapReady, // Añadido
  }) : super(key: key);

  @override
  MapAdapterState createState() => MapAdapterState();
}

class MapAdapterState extends State<MapAdapter> {
  late MethodChannel _platformChannel;
  int? _viewId;

  @override
  void initState() {
    super.initState();
    widget.controller._attach(this);
  }

  @override
  void dispose() {
    widget.controller._detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: AndroidView(
        viewType: 'com.example.map_adapter',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: {
          'initialCameraPosition': widget.initialCameraPosition ??
              {
                'latitude': 37.7749,
                'longitude': -122.4194,
                'zoom': 12.0,
              }
        },
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }

  void _onPlatformViewCreated(int id) {
    _viewId = id;
    _platformChannel = MethodChannel('com.example.map_adapter_$id');
    _platformChannel.setMethodCallHandler(_handleMethodCall);
    widget.controller._setMethodChannel(_platformChannel);

    // Llamar al callback onMapReady si está definido
    if (widget.onMapReady != null) {
      widget.onMapReady!();
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onMarkerClick':
        if (widget.onMarkerClick != null) {
          widget.onMarkerClick!(call.arguments as String);
        }
        break;
      case 'onMapClick':
        if (widget.onMapClick != null) {
          final args = Map<String, dynamic>.from(call.arguments);
          widget.onMapClick!(args['latitude'], args['longitude']);
        }
        break;
      case 'onStreetViewChange':
        if (widget.onStreetViewChange != null) {
          final args = Map<String, dynamic>.from(call.arguments);
          widget.onStreetViewChange!(args['latitude'], args['longitude']);
        }
        break;
      case 'onCameraIdle':
        if (widget.onCameraIdle != null) {
          final args = Map<String, dynamic>.from(call.arguments);
          widget.onCameraIdle!(
            args['latitude'],
            args['longitude'],
            args['zoom'],
          );
        }
        break;
    }
  }
}

// Resto del MapAdapterController sin cambios


class MapAdapterController {
  MethodChannel? _platformChannel;
  MapAdapterState? _mapAdapterState;

  void _attach(MapAdapterState state) {
    _mapAdapterState = state;
  }

  void _detach() {
    _mapAdapterState = null;
    _platformChannel = null;
  }

  void _setMethodChannel(MethodChannel channel) {
    _platformChannel = channel;
  }

  Future<void> switchToMapView() async {
    await _platformChannel?.invokeMethod('switchToMapView');
  }

  Future<void> switchToStreetView(double latitude, double longitude) async {
    await _platformChannel?.invokeMethod('switchToStreetView', {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Future<void> addMarker({
    required String id,
    required double latitude,
    required double longitude,
    String? title,
  }) async {
    try {
      await _platformChannel?.invokeMethod('addMarker', {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'title': title,
      });
    } catch (e) {
      print('Error adding marker: $e');
    }
  }

  Future<void> removeMarker(String id) async {
    try {
      await _platformChannel?.invokeMethod('removeMarker', {'id': id});
    } catch (e) {
      print('Error removing marker: $e');
    }
  }

  Future<void> updateMarker({
    required String id,
    double? latitude,
    double? longitude,
    String? title,
  }) async {
    try {
      await _platformChannel?.invokeMethod('updateMarker', {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'title': title,
      });
    } catch (e) {
      print('Error updating marker: $e');
    }
  }

  Future<void> moveCamera({
    required double latitude,
    required double longitude,
    double? zoom,
  }) async {
    await _platformChannel?.invokeMethod('moveCamera', {
      'latitude': latitude,
      'longitude': longitude,
      'zoom': zoom,
    });
  }

  Future<void> animateCamera({
    required double latitude,
    required double longitude,
    double? zoom,
  }) async {
    await _platformChannel?.invokeMethod('animateCamera', {
      'latitude': latitude,
      'longitude': longitude,
      'zoom': zoom,
    });
  }

  Future<void> setMapStyle(String styleJson) async {
    await _platformChannel?.invokeMethod('setMapStyle', {'styleJson': styleJson});
  }

  Future<void> setStreetViewRestrictions({
    required bool pan,
    required bool zoom,
    required bool nav,
  }) async {
    await _platformChannel?.invokeMethod('setStreetViewRestrictions', {
      'pan': pan,
      'nav': nav,
      'zoom': zoom,
    });
  }

  Future<void> setMapGesturesEnabled({
    required bool zoom,
    required bool scroll,
    required bool tilt,
    required bool rotate,
  }) async {
    await _platformChannel?.invokeMethod('setMapGesturesEnabled', {
      'zoom': zoom,
      'scroll': scroll,
      'tilt': tilt,
      'rotate': rotate,
    });
  }

  Future<void> setUIControls({
    required bool compassEnabled,
    required bool myLocationButtonEnabled,
  }) async {
    await _platformChannel?.invokeMethod('setUIControls', {
      'compassEnabled': compassEnabled,
      'myLocationButtonEnabled': myLocationButtonEnabled,
    });
  }

  Future<void> addPolyline({
    required String id,
    required List<Map<String, double>> points,
    int color = 0xFF0000FF,
  }) async {
    await _platformChannel?.invokeMethod('addPolyline', {
      'id': id,
      'points': points,
      'color': color,
    });
  }

  Future<void> addPolygon({
    required String id,
    required List<Map<String, double>> points,
    int fillColor = 0x550000FF,
    int strokeColor = 0xFF0000FF,
  }) async {
    await _platformChannel?.invokeMethod('addPolygon', {
      'id': id,
      'points': points,
      'fillColor': fillColor,
      'strokeColor': strokeColor,
    });
  }

  Future<void> removePolyline(String id) async {
    await _platformChannel?.invokeMethod('removePolyline', {'id': id});
  }

  Future<void> removePolygon(String id) async {
    await _platformChannel?.invokeMethod('removePolygon', {'id': id});
  }
}
