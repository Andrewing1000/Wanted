import 'package:flutter/material.dart';
import 'package:mascotas_flutter/widgets/Logo.dart';
import 'widgets/titles.dart';
import 'widgets/start_button.dart';
import 'login.dart';
import 'Services/MapAdapter.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  State<WelcomeScreen> createState(){
    return WelcomeScreenState();
  }
}

class WelcomeScreenState extends State<WelcomeScreen>{

  bool streetMode = false;
  final MapAdapterController _mapController = MapAdapterController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  // Request location permission using permission_handler
  void _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  void _toggleStreetMode() {
    if (streetMode) {
      _mapController.switchToMapView();
    } else {
      _mapController.switchToStreetView(37.7749, -122.4194);
    }
    setState(() {
      streetMode = !streetMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F0F3),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoWidget(),
              SizedBox(height: 20),
              TitleWidget(),
              SizedBox(height: 15),
              SubtitleWidget(),
              SizedBox(height: 30),
              StartButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LoginScreen(),
                      transitionsBuilder: (_, anim, __, child) {
                        return FadeTransition(opacity: anim, child: child);
                      },
                    ),
                  );
                }, 
                text: 'Empezar',
              ),
              SizedBox(height: 20),
              // Toggle Button for Map and Street View
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16), // Button color
                ),
                child: Icon(
                  streetMode ? Icons.map : Icons.streetview,
                  color: Colors.white,
                ), 
                onPressed: _toggleStreetMode,
              ),
              SizedBox(height: 20),
              // Expanded MapAdapter to take remaining space
              Expanded(
                child: MapAdapter(
                  controller: _mapController,
                  initialCameraPosition: {
                    'latitude': 37.7749,
                    'longitude': -122.4194,
                    'zoom': 12.0,
                  },
                  onMapClick: _handleMapClick,
                  onMarkerClick: _handleMarkerClick,
                  onCameraIdle: _handleCameraIdle,
                  onStreetViewChange: _handleStreetViewChange,
                ),
              ),
            ],
          ),
        ),
      ),
      // Optional Floating Action Button to add a marker
      floatingActionButton: FloatingActionButton(
        onPressed: _addMarker,
        child: Icon(Icons.add_location),
      ),
    );
  }

  // Callback methods
  void _handleMapClick(double latitude, double longitude) {
    print('Map clicked at: $latitude, $longitude');
    _mapController.addMarker(
      id: 'marker_${DateTime.now().millisecondsSinceEpoch}',
      latitude: latitude,
      longitude: longitude,
      title: 'New Marker',
    );
  }

  void _handleMarkerClick(String markerId) {
    print('Marker clicked: $markerId');
    // Optionally, remove the marker
    _mapController.removeMarker(markerId);
  }

  void _handleCameraIdle(double latitude, double longitude, double zoom) {
    print('Camera idle at: $latitude, $longitude with zoom $zoom');
  }

  void _handleStreetViewChange(double latitude, double longitude) {
    print('Street View changed to: $latitude, $longitude');
  }

  // Methods to interact with the map
  void _addMarker() {
    _mapController.addMarker(
      id: 'marker_${DateTime.now().millisecondsSinceEpoch}',
      latitude: 37.7749,
      longitude: -122.4194,
      title: 'San Francisco',
    );
  }

  void _switchToStreetView() {
    _mapController.switchToStreetView(
      37.7749,
      -122.4194,
    );
  }
}
