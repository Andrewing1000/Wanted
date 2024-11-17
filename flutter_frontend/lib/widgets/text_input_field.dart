import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController controller;

  const TextInputField({
    required this.labelText,
    required this.controller,
    this.hintText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
