import 'package:flutter/material.dart';
import 'package:mascotas_flutter/widgets/petDetailsModal.dart';
import 'package:mascotas_flutter/widgets/pet_card.dart';
import '../services/petme_service.dart';

class PetMePage extends StatefulWidget {
  @override
  _PetMePageState createState() => _PetMePageState();
}

class _PetMePageState extends State<PetMePage> with SingleTickerProviderStateMixin {
  final Historial _historialService = Historial();

  List<Map<String, dynamic>> petData = [];
  List<Map<String, dynamic>> filteredPetData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserPets();
  }

  @override


  Future<void> _fetchUserPets() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _historialService.filtrarMascotasPorUsuario();
      setState(() {
        petData = data;
        filteredPetData = List.from(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar mascotas: $e')),
      );
    }
  }

//MODAL
  void showPetDetailsModal(BuildContext context, Map<String, dynamic> pet) {
    showDialog(
      context: context,
      builder: (context) {
        return PetDetailsModal(pet: pet);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Mis Mascotas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _fetchUserPets,
              child: petData.isEmpty
                  ? ListView(
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Text(
                        "No tienes mascotas registradas.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              )
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredPetData.length,
                itemBuilder: (context, index) {
                  final pet = filteredPetData[index];
                  return PetCard(
                    username: pet['user'] ?? 'Usuario desconocido',
                    petName: pet['pet_name'] ?? 'Autor desconocido',
                    status: 'Perdido',
                    imageUrl: pet['photo'] ?? 'assets/dummy.jpg',
                    dateLost: pet['date_lost'] ?? 'Fecha desconocida',
                    rewardAmount: pet['reward_amount'] ?? '0.00',
                    onTap: () => showPetDetailsModal(context, pet),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
