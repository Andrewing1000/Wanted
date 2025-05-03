import 'package:flutter/material.dart';
import 'package:mascotas_flutter/Services/MapAdapter.dart'; // Ajusta la ruta si es necesario
import 'package:mascotas_flutter/services/pet_service.dart'; // Ajusta la ruta si es necesario
import 'package:cached_network_image/cached_network_image.dart';

class PetDetailsModal extends StatefulWidget {
  final Map<String, dynamic> pet;

  const PetDetailsModal({Key? key, required this.pet}) : super(key: key);

  @override
  _PetDetailsModalState createState() => _PetDetailsModalState();
}

class _PetDetailsModalState extends State<PetDetailsModal> {
  String? breedName;
  String? speciesName;
  bool isLoading = true;

  // Variables para el mapa
  final MapAdapterController _mapController = MapAdapterController();
  bool _isStreetView = false;
  late double latitude;
  late double longitude;

  // Variables para las imágenes
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadPetDetails();

    // Obtener latitud y longitud de widget.pet
    latitude = double.tryParse(widget.pet['latitude'] ?? '') ?? 0.0;
    longitude = double.tryParse(widget.pet['longitude'] ?? '') ?? 0.0;
  }

  @override
  void dispose() {
    _pageController.dispose();
// Si tienes un método público dispose, úsalo aquí
    super.dispose();
  }

  Future<void> _loadPetDetails() async {
    try {
      final petService = Mascotas();

      // Obtener las listas de razas y especies
      final breeds = await petService.fetchBreeds();
      final species = await petService.fetchSpecies();

      // Buscar los nombres literales de la raza y la especie
      breedName = breeds.firstWhere(
            (breed) => breed['id'] == widget.pet['breed'],
        orElse: () => {'value': 'Desconocida'},
      )['value'];

      speciesName = species.firstWhere(
            (species) => species['id'] == widget.pet['species'],
        orElse: () => {'value': 'Desconocida'},
      )['value'];
    } catch (e) {
      print("Error al cargar detalles de la mascota: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addPetMarker() {
    _mapController.addMarker(
      id: 'pet_marker',
      latitude: latitude,
      longitude: longitude,
      title: widget.pet['pet_name'] ?? 'Mascota',
    );
    _mapController.moveCamera(
      latitude: latitude,
      longitude: longitude,
      zoom: 15.0,
    );
  }

  void _toggleStreetView() {
    if (_isStreetView) {
      _mapController.switchToMapView();
    } else {
      _mapController.switchToStreetView(latitude, longitude);
    }
    setState(() {
      _isStreetView = !_isStreetView;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la lista de fotos
    final List<dynamic> photos = widget.pet['photos'] ?? [];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.grey.withOpacity(0.9), // Fondo más oscuro
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre de la mascota
                    Text(
                      widget.pet['pet_name'] ?? 'Nombre desconocido',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Mostrar imágenes con PageView
                    photos.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: PageView.builder(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  itemCount: photos.length,
                                  itemBuilder: (context, index) {
                                    final photoUrl = photos[index];
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                        imageUrl: photoUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        placeholder: (context, url) =>
                                            Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/dummy.jpg',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Indicadores de página
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(photos.length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _pageController.animateToPage(
                                        index,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentPage == index
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.4),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          )
                        : Image.asset(
                            'assets/dummy.jpg',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    const SizedBox(height: 16),

                    // Información básica
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Especie: $speciesName',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'Raza: $breedName',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Color con barra de color
                    Row(
                      children: [
                        const Text(
                          'Color:',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _hexToColor(widget.pet['color'] ?? '#FFFFFF'),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Descripción
                    const Text(
                      'Descripción:',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.pet['description'] ?? 'Sin descripción',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 16),

                    // Fecha de pérdida
                    Text(
                      'Fecha de pérdida: ${widget.pet['date_lost'] ?? 'Desconocida'}',
                      style: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
                    ),
                    const SizedBox(height: 16),

                    // Mapa y botón para alternar entre mapa y Street View
                    const Text(
                      'Ubicación:',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: MapAdapter(
                        controller: _mapController,
                        initialCameraPosition: {
                          'latitude': latitude,
                          'longitude': longitude,
                          'zoom': 15.0,
                        },
                        onMapClick: _handleMapClick,
                        onMarkerClick: _handleMarkerClick,
                        onCameraIdle: _handleCameraIdle,
                        onStreetViewChange: _handleStreetViewChange,
                        onMapReady: _addPetMarker, // Añadido
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _toggleStreetView,
                      child: Text(
                        _isStreetView ? 'Ver Mapa' : 'Ver Street View',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Botones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            // Lógica para generar un avistamiento
                          },
                          child: const Text(
                            "Generar Avistamiento",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cerrar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Métodos de callback del mapa
  void _handleMapClick(double latitude, double longitude) {
    print('Map clicked at: $latitude, $longitude');
    // Opcional: agregar lógica al hacer clic en el mapa
  }

  void _handleMarkerClick(String markerId) {
    print('Marker clicked: $markerId');
    // Opcional: agregar lógica al hacer clic en el marcador
  }

  void _handleCameraIdle(double latitude, double longitude, double zoom) {
    print('Camera idle at: $latitude, $longitude with zoom $zoom');
    // Opcional: agregar lógica cuando la cámara se detiene
  }

  void _handleStreetViewChange(double latitude, double longitude) {
    print('Street View changed to: $latitude, $longitude');
    // Opcional: agregar lógica cuando cambia la vista de Street View
  }

  /// Convierte un string hexadecimal en un color
  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Añadir opacidad si no está presente
    }
    return Color(int.parse(hex, radix: 16));
  }
}
