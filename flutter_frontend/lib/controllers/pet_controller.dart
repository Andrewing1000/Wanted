import 'package:flutter/material.dart';
import '../services/PetFind.dart';
import '../widgets/petDetailsModal.dart';

class PetController {
  final PetFindService petFindService = PetFindService();

  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  List<Map<String, dynamic>> petData = [];
  List<Map<String, dynamic>> sightingsData = [];
  List<Map<String, dynamic>> filteredPetData = [];

  Future<void> fetchInitialData() async {
    isLoading.value = true;

    try {
      final lostPets = await petFindService.fetchLostPetsWithStatus();
      final sightings = await petFindService.fetchEnrichedSightings();

      petData = lostPets.where((pet) => pet['status'] == 'Perdido').toList();
      sightingsData = sightings.where((sighting) => sighting['status'] == 'Visto').toList();
      filteredPetData = List.from(petData + sightingsData);
    } catch (e) {
      print('Error al cargar los datos iniciales: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showPetDetailsModal(BuildContext context, Map<String, dynamic> pet) {
    showDialog(
      context: context,
      builder: (context) {
        return PetDetailsModal(pet: pet);
      },
    );
  }
}
