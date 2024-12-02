import 'package:flutter/material.dart';
import '../../Services/User.dart';
import "../../widgets/start_button.dart";
import 'UserMe.dart'; // Importa la pantalla para editar

class ViewProfileScreen extends StatefulWidget {
  final VoidCallback onEdit; // Callback para alternar a la pantalla de edición

  const ViewProfileScreen({required this.onEdit, Key? key}) : super(key: key);

  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final UserMe user = UserMe();
  Map<String, dynamic>? userData; // Almacenará los datos del usuario
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// Obtener los datos del usuario
  Future<void> _fetchUserData() async {
    try {
      final data = await user.ObtenerData();
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al obtener los datos del usuario'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Fondo claro
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : SingleChildScrollView(
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
                          "Mi Perfil",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Revisa tu información personal",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Tarjeta con los datos del usuario
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Mostrar datos del usuario
                            _buildInfoRow('Nombre', userData?['name'] ?? '-'),
                            _buildInfoRow('Correo', userData?['email'] ?? '-'),
                            _buildInfoRow(
                                'Teléfono', userData?['phone_number'] ?? '-'),
                            SizedBox(height: 20),
                            // Botón para editar
                            Center(
                              child: StartButton(
                                text: 'Editar Usuario',
                                onPressed:
                                    widget.onEdit, // Cambiar al modo de edición
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// Widget para construir cada fila de información
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
