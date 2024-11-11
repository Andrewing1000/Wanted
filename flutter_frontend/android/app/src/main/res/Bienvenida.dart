import 'package:flutter/material.dart';

void main() {
  runApp(FindYourPetApp());
}

class FindYourPetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find Your Pet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F0F3), // Color de fondo similar al de la imagen
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/paw_logo.png', // Asegúrate de tener la imagen en la carpeta assets
                height: 80.0,
              ),
              SizedBox(height: 20),
              Text(
                'Busca a tu mascota con\nFind you’re pet, go!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Encuentra a tu mascota con Find you’re pet, go!\nCon nuestro increíble servicio de Google Maps y\nrealidad aumentada ahora estás más cerca\nde encontrar a tu mascota.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Aquí puedes manejar la navegación cuando se presiona el botón
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5C6BC0), // Color del botón
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Empezar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
