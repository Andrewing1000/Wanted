import 'package:flutter/material.dart';
import 'dart:io';

class ImagePickerField extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onTap;

  const ImagePickerField({
    required this.selectedImage,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: selectedImage == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, color: Colors.grey, size: 50),
            SizedBox(height: 8),
            Text("Escoger Imagen", style: TextStyle(color: Colors.grey)),
          ],
        )
            : Image.file(selectedImage!, fit: BoxFit.cover),
      ),
    );
  }
}
