import 'package:flutter/material.dart';
import '../widgets/pet_card.dart';

class PetGrid extends StatelessWidget {
  final List<Map<String, dynamic>> petData;
  final Function(Map<String, dynamic>) onPetSelected;

  const PetGrid({
    Key? key,
    required this.petData,
    required this.onPetSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (petData.isEmpty) {
      return ListView(
        children: const [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: Text(
                "No hay información disponible.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ],
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: petData.length,
      itemBuilder: (context, index) {
        final pet = petData[index];
        return PetCard(
          username: pet['user']?.toString() ?? 'Usuario desconocido',
          petName: pet['pet_name'] ?? 'Sin nombre',
          status: pet['status'] ?? 'Desconocido',
          imageUrl: pet['photo'] ?? 'assets/dummy.jpg',
          dateLost: pet['creation_date'] ?? 'Fecha desconocida',
          rewardAmount: pet['reward_amount'] ?? 'No aplica',
          onTap: () => onPetSelected(pet),
        );
      },
    );
  }
}
