import 'package:flutter/material.dart';
import '../widgets/text_input_field.dart';
import '../widgets/text_input_password.dart';
import '../widgets/start_button.dart';
import '../Services/User.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  labelText: 'Numero',
                  controller: _numeroController,
                ),
                SizedBox(height: 16),
                PasswordInputField(
                  labelText: 'Contraseña',
                  controller: _passwordController,
                ),
                SizedBox(height: 16),
                PasswordInputField(
                  labelText: 'Confirmacion Contraseña',
                  controller: _ConfirmPasswordController,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StartButton(
                      onPressed: () async {
                        final correo = _correoController.text.trim();
                        final contrasenia = _passwordController.text.trim();
                        final confirmacion =
                            _ConfirmPasswordController.text.trim();
                        final telefono = _numeroController.text.trim();
                        final nombre = _nameController.text.trim();
                        final UserMe user = UserMe();
                        if (confirmacion == contrasenia) {
                          user.GuardarCambios(
                            correo,
                            contrasenia,
                            telefono,
                            nombre,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Las contraseñas no conciden'),
                            backgroundColor: Colors.red,
                          ));
                        }
                      },
                      text: 'Guardar',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
