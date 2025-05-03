import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  final TabController tabController;

  TabBarWidget({Key? key, required this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
