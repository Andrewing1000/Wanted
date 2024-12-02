import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final String labelText;
  final Future<List<Map<String, dynamic>>> Function() fetchItems;
  final Function(int?) onChanged;
  final int? initialValue;

  const DropdownField({
    required this.labelText,
    required this.fetchItems,
    required this.onChanged,
    this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  List<Map<String, dynamic>> _items = [];
  int? _selectedId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final items = await widget.fetchItems();
      setState(() {
        _items = items;
        _selectedId = widget.initialValue;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error al cargar items: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 8),
        _isLoading
            ? const CircularProgressIndicator()
            : DropdownButton<int>(
          isExpanded: true,
          value: _selectedId,
          hint: Text("Seleccione ${widget.labelText.toLowerCase()}"),
          items: _items.map((item) {
            return DropdownMenuItem<int>(
              value: item['id'] as int,
              child: Text(item['value'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedId = value;
            });
            widget.onChanged(value);
          },
        ),
      ],
    );
  }
}
