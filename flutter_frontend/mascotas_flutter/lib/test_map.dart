import 'package:flutter/material.dart';
import 'dart:io';
import 'Services/MapAdapter.dart';

class CreateMarkerPage extends StatefulWidget {
  final MapAdapterController mapController;

  const CreateMarkerPage({Key? key, required this.mapController})
      : super(key: key);

  @override
  State<CreateMarkerPage> createState() => _CreateMarkerPageState();
}

class _CreateMarkerPageState extends State<CreateMarkerPage> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  File? _photo;
  double? _selectedLatitude;
  double? _selectedLongitude;
  bool _isStreetViewAvailable = false;

  void _pickImage() async {
    // Aquí puedes usar un paquete como image_picker para implementar la selección de imágenes
    setState(() {
      _photo = File('path_to_dummy_image');
    });
  }

  void _onMapClick(double latitude, double longitude) {
    setState(() {
      _selectedLatitude = latitude;
      _selectedLongitude = longitude;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Seleccionado: ($latitude, $longitude)'),
    ));
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _selectedLatitude != null &&
        _selectedLongitude != null) {
      _formKey.currentState!.save();
      widget.mapController.addMarker(
        id: DateTime.now().toString(),
        latitude: _selectedLatitude!,
        longitude: _selectedLongitude!,
        title: _description,
      );
      setState(() {
        _isStreetViewAvailable = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Marcador creado correctamente'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, completa el formulario y selecciona un punto en el mapa'),
      ));
    }
  }

  void _switchToStreetView() {
    if (_selectedLatitude != null && _selectedLongitude != null) {
      widget.mapController.switchToStreetView(
        _selectedLatitude!,
        _selectedLongitude!,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cambiando a Street View...'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Marcador')),
      body: Column(
        children: [
          Expanded(
            child: MapAdapter(
              controller: widget.mapController,
              onMapClick: _onMapClick,
              initialCameraPosition: {
                'latitude': 37.7749,
                'longitude': -122.4194,
                'zoom': 12.0,
              },
            ),
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Subir Foto'),
                  ),
                  const SizedBox(height: 10),
                  if (_photo != null)
                    Text('Foto seleccionada: ${_photo!.path}'),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La descripción es obligatoria';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value ?? '';
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Crear Marcador'),
                  ),
                  if (_isStreetViewAvailable)
                    ElevatedButton(
                      onPressed: _switchToStreetView,
                      child: const Text('Ir a Street View'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
