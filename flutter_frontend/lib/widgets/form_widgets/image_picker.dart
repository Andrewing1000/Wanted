import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImagePickerField extends StatefulWidget {
  final Uint8List? selectedImage;
  final Function(Uint8List?) onImagePicked;

  const ImagePickerField({
    required this.selectedImage,
    required this.onImagePicked,
    Key? key,
  }) : super(key: key);

  @override
  _ImagePickerFieldState createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Comprimir la imagen
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          // Flutter Web: usa bytes
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            widget.onImagePicked(bytes);
          });
        } else {
          // Dispositivo nativo: usa File
          final fileBytes = await File(pickedFile.path).readAsBytes();
          setState(() {
            widget.onImagePicked(fileBytes);
          });
        }
      }
    } catch (e) {
      print("Error al seleccionar imagen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: widget.selectedImage == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, color: Colors.grey, size: 50),
            SizedBox(height: 8),
            Text("Escoger Imagen", style: TextStyle(color: Colors.grey)),
          ],
        )
            : kIsWeb
            ? Image.memory(
          widget.selectedImage!,
          fit: BoxFit.cover,
        )
            : Image.memory(
          widget.selectedImage!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
