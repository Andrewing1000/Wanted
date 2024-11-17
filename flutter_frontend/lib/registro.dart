import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mascotas_flutter/login.dart';
import 'package:mascotas_flutter/model/auth.dart';
import 'package:mascotas_flutter/widgets/Logo.dart';
import 'package:mascotas_flutter/widgets/hyperlink_text.dart';
import 'widgets/start_button.dart';
import 'widgets/text_input_field.dart';
import 'widgets/text_input_password.dart';




class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _telefono = TextEditingController();
  final TextEditingController _password = TextEditingController();

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

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
    _nameCon.dispose();
    _emailCon.dispose();
    _password.dispose();
    _telefono.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F0F3), // Fondo de la pantalla
      body: Center(
        child: SingleChildScrollView(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    LogoWidget(),
                    SizedBox(height: 20),
                    // Texto introductorio
                    Text(
                      'Cree una cuenta para continuar!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Título principal
                    Text(
                      'Registrarse',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 30),
                    // Campo de Nombre Completo
                    TextInputField(
                      controller: _nameCon,
                      labelText: 'Nombre Completo',
                      hintText: '',
                    ),
                    SizedBox(height: 15),
                    // Campo de Correo
                    TextInputField(
                      controller: _emailCon,
                      labelText: 'Correo',
                      hintText: 'ejemplo@gmail.com',
                    ),
                    SizedBox(height: 15),
                    // Campo de Teléfono
                    TextInputField(
                      controller: _telefono,
                      labelText: 'Teléfono',
                      hintText: '',
                    ),
                    SizedBox(height: 15),
                    // Campo de Contraseña
                    PasswordInputField(
                      controller: _password,
                      labelText: 'Escriba su contraseña',
                    ),
                    SizedBox(height: 30),
                    // Botón de Registrarse
                    StartButton(
                      onPressed: () async {
                        final correo = _emailCon.text.trim();
                        final password = _password.text.trim();
                        final telefono = _telefono.text.trim();
                        final nombre = _nameCon.text.trim();

                        if (correo.isEmpty || password.isEmpty || telefono.isEmpty || nombre.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Por favor, complete todos los campos'),
                            ),
                          );
                          return;
                        }

                        var Auth = await AuthService();
                        final register =await Auth.registerCreate(correo, password, nombre, telefono);
                        if (register == 'Registro') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Registro exitoso'),
                              backgroundColor: CupertinoColors.activeGreen,
                            ),
                          );
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => LoginScreen(),
                              transitionsBuilder: (_, anim, __, child) {
                                return FadeTransition(opacity: anim, child: child);
                              },
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(register as String),
                              backgroundColor: Colors.red,
                            ),
                          );


                        }
                      },
                      text: 'Registrarse',
                    ),
                    SizedBox(height: 20),
                    // Enlace para iniciar sesión
                    HyperlinkText(
                      normalText: '¿Ya tienes una cuenta? ',
                      linkText: 'Inicia Sesión',
                      onTap: () {
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
