import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../services/Pet_Service.dart';
import '../services/PetFind.dart';
import '../widgets/form_widgets/date_picker.dart';
import '../widgets/form_widgets/description_input_field.dart';
import '../widgets/Maps/location_picker_field.dart';
import '../widgets/text_input_field.dart';
import '../widgets/start_button.dart';

class PetSightingScreen extends StatefulWidget {
  final Map<String, dynamic> pet;

  const PetSightingScreen({Key? key, required this.pet}) : super(key: key);

  @override
  _PetSightingScreenState createState() => _PetSightingScreenState();
}

class _PetSightingScreenState extends State<PetSightingScreen> {
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();

    // Inicializar los controladores con los valores del pet
    _speciesController.text = widget.pet['species']?.toString() ?? 'Desconocida';
    _breedController.text = widget.pet['breed']?.toString() ?? 'Desconocida';
    _colorController.text = widget.pet['color'] ?? 'Desconocido';
    _descriptionController.text = widget.pet['description'] ?? 'Sin descripción';
    _selectedLocation = LatLng(
      double.tryParse(widget.pet['latitude'] ?? '0.0') ?? 0.0,
      double.tryParse(widget.pet['longitude'] ?? '0.0') ?? 0.0,
    );
  }

  /// Método para seleccionar una fecha
  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  /// Guardar el avistamiento
  void _saveSighting() async {
    if (_selectedDate == null || _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona una fecha y ubicación')),
      );
      return;
    }

    final petFindService = PetFindService();
    final petService = Mascotas();

    final sightingData = {
      "species": widget.pet['species'],
      "breed": widget.pet['breed'],
      "color": widget.pet['color'],
      "description": widget.pet['description'],
      "date_sighted": _selectedDate!.toIso8601String(),
      "latitude": _selectedLocation!.latitude.toString(),
      "longitude": _selectedLocation!.longitude.toString(),
    };

    try {
      // Crear avistamiento
      final result = await petFindService.createPetSighting(
        species: sightingData["species"],
        breed: sightingData["breed"],
        color: sightingData["color"],
        description: sightingData["description"],
        dateSighted: sightingData["date_sighted"],
        latitude: sightingData["latitude"],
        longitude: sightingData["longitude"],
      );

      // Eliminar mascota perdida
      await petService.deleteLostPet(widget.pet['id']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );

      Navigator.pop(context, result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el avistamiento: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generar Avistamiento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campos no editables
            TextInputField(
              labelText: 'Especie',
              controller: _speciesController,
            ),
            const SizedBox(height: 16),
            TextInputField(
              labelText: 'Raza',
              controller: _breedController,
            ),
            const SizedBox(height: 16),
            TextInputField(
              labelText: 'Color',
              controller: _colorController,
            ),
            const SizedBox(height: 16),
            DescriptionInputField(
              controller: _descriptionController,
            ),
            const SizedBox(height: 16),

            // Selección de fecha
            DatePickerField(
              selectedDate: _selectedDate,
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),

            // Selección de ubicación
            LocationPickerField(
              initialLocation: _selectedLocation,
              onLocationPicked: (location) {
                setState(() {
                  _selectedLocation = location;
                });
              },
            ),
            const SizedBox(height: 24),

            // Botón de Guardar
            Center(
              child: StartButton(
                onPressed: _saveSighting,
                text: "Guardar Avistamiento",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
