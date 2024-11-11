import 'package:flutter/material.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F0F3), // Color de fondo
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/paw_logo.png', // Asegúrate de tener la imagen en assets
                height: 80.0,
              ),
              SizedBox(height: 30),
              // Título de Login
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              // Texto de ayuda
              RichText(
                text: TextSpan(
                  text: '¿No tienes una cuenta? ',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'Registrarse',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Campo de correo electrónico
              TextField(
                decoration: InputDecoration(
                  labelText: 'Correo',
                  hintText: 'ejemplo@correo.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Campo de contraseña
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
              ),
              SizedBox(height: 10),
              // Texto de "Olvidó su contraseña"
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Olvidó su contraseña',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Botón de Iniciar Sesión
              ElevatedButton(
                onPressed: () {
                  // Acción al presionar Iniciar Sesión
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5C6BC0),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              // Texto "Or" en el centro
              Text(
                'Or',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
