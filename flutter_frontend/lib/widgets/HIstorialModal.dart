import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
//Servicios
import '../services/pet_service.dart';
//Widgets
import '../widgets/Maps/live_map.dart';
import '../widgets/DropDownField.dart';
import '../widgets/form_widgets/PickerColor.dart';
import '../widgets/text_input_field.dart';
import '../widgets/form_widgets/description_input_field.dart';
import '../widgets/form_widgets/date_picker.dart';
import '../Services/Delete_pets.dart';


class HistorialModal extends StatefulWidget {
  final Map<String, dynamic> pet;

  const HistorialModal({Key? key, required this.pet}) : super(key: key);

  @override
  _HistorialModalState createState() => _HistorialModalState();
}

class _HistorialModalState extends State<HistorialModal> {
  final Mascotas petService = Mascotas();

  final TextEditingController _nameController = TextEditingController();
  int? _selectedBreedId;
  int? _selectedSpecieId;
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  LatLng? _selectedLocation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPetDetails();
  }

  Future<void> _loadPetDetails() async {
    try {
      // Cargar las listas de razas y especies desde el servicio
      final breeds = await petService.fetchBreeds();
      final species = await petService.fetchSpecies();

      // Configurar datos iniciales en los campos
      setState(() {
        _nameController.text = widget.pet['pet_name'] ?? '';
        _selectedBreedId = widget.pet['breed'];
        _selectedSpecieId = widget.pet['species'];
        _colorController.text = widget.pet['color'] ?? '';
        _descriptionController.text = widget.pet['description'] ?? '';
        _rewardController.text = widget.pet['reward_amount'] ?? '';
        _selectedDate = DateTime.parse(widget.pet['date_lost']);
        _selectedLocation = LatLng(
          double.tryParse(widget.pet['latitude'] ?? '') ?? 0.0,
          double.tryParse(widget.pet['longitude'] ?? '') ?? 0.0,
        );
      });
    } catch (e) {
      print("Error al cargar detalles de la mascota: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate() && _selectedLocation != null && _selectedDate != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guardando cambios...')),
      );

      // Formatear la fecha
      final String formattedDate =
          '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

      // Llamar al servicio para actualizar la mascota
      try {
        final response = await petService.updatePet(
          petId: widget.pet['id'],
          petName: _nameController.text.trim(),
          species: _selectedSpecieId!,
          breed: _selectedBreedId!,
          color: _colorController.text.trim(),
          description: _descriptionController.text.trim(),
          photo: null, // Imagen no implementada
          dateLost: formattedDate,
          lat: _selectedLocation!.latitude.toString(),
          long: _selectedLocation!.longitude.toString(),
          rewardAmount: _rewardController.text.trim(),
        );


        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cambios guardados: $response')),
        );
        Navigator.pop(context); // Cerrar el modal
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar los cambios: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.grey.withOpacity(1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInputField(
                  labelText: 'Nombre de la Mascota',
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                DropdownField(
                  labelText: "Raza",
                  fetchItems: petService.fetchBreeds,
                  initialValue: _selectedBreedId,
                  onChanged: (value) {
                    setState(() {
                      _selectedBreedId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownField(
                  labelText: "Especie",
                  fetchItems: petService.fetchSpecies,
                  initialValue: _selectedSpecieId,
                  onChanged: (value) {
                    setState(() {
                      _selectedSpecieId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                PickerColor(
                  labelText: 'Color',
                  colorController: _colorController,
                ),
                const SizedBox(height: 16),
                TextInputField(
                  labelText: 'Recompensa',
                  controller: _rewardController,
                ),
                const SizedBox(height: 16),
                Text("Fecha de Extravio"),
                const SizedBox(height: 8),
                DatePickerField(
                  selectedDate: _selectedDate,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 16),
                DescriptionInputField(
                  controller: _descriptionController,
                ),
                const SizedBox(height: 16),
                Text("Ubicación"),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: LiveMap(
                    coordinateStream: Stream.value(_selectedLocation!),
                    markerBuilder: (context, position) => Icon(
                      Icons.pets,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _saveChanges,
                      child: const Text(
                        "Guardar Cambios",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cerrar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // Botón para eliminar publicación
                    // Botón de Eliminar
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _deletePost(context); // Llamada a la función para eliminar la publicación
                      },
                      child: const Text(
                        "Eliminar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

// Botón para marcar como Encontrado
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _markAsFound(context); // Llamada a la función para marcar como encontrado
                      },
                      child: const Text(
                        "Encontrado",
                        style: TextStyle(color: Colors.white),
                      ),
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
