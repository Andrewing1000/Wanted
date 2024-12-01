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
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Actualizamos el controlador con el valor RGB
                widget.colorController.text =
                'RGB(${_selectedColor.red}, ${_selectedColor.green}, ${_selectedColor.blue})';
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
