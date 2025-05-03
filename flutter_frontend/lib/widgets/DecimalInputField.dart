import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RealNumberInputField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController controller;
  final int? decimalPlaces;

  const RealNumberInputField({
    required this.labelText,
    required this.controller,
    this.hintText,
    this.decimalPlaces,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          _realNumberRegex(),
        ),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Returns a RegExp to allow real numbers with an optional precision limit.
  RegExp _realNumberRegex() {
    if (decimalPlaces != null) {
      return RegExp(r'^-?\d*(\.\d{0,' + decimalPlaces.toString() + r'})?$');
    }
    return RegExp(r'^-?\d*\.?\d*$'); // Allows unlimited decimal places.
  }
}
