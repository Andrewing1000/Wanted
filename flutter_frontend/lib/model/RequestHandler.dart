import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import this package


class RequestHandler {
  final String baseUrl;

  RequestHandler({this.baseUrl = 'http://10.0.2.2:8080/'});

  // Método para realizar solicitudes GET
  Future<dynamic> getRequest(String endpoint,
      {Map<String, String>? params, Map<String, String>? headers}) async {
    try {
      final uri =
          Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (headers != null && headers.containsKey('Authorization'))
            'Authorization':
                'Token ${headers['Authorization']!.replaceAll('Token ', '')}',
          ...?headers,
        });
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  // Método para realizar solicitudes POST
  Future<dynamic> postRequest(String endpoint,
      {Map<String, dynamic>? data,
      Map<String, String>? params,
      Map<String, String>? headers}) async {
    try {
      final uri =
          Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
      final response = await http.post(
        uri,
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          if (headers != null && headers.containsKey('Authorization'))
            'Authorization':
                'Token ${headers['Authorization']!.replaceAll('Token ', '')}',
          ...?headers,
        },
      );
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

// Método para realizar solicitudes PUT
  Future<dynamic> putRequest(String endpoint,
      {Map<String, dynamic>? data,
      Map<String, String>? params,
      Map<String, String>? headers}) async {
    try {
      final uri =
          Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
      final response = await http.put(
        uri,
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          if (headers != null && headers.containsKey('Authorization'))
            'Authorization':
                'Token ${headers['Authorization']!.replaceAll('Token ', '')}',
          ...?headers,
        },
      );
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

// Método para realizar solicitudes DELETE
  Future<dynamic> deleteRequest(String endpoint,
      {Map<String, dynamic>? params, Map<String, String>? headers}) async {
    try {
      final uri =
          Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
      final response = await http.delete(
        uri,
        headers: {
          if (headers != null && headers.containsKey('Authorization'))
            'Authorization':
                'Token ${headers['Authorization']!.replaceAll('Token ', '')}',
          ...?headers,
        },
      );
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

// Método para realizar solicitudes PATCH
  Future<dynamic> patchRequest(String endpoint,
      {Map<String, dynamic>? data,
      Map<String, String>? params,
      Map<String, String>? headers}) async {
    try {
      final uri =
          Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
      final response = await http.patch(
        uri,
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          if (headers != null && headers.containsKey('Authorization'))
            'Authorization':
                'Token ${headers['Authorization']!.replaceAll('Token ', '')}',
          ...?headers,
        },
      );
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }


Future<dynamic> multipartPostRequest(String endpoint,
    {Map<String, String>? data,
    Uint8List? binaryImage,
    String? imageField,
    Map<String, String>? headers}) async {
  try {
    final uri = Uri.parse('$baseUrl$endpoint'); // Replace with your baseUrl + endpoint
    final request = http.MultipartRequest('POST', uri);

    // Add headers
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // Add form fields
    if (data != null) {
      request.fields.addAll(data);
    }

    // Add binary image
    if (binaryImage != null && imageField != null) {
      request.files.add(http.MultipartFile.fromBytes(
        imageField,
        binaryImage,
        filename: "uploaded_image.jpg", // Adjust filename as needed
        contentType: MediaType('image', 'jpeg'), // Use MediaType from http_parser
      ));
    }

    // Send request
    final response = await request.send();

    // Process response
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(responseBody);
    } else {
      throw Exception('Error: ${response.statusCode} - ${responseBody.trim()}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to upload file: $e');
  }
}



  // Método privado para manejar la respuesta
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Método privado para manejar errores
  void _handleError(dynamic error) {
    print('Error en la petición HTTP: $error');
    throw Exception('Error en la petición HTTP: $error');
  }
}
