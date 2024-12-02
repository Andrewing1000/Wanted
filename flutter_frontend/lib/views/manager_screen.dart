import 'package:flutter/material.dart';
import 'package:mascotas_flutter/views/Pet_me.dart';
import '../login.dart';
import '../Services/auth.dart';
import 'home_page.dart';
import 'form_page.dart';
import '../widgets/manage_screen_widgets/main_app_bar.dart';
import '../widgets/manage_screen_widgets/bottom_naviagation_bar.dart';
import 'UserMe/VIewProfileScreen.dart';
import 'UserMe/UserMe.dart';

class ManagerScreen extends StatefulWidget {
  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  int _currentIndex = 0;
  bool _isEditingProfile = false;
  final PageController _pageController = PageController();
  final AuthService _authService = AuthService();
  final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();
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
      _isEditingProfile = false;
      _pageController.jumpToPage(index);

      if (index == 0) {
        _homePageKey.currentState?.fetchLostPets();
      }
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditingProfile = !_isEditingProfile;
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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;

            if (index == 0) {
              _homePageKey.currentState?.fetchLostPets();
            }
          });
        },
        children: [
          HomePage(key: _homePageKey),
          PetMePage(),
          PetFormScreen(),
          Center(child: Text('Avistamientos Creados')),
          _isEditingProfile
              ? ForMeScreen()
              : ViewProfileScreen(onEdit: _toggleEditMode),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
