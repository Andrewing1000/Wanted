import 'package:flutter/material.dart';
import 'package:mascotas_flutter/widgets/Logo.dart';
import 'widgets/titles.dart';
import 'widgets/start_button.dart';
import 'login.dart';
import 'Services/MapAdapter.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  State<WelcomeScreen> createState(){
    return WelcomeScreenState();
  }
}


class WelcomeScreenState extends State<WelcomeScreen>{


  MapAdapter mapView = 
    MapAdapter(
      streetMode: false,
      onMarkerClick: (String markerId){
        print("Clickado $markerId");
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F0F3),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoWidget(),
              SizedBox(height: 20),
              TitleWidget(),
              SizedBox(height: 15),
              SubtitleWidget(),
              SizedBox(height: 30),
              StartButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LoginScreen(),
                      transitionsBuilder: (_, anim, __, child) {
                        return FadeTransition(opacity: anim, child: child);
                      },
                    ),
                  );
                }, text: 'Empezar',
              ),
              ElevatedButton(
                child: const Icon(Icons.switch_camera_outlined), 
                onPressed: (){
                  setState(() {
                    mapView = const MapAdapter(streetMode: true,);
                  });
                },
              ),
              Center(
                child: mapView, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}