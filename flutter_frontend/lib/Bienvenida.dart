import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mascotas_flutter/widgets/Logo.dart';
import 'widgets/titles.dart';
import 'widgets/start_button.dart';
import 'Services/auth.dart';
import 'login.dart';

class WelcomeScreen extends StatelessWidget {
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
                onPressed: (){
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
            ],
          ),
        ),
      ),
    );
  }
}