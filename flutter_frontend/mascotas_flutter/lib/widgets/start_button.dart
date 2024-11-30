import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' as google_fonts;

class StartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const StartButton({
    required this.onPressed,
    required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5C6BC0), // Color del botón
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: google_fonts.GoogleFonts.poppins(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
