import 'package:flutter/material.dart';
import '../login.dart';
import '../Services/auth.dart';
import 'home_page.dart';
import 'form_page.dart';
import '../widgets/manage_screen_widgets/main_app_bar.dart';
import '../widgets/manage_screen_widgets/bottom_naviagation_bar.dart';
import 'testing/test_widgets.dart';
import 'UserMe/VIewProfileScreen.dart';
import 'UserMe/UserMe.dart'; // Pantalla para editar datos

class ManagerScreen extends StatefulWidget {
  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  int _currentIndex = 0; // Índice de la página actual
  final PageController _pageController =
      PageController(); // Controlador de páginas
  final AuthService _authService = AuthService();
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  /// Cargar el nombre del usuario
  Future<void> _loadUserName() async {
    final name = await _authService.getUserName();
    setState(() {
      userName = name ?? 'Usuario';
    });
  }

  /// Cambiar a la página seleccionada
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: 'Find You\'re Pet, go!',
        userName: userName,
        onLogout: () async {
          await _authService.logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(),
          WidgetsTestScreen(),
          PetFormScreen(),
          Center(child: Text('Avistamientos Creados')),
          ViewProfileScreen(
              onEdit: _navigateToEditScreen), // Cambia para usar `onEdit`
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  /// Navegar a la pantalla de edición desde `ViewProfileScreen`
  void _navigateToEditScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForMeScreen(),
      ),
    ).then((_) {
      // Al regresar de la pantalla de edición, recargar el nombre del usuario
      _loadUserName();
    });
  }
}
