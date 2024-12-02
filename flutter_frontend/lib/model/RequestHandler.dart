import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestHandler {
  final String baseUrl;

  RequestHandler({this.baseUrl = 'http://localhost:8080/'});

  // Método para realizar solicitudes GET
  Future<dynamic> getRequest(String endpoint,
      {Map<String, String>? params, Map<String, String>? headers}) async {
    try {
      final uri =
          Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
      final response = await http.get(uri, headers: headers);
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
      {Map<String, String>? params, Map<String, String>? headers}) async {
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
        String? filePath,
        String? fileField,
        Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);

      // Agregar headers
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Agregar datos
      if (data != null) {
        request.fields.addAll(data);
      }

      // Agregar archivo si se proporciona
      if (filePath != null && fileField != null) {
        request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
      }

      // Enviar solicitud
      final response = await request.send();

      // Manejar respuesta
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('Error: ${response.statusCode} - ${responseBody.trim()}');
      }
    } catch (e) {
      _handleError(e);
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
