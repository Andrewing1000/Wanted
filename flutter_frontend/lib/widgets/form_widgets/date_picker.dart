import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DatePickerField({
    required this.selectedDate,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
          hintText: 'Selecciona la fecha',
        ),
        child: Text(
          selectedDate == null
              ? 'MM/DD/YYYY'
              : '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
