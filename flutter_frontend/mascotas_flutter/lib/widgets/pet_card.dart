// lib/widgets/pet_card.dart
import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String username;
  final String petName;
  final String status;
  final String imageUrl;
  final VoidCallback onTap; // Agregado

  const PetCard({
    required this.username,
    required this.petName,
    required this.status,
    required this.imageUrl,
    required this.onTap, // Agregado
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Llamamos al onTap aquí
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 250,
          child: Card(
            elevation: 4,
            shadowColor: Colors.grey.withOpacity(0.3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 90,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        image: DecorationImage(
                          image: AssetImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          username,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.more_vert, color: Colors.white),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    petName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Descripción breve de la mascota",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    width: 80,
                    decoration: BoxDecoration(
                      color:
                          status == "Perdido" ? Colors.redAccent : Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      status,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(color: Colors.grey[300]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.visibility, color: Colors.blueAccent),
                        onPressed: () {},
                        iconSize: 20,
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite_border,
                            color: Colors.blueAccent),
                        onPressed: () {},
                        iconSize: 20,
                      ),
                      IconButton(
                        icon: Icon(Icons.share, color: Colors.blueAccent),
                        onPressed: () {},
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
