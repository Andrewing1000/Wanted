import 'package:flutter/material.dart';

class PetDetailsSection extends StatelessWidget {
  final Map<String, dynamic> pet;
  final String? breedName;
  final String? speciesName;

  const PetDetailsSection({
    Key? key,
    required this.pet,
    this.breedName,
    this.speciesName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String colorHex = pet['color'] ?? '#FFFFFF';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pet['pet_name'] ?? 'Nombre desconocido',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Especie: ${speciesName ?? 'Desconocida'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Raza: ${breedName ?? 'Desconocida'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Color:', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: _hexToColor(colorHex),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black26),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Descripción:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          pet['description'] ?? 'Sin descripción',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Text(
          'Fecha de pérdida: ${pet['date_lost'] ?? 'Desconocida'}',
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}
