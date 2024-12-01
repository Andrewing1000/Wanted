import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mascotas_flutter/widgets/form_widgets/PickerColor.dart';
import 'dart:typed_data'; // Para Uint8List
import '../widgets/DropDownField.dart';
import '../widgets/form_widgets/image_picker.dart';
import '../widgets/Maps/location_picker_field.dart';
import '../widgets/text_input_field.dart';
import '../widgets/form_widgets/description_input_field.dart';
import '../widgets/form_widgets/date_picker.dart';
import '../widgets/start_button.dart';
import '../Services/Pet_Service.dart';

class PetFormScreen extends StatefulWidget {
  @override
  _PetFormScreenState createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final Mascotas petService = Mascotas();
  final TextEditingController _nameController = TextEditingController();
  int? _selectedBreedId;
  int? _selectedSpecieId;
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  Uint8List? _selectedImage;
  LatLng? _selectedLocation;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onImagePicked(Uint8List? imageBytes) {
    setState(() {
      _selectedImage = imageBytes;
    });
  }

  void _onLocationPicked(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInputField(
                  labelText: 'Nombre de la Mascota',
                  controller: _nameController,
                ),
                SizedBox(height: 16),
                DropdownField(
                  labelText: "Raza",
                  fetchItems: petService.fetchBreeds,
                  onChanged: (value) {
                    setState(() {
                      _selectedBreedId = value;
                    });
                  },
                ),
                SizedBox(height: 16),

                DropdownField(
                  labelText: "Especie",
                  fetchItems: petService.fetchSpecies,
                  onChanged: (value) {
                    setState(() {
                      _selectedSpecieId = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                PickerColor(labelText: 'Color',
                    colorController: _colorController
                ),
                SizedBox(height: 16),
                TextInputField(
                  labelText: 'Recompensa',
                  controller: _rewardController,
                ),
                SizedBox(height: 16),
                Text("Fecha de Extravio"),
                SizedBox(height: 8),
                DatePickerField(
                  selectedDate: _selectedDate,
                  onTap: () => _selectDate(context),
                ),
                SizedBox(height: 16),
                DescriptionInputField(
                  controller: _descriptionController,
                ),
                SizedBox(height: 16),
                Text("Subir Imagen"),
                SizedBox(height: 8),
                ImagePickerField(
                  selectedImage: _selectedImage,
                  onImagePicked: _onImagePicked,
                ),
                SizedBox(height: 16),
                LocationPickerField(
                  initialLocation:  LatLng(-16.5038, -68.1193),
                  onLocationPicked: _onLocationPicked
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StartButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _selectedLocation != null &&
                            _selectedDate != null) {
                          // Mostrar mensaje de guardado
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Guardando mascota...')),
                          );

                          // Si no hay imagen seleccionada, se asigna null
                          final String? base64Image = _selectedImage != null
                              ? base64Encode(_selectedImage!)
                              : null;

                          // Formatear la fecha a `YYYY-MM-DD`
                          final String formattedDate =
                              '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

                          // Llamar a la función `registerPet`
                          final petService = Mascotas();
                          final response = await petService.registerPet(
                            petName: _nameController.text.trim(),
                            species: _selectedSpecieId!.toInt(),
                            breed: _selectedBreedId!.toInt(),
                            color: _colorController.text.trim(),
                            description: _descriptionController.text.trim(),
                            photo: base64Image,
                            dateLost: formattedDate,
                            lat: '${_selectedLocation!.latitude}',
                            long:'${_selectedLocation!.longitude}',
                            rewardAmount: _rewardController.text.trim(),
                          );

                          // Mostrar respuesta del servidor al usuario
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response)),
                          );
                        } else {
                          // Mostrar mensaje de error si no se completaron todos los campos
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Por favor, completa todos los campos requeridos.'),
                            ),
                          );
                        }
                      },
                      text: 'Guardar',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
