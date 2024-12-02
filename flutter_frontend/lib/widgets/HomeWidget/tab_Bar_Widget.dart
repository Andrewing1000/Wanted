import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  final TabController tabController;

  TabBarWidget({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedBuilder(
        animation: tabController,
        builder: (context, _) {
          return TabBar(
            controller: tabController,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4.0, color: Colors.blueAccent),
              insets: EdgeInsets.symmetric(horizontal: 20.0),
            ),
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              _buildTab("Inicio", 0, tabController.index),
              _buildTab("Perdidos", 1, tabController.index),
              _buildTab("Encontrados", 2, tabController.index),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTab(String text, int index, int selectedIndex) {
    bool isSelected = index == selectedIndex;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(child: Text(text)),
    );
  }
}
