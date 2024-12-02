import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:latlong2/latlong.dart';
import 'package:mascotas_flutter/Services/MapAdapter.dart';

import '../Services/Pet_Service.dart';
import '../widgets/DecimalInputField.dart';
import '../widgets/DropDownField.dart';
import '../widgets/Maps/location_picker_field.dart';
import '../widgets/form_widgets/date_picker.dart';
import '../widgets/form_widgets/description_input_field.dart';
import '../widgets/form_widgets/image_picker.dart';
import '../widgets/text_input_field.dart';
import '../widgets/start_button.dart';

class PetFormScreen extends StatefulWidget {
  @override
  _PetFormScreenState createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final Mascotas petService = Mascotas();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();
  final MapAdapterController _mapController = MapAdapterController();
  // Form State
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Dropdown Selections
  int? _selectedBreedId;
  int? _selectedSpecieId;

  double _selected_lat = 0;
  double _selected_lon = 0;
  // Others
  Color _currentColor = Colors.black;
  DateTime? _selectedDate;
  LatLng? _selectedLocation;

  List<Uint8List> selectedImages = [];

  void _updateImages(List<Uint8List> images) {
    setState(() {
      selectedImages = images;
    });
  }

  // Helper methods
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Seleccione el color',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _currentColor,
            onColorChanged: (color) => setState(() => _currentColor = color),
            enableAlpha: false,
            portraitOnly: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Confirmar',
              style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _onLocationPicked(double lat, double long) {
    setState(() {
      _mapController.removeMarker("1");
      _selected_lat = lat;
      _selected_lon = long;
      _mapController.addMarker(id: "1", latitude: _selected_lat, longitude: _selected_lon);
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Show saving message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guardando mascota...')),
      );

      // Format date
      final String formattedDate =
          '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

      // Ensure valid color format
      String hexColor =
          _currentColor.toHexString(includeHashSign: false, enableAlpha: false);
      if (hexColor.length == 8) hexColor = hexColor.substring(2);

      // Call API
      final response = await petService.registerPet(
        petName: _nameController.text.trim(),
        species: _selectedSpecieId!,
        breed: _selectedBreedId!,
        color: hexColor,
        description: _descriptionController.text.trim(),
        dateLost: formattedDate,
        lat: round(_selected_lat, decimals: 5),
        long: round(_selected_lon, decimals: 5),
        rewardAmount: double.parse(_rewardController.text.trim()),
      );

      for(var image in selectedImages){
        var res = await petService.uploadPetPhoto(petId: response['id'], photoBytes: image);
      }

      // Show response to user
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(response)),
      // );
    } else {
      // Show error message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos requeridos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define consistent text styles
    final TextStyle labelStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.grey[800]);
    final TextStyle buttonTextStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: Colors.black,);
    final EdgeInsets fieldPadding = const EdgeInsets.symmetric(vertical: 8.0);

    return Scaffold(
      appBar: AppBar(title: Text('Reportar Mascota Perdida')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Unified padding
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align to start
            children: [
              // Name Field
              Padding(
                padding: fieldPadding,
                child: Text('Nombre de la Mascota', style: labelStyle),
              ),
              TextInputField(
                labelText: "Nombre",
                controller: _nameController,
              ),
              SizedBox(height: 16),

              // Breed Dropdown
              
              DropdownField(
                labelText: 'Raza',
                fetchItems: petService.fetchBreeds,
                onChanged: (value) => setState(() => _selectedBreedId = value),
              ),
              SizedBox(height: 16),

              // Species Dropdown
              
              DropdownField(
                labelText: 'Especie',
                fetchItems: petService.fetchSpecies,
                onChanged: (value) => setState(() => _selectedSpecieId = value),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  ElevatedButton(
                    onPressed: _openColorPicker,
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Seleccionar Color', style: labelStyle),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _currentColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Reward Input
              Padding(
                padding: fieldPadding,
                child: Text('Recompensa', style: labelStyle),
              ),
              RealNumberInputField(
                controller: _rewardController,
                labelText: "Recompensa",
              ),
              SizedBox(height: 16),

              // Date Picker
              Padding(
                padding: fieldPadding,
                child: Text('Fecha de Pérdida', style: labelStyle),
              ),
              DatePickerField(
                selectedDate: _selectedDate,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 16),

              // Description Input
              Padding(
                padding: fieldPadding,
                child: Text('Descripción', style: labelStyle),
              ),
              DescriptionInputField(
                controller: _descriptionController,
              ),
              SizedBox(height: 16),

              // Image Picker
              Padding(
                padding: fieldPadding,
                child: Text('Fotos', style: labelStyle),
              ),
              ImageGallery(
                onImagesChanged: _updateImages,
              ),
              const SizedBox(height: 16),

              // Location Picker
              Padding(
                padding: fieldPadding,
                child: Text('Ubicación', style: labelStyle),
              ),
              MapAdapter(
                controller: _mapController,
                onMapClick: _onLocationPicked,
              ),
              const SizedBox(height: 24),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Guardar', style: buttonTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
