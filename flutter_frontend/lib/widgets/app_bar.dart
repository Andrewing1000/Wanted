import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  CustomAppBar({Key? key, required this.tabController})
      : preferredSize = const Size.fromHeight(110.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          "Bienvenido a Find you're pet,go!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TabBar(
            controller: tabController,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4.0, color: Colors.blueAccent), // Línea gruesa debajo de la pestaña
              insets: EdgeInsets.symmetric(horizontal: 20.0), // Margen de la línea
            ),
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              _buildTab("Inicio", 0),
              _buildTab("Perdidos", 1),
              _buildTab("Encontrados", 2),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir las pestañas con fondo dinámico
  Widget _buildTab(String text, int index) {
    bool isSelected = tabController.index == index;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.transparent, // Fondo más claro para la pestaña seleccionada
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(child: Text(text)),
    );
  }
}
