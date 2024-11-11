import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:latlong2/latlong.dart';

class ARLocationScreen extends StatelessWidget {
  final LatLng location;

  ARLocationScreen({required this.location});

  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vista en Realidad Aumentada')),
      body: ARView(
        onARViewCreated: onARViewCreated,
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    // Configuramos el ARSessionManager
    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "assets/plane_texture.png",
      showWorldOrigin: true,
    );

    // Configuramos el ARObjectManager
    arObjectManager.onInitialize();

    // Añadimos el marcador en la posición deseada
    addMarkerAtLocation();
  }

  void addMarkerAtLocation() async {
    // Usa la ubicación de la mascota y coloca el marcador en AR
    final position = vector.Vector3(location.latitude, location.longitude, 0);

    // Agrega el marcador como un nodo en la posición deseada
    var node = ARNode(
      type: NodeType.webGLB,
      uri: "https://model3dlink.glb", // URL del modelo 3D que deseas cargar
      scale: vector.Vector3(0.1, 0.1, 0.1),
      position: position,
      rotation: vector.Vector4(1, 0, 0, 0),
    );

    // Agrega el nodo al ARObjectManager
    bool? didAddNode = await arObjectManager.addNode(node);
    if (didAddNode == true) {
      print("Nodo agregado en AR correctamente");
    } else {
      print("No se pudo agregar el nodo en AR");
    }
  }
}
