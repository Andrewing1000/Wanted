import 'package:flutter/material.dart';
import 'package:mascotas_flutter/views/manager_screen.dart';
import '../../widgets/text_input_field.dart';
import '../../widgets/text_input_password.dart';
import '../../widgets/start_button.dart';
import '../../Services/User.dart';

class ForMeScreen extends StatefulWidget {
  @override
  _ForMeScreenState createState() => _ForMeScreenState();
}

class _ForMeScreenState extends State<ForMeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ConfirmPasswordController =
      TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Fondo claro
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Encabezado
            Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Editar Perfil",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Actualiza tus datos personales",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Formulario en tarjeta
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInputField(
                          labelText: 'Nombre',
                          controller: _nameController,
                        ),
                        SizedBox(height: 16),
                        TextInputField(
                          labelText: 'Correo',
                          controller: _correoController,
                        ),
                        SizedBox(height: 16),
                        TextInputField(
                          labelText: 'Número',
                          controller: _numeroController,
                        ),
                        SizedBox(height: 16),
                        PasswordInputField(
                          labelText: 'Contraseña',
                          controller: _passwordController,
                        ),
                        SizedBox(height: 16),
                        PasswordInputField(
                          labelText: 'Confirmación Contraseña',
                          controller: _ConfirmPasswordController,
                        ),
                        SizedBox(height: 20),
                        // Botón
                        Center(
                          child: StartButton(
                            onPressed: () async {
                              final correo = _correoController.text.trim();
                              final contrasenia =
                                  _passwordController.text.trim();
                              final confirmacion =
                                  _ConfirmPasswordController.text.trim();
                              final telefono = _numeroController.text.trim();
                              final nombre = _nameController.text.trim();
                              final UserMe user = UserMe();
                              if (correo.isEmpty ||
                                  contrasenia.isEmpty ||
                                  confirmacion.isEmpty ||
                                  telefono.isEmpty ||
                                  nombre.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Llene todos los datos'),
                                  backgroundColor: Colors.red,
                                ));
                              } else if (confirmacion == contrasenia) {
                                user.GuardarCambios(
                                  correo,
                                  contrasenia,
                                  nombre,
                                  telefono,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      Text('Datos actualizados correctamente'),
                                  backgroundColor: Colors.green,
                                ));
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        ManagerScreen(),
                                    transitionsBuilder: (_, anim, __, child) {
                                      return FadeTransition(
                                          opacity: anim, child: child);
                                    },
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Las contraseñas no coinciden'),
                                  backgroundColor: Colors.red,
                                ));
                              }
                            },
                            text: 'Guardar',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
