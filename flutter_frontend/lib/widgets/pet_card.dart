import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String username;
  final String petName;
  final String status;
  final String imageUrl;
  final String dateLost;
  final String rewardAmount;
  final VoidCallback onTap;

  const PetCard({
    required this.username,
    required this.petName,
    required this.status,
    required this.imageUrl,
    required this.dateLost,
    required this.rewardAmount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/placeholder.png', fit: BoxFit.cover, height: 120, width: double.infinity),
                    )
                  : Image.asset('assets/placeholder.png', fit: BoxFit.cover, height: 120, width: double.infinity),
            ),
            // Contenido de texto
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre de la mascota
                  Text(
                    petName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,  // Evitar desbordamiento de texto largo
                  ),
                  // Usuario
                  Text(
                    "Usuario: $username",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,  // Evitar desbordamiento de texto largo
                  ),
                  // Fecha de extravío
                  Text(
                    "Fecha de Extravío: $dateLost",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,  // Evitar desbordamiento de texto largo
                  ),
                  // Recompensa
                  Text(
                    "Recompensa: \$ $rewardAmount",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,  // Evitar desbordamiento de texto largo
                  ),
                  // Estado (Perdido o Encontrado)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: status == "Perdido" ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
