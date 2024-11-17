import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/text_input_field.dart';
import '../widgets/form_widgets/image_picker.dart';
import '../widgets/form_widgets/description_input_field.dart';
import '../widgets/form_widgets/date_picker.dart';
import '../widgets/start_button.dart';

class PetFormScreen extends StatefulWidget {
  @override
  _PetFormScreenState createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  File? _selectedImage;

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

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Agregado para permitir desplazamiento
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
                TextInputField(
                  labelText: 'Raza',
                  controller: _breedController,
                ),
                SizedBox(height: 16),
                TextInputField(
                  labelText: 'Especie',
                  controller: _speciesController,
                ),
                SizedBox(height: 16),
                TextInputField(
                  labelText: 'Color',
                  controller: _colorController,
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
                  onTap: _pickImage,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StartButton(onPressed:(){}, text: 'Guardar'),
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
