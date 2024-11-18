import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationPickerField extends StatefulWidget {
  final LatLng? initialLocation;
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
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  final MapController _mapController = MapController(); 
  bool _isLoading = false;
  bool _noResults = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation ?? LatLng(-16.5038, -68.1193); // La Paz
  }

  void _onMapTapped(LatLng point) {
    setState(() {
      _selectedLocation = point;
      _noResults = false;
    });
    widget.onLocationPicked(point);
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _noResults = false;
    });

    final url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _searchResults = data
              .map((result) => {
            "name": result["display_name"],
            "lat": double.parse(result["lat"]),
            "lon": double.parse(result["lon"]),
          })
              .toList();
          _isLoading = false;
          _noResults = _searchResults.isEmpty; // Indicar si no hay resultados
        });
      } else {
        setState(() {
          _isLoading = false;
          _noResults = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _noResults = true;
      });
    }
  }

  void _onSearchResultSelected(Map<String, dynamic> result) {
    final LatLng newLocation = LatLng(result["lat"], result["lon"]);
    setState(() {
      _selectedLocation = newLocation;
      _searchController.text = result["name"];
      _searchResults = [];
      _noResults = false;
    });
    _mapController.move(newLocation, 15.0);
    widget.onLocationPicked(newLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de ubicación
        Text(
          "Ubicación",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        // Barra de búsqueda
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: "Buscar ubicación",
            hintText: "Ej: Plaza Murillo, La Paz",
            border: OutlineInputBorder(),
            suffixIcon: _isLoading
                ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            )
                : IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _searchLocation(_searchController.text),
            ),
          ),
        ),
        // Resultados de búsqueda o mensaje de error
        if (_noResults)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Lugar no encontrado.",
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        if (_searchResults.isNotEmpty)
          Card(
            margin: EdgeInsets.only(top: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true, // Ajustar al contenido
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return ListTile(
                  leading: Icon(Icons.place, color: Colors.blue),
                  title: Text(result["name"], style: TextStyle(fontSize: 14)),
                  onTap: () => _onSearchResultSelected(result),
                );
              },
            ),
          ),
        SizedBox(height: 8),
        // Mapa interactivo
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FlutterMap(
            mapController: _mapController,
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
      ],
    );
  }
}
