import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // ✅ Web bytes support
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // ✅ For MultipartFile
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final ApiClient instance = ApiClient._internal();
  factory ApiClient() => instance;
  ApiClient._internal();

  final String baseUrl = 'http://127.0.0.1:8000'; // ✅ Local dev
  final _storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  // ── Token Management ──
  Future<void> setTokens({required String access, required String refresh}) async {
    await _storage.write(key: _accessTokenKey, value: access);
    await _storage.write(key: _refreshTokenKey, value: refresh);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // ── JSON Headers ──
  Future<Map<String, String>> get _headers async {
    final token = await getAccessToken();
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ── Token Refresh ──
  Future<bool> _tryRefreshToken() async {
    final refresh = await getRefreshToken();
    if (refresh == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refresh}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final newAccess = data['access'] as String;
        final newRefresh = data['refresh'] as String? ?? refresh;
        await setTokens(access: newAccess, refresh: newRefresh);
        return true;
      }
    } catch (_) {}

    await clearTokens();
    return false;
  }

  // ── ✅ FIXED: File Upload with WEB SUPPORT ──
  Future<http.Response> uploadFile({
    required String endpoint,
    String? filePath,
    Uint8List? fileBytes,  // ✅ Web bytes
    String? fileName,
    Map<String, String> fields = const {},
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);

    // ✅ Auto-add auth token
    final token = await getAccessToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // ✅ Add form fields
    fields.forEach((k, v) => request.fields[k] = v);

    // ✅ Handle MOBILE path OR WEB bytes
    if (fileBytes != null && fileName != null) {
      debugPrint('🌐 Web: Adding ${fileBytes.length} bytes as pdf_file');
      request.files.add(
        http.MultipartFile.fromBytes('pdf_file', fileBytes, filename: fileName),
      );
    } else if (filePath != null) {
      debugPrint('📱 Mobile: Adding file $filePath');
      final file = File(filePath);
      if (!await file.exists()) throw Exception('File not found: $filePath');
      request.files.add(await http.MultipartFile.fromPath('pdf_file', filePath));
    } else {
      throw Exception('No file provided');
    }

    final streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

  // ── JSON Requests (unchanged) ──
  Future<dynamic> _request(String method, String endpoint, {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters}) async {
    // ... your existing _request code (unchanged)
    Future<http.Response> makeRequest() async {
      final headers = await _headers;
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters?.map((k, v) => MapEntry(k, v.toString())),
      );

      switch (method) {
        case 'GET': return http.get(uri, headers: headers);
        case 'POST': return http.post(uri, headers: headers, body: jsonEncode(body ?? {}));
        case 'PATCH': return http.patch(uri, headers: headers, body: jsonEncode(body ?? {}));
        case 'PUT': return http.put(uri, headers: headers, body: jsonEncode(body ?? {}));
        case 'DELETE': return http.delete(uri, headers: headers);
        default: throw Exception('Unsupported method: $method');
      }
    }

    var response = await makeRequest();

    if (response.statusCode == 401) {
      final refreshed = await _tryRefreshToken();
      if (!refreshed) throw const AuthException('Session expired');
      response = await makeRequest();
    }

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    if (response.statusCode >= 200 && response.statusCode < 300) return decoded;

    String errorMessage = 'Something went wrong';
    if (decoded is Map<String, dynamic>) {
      errorMessage = decoded['detail'] ?? decoded['error'] ?? decoded['message'] ?? errorMessage;
    }
    throw ApiException(errorMessage, statusCode: response.statusCode);
  }

  // Public methods
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) => _request('GET', endpoint, queryParameters: queryParameters);
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) => _request('POST', endpoint, body: body);
  Future<dynamic> patch(String endpoint, {Map<String, dynamic>? body}) => _request('PATCH', endpoint, body: body);
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) => _request('PUT', endpoint, body: body);
  Future<dynamic> delete(String endpoint) => _request('DELETE', endpoint);
}

// Exceptions
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override String toString() => message;
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  const ApiException(this.message, {required this.statusCode});
  @override String toString() => message;
}
