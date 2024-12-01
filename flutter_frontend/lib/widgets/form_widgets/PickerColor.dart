import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class PickerColor extends StatefulWidget {
  final String labelText;
  final TextEditingController colorController;

  const PickerColor({
    Key? key,
    required this.labelText,
    required this.colorController,
  }) : super(key: key);

  @override
  _PickerColorState createState() => _PickerColorState();
}

class _PickerColorState extends State<PickerColor> {
  Color _selectedColor = Colors.blue; // Color inicial por defecto

  /// Convierte un color a su representación hexadecimal
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  void _openColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.labelText),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });

                // Imprimir el color seleccionado en formato hexadecimal
                print('Color seleccionado: ${_colorToHex(color)}');
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Actualizamos el controlador con el valor hexadecimal
                widget.colorController.text = _colorToHex(_selectedColor);
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openColorPickerDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: _selectedColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black54),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.labelText,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              widget.colorController.text.isEmpty
                  ? 'Seleccionar color'
                  : widget.colorController.text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
