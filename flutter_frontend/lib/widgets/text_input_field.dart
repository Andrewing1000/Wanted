import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final bool isPassword;

  const TextInputField({
    required this.labelText,
    this.hintText,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: isPassword ? Icon(Icons.visibility_off) : null,
      ),
    );
  }
}
