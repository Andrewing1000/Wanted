import 'Pet_Service.dart';
import 'auth.dart';

class Historial {
  final Mascotas masco = Mascotas();
  final AuthService auth = AuthService();
  List<Map<String, dynamic>>? mascotas;

  /// Filtra las mascotas por el correo del usuario autenticado.
  Future<List<Map<String, dynamic>>> filtrarMascotasPorUsuario() async {
    final email = await auth.getUserEmail();
    final todasMascotas = await masco.fetchLostPets();

    final mascotasFiltradas = todasMascotas
        .where((mascota) => mascota['user'] == email)
        .toList();

    return mascotasFiltradas;
  }
}
