import 'package:flutter/material.dart';
import '../login.dart';
import '../Services/auth.dart';
import 'home_page.dart';
import 'form_page.dart';
import '../widgets/manage_screen_widgets/main_app_bar.dart';
import '../widgets/manage_screen_widgets/bottom_naviagation_bar.dart';

class ManagerScreen extends StatefulWidget {
  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController();
  final AuthService _authService = AuthService();
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await _authService.getUserName();
    setState(() {
      userName = name ?? 'Usuario';
    });
  }


  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
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
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginScreen(),
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(opacity: anim, child: child);
              },
            ),
          );
        },
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          Center(child: Text('Guardados')),
          PetFormScreen(),
          Center(child: Text('Avistamientos Creados')),
          Center(child: Text('Usuario')),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
