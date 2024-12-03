import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? userName;
  final VoidCallback onLogout;

  const MainAppBar({
    required this.title,
    required this.onLogout,
    this.userName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Elimina la flecha de retroceso
      backgroundColor: Color(0xFFE6F0F3), // Fondo azul claro
      elevation: 0, // Sin sombra
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Título principal
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent, // Color azul
              fontFamily: 'Poppins',
            ),
          ),
          // Nombre del usuario y botón de logout
          Row(
            children: [
              if (userName != null)
                Text(
                  '$userName',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800], // Color gris oscuro
                    fontWeight: FontWeight.w600,
                  ),
                ),
              SizedBox(width: 8), // Espacio entre el texto y el ícono
              IconButton(
                icon: Icon(
                  Icons.logout, // Ícono de logout
                  color: Colors.grey[800],
                ),
                onPressed: onLogout, // Llama al callback onLogout
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0); // Altura estándar
}
