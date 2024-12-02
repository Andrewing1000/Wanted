import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' as google_fonts;

class TitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Busca a tu mascota con\nFind you’re pet, go!',
      textAlign: TextAlign.center,
      style: google_fonts.GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class SubtitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Encuentra a tu mascota con Find you’re pet, go!\nCon nuestro increíble servicio de Google Maps y\nrealidad aumentada ahora estás más cerca\nde encontrar a tu mascota.',
      textAlign: TextAlign.center,
      style: google_fonts.GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black54,
      ),
    );
  }
}

