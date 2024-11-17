

import 'package:flutter/material.dart';
import 'package:mascotas_flutter/views/manager_screen.dart';
import 'package:mascotas_flutter/widgets/Logo.dart';
import 'package:mascotas_flutter/widgets/text_input_password.dart';
import 'model/auth.dart';
import 'widgets/text_input_field.dart';
import 'widgets/hyperlink_text.dart';
import 'widgets/start_button.dart';
import 'Services/RequestHandler.dart';
import 'registro.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible=false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F0F3),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LogoWidget(),
                    SizedBox(height: 30),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    HyperlinkText(
                      normalText: '¿No tienes una cuenta? ',
                      linkText: 'Registrarse',
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => RegisterScreen(),
                            transitionsBuilder: (_, anim, __, child) {
                              return FadeTransition(opacity: anim, child: child);
                            },
                          ),
                        );

                      },
                    ),
                    SizedBox(height: 20),
                    TextInputField(
                      labelText: 'Ingrese su correo',
                      hintText: 'ejemplo@gmail.com',
                      controller: _emailController,
                    ),
                    SizedBox(height: 15),

                    PasswordInputField(controller: _passwordController,labelText: 'Ingrese su contraseña'),
                    SizedBox(height: 15),
                    // Botón para iniciar sesión
                    StartButton(
                      text: 'Iniciar Sesión',
                      onPressed: () async {
                        final correo = _emailController.text.trim();
                        final contrasenia = _passwordController.text.trim();


                        if (correo.isEmpty || contrasenia.isEmpty) {
                          print(contrasenia);
                          print(correo);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Por favor, completa todos los campos'),
                            ),
                          );
                          return;
                        }
                        var auth = await AuthService();
                        var response = await auth.Login(correo,contrasenia);
                        if (response == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Correo o contraseña incorrectos'),
                            ),
                          );
                        }else if(response == true){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => ManagerScreen(),
                              transitionsBuilder: (_, anim, __, child) {
                                return FadeTransition(opacity: anim, child: child);
                              },
                            ),
                          );

                        }
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}





