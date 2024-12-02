import 'package:flutter/material.dart';

class DescriptionInputField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionInputField({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 5, // Tamaño para descripciones medianas o largas
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: "Escribe una descripción detallada...",
        labelText: "Descripción",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa una descripción';
        }
        return null;
      },
    );
  }
}
