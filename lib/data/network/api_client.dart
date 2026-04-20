import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final ApiClient instance = ApiClient._internal();
  factory ApiClient() => instance;
  ApiClient._internal();

  // ── Change this to your machine's local IP if testing on a real device ──
  // For emulator: 10.0.2.2 (Android) or 127.0.0.1 (iOS simulator)
  // For real device: your computer's local network IP e.g. 192.168.1.x
  final String baseUrl = 'http://127.0.0.1:8000/api/v1';

  final _storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  // ── Token Management ────────────────────────────────────────────────────
  Future<void> setTokens({
    required String access,
    required String refresh,
  }) async {
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

  // ── Headers ─────────────────────────────────────────────────────────────
  Future<Map<String, String>> get _headers async {
    final token = await getAccessToken();
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ── Token Refresh ────────────────────────────────────────────────────────
  // Called automatically when a 401 is received.
  // Returns true if refresh succeeded, false if the user needs to log in again.
  Future<bool> _tryRefreshToken() async {
    final refresh = await getRefreshToken();
    if (refresh == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refresh}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final newAccess = data['access'] as String;
        // Django SimpleJWT with ROTATE_REFRESH_TOKENS=True also returns a new refresh
        final newRefresh = data['refresh'] as String? ?? refresh;
        await setTokens(access: newAccess, refresh: newRefresh);
        return true;
      }
    } catch (_) {
      // Network error during refresh — fail silently, force re-login
    }

    // Refresh failed — clear tokens so the router redirects to login
    await clearTokens();
    return false;
  }

  // ── Core Request with Auto-Retry ─────────────────────────────────────────
  // Any 401 triggers one refresh attempt, then retries the original request.
  // If refresh fails, throws an [AuthException] so GoRouter redirects to login.
  Future<dynamic> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    Future<http.Response> makeRequest() async {
      final headers = await _headers;
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters?.map(
          (k, v) => MapEntry(k, v.toString()),
        ),
      );

      switch (method) {
        case 'GET':
          return http.get(uri, headers: headers);
        case 'POST':
          return http.post(uri, headers: headers, body: jsonEncode(body ?? {}));
        case 'PATCH':
          return http.patch(uri, headers: headers, body: jsonEncode(body ?? {}));
        case 'PUT':
          return http.put(uri, headers: headers, body: jsonEncode(body ?? {}));
        case 'DELETE':
          return http.delete(uri, headers: headers);
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
    }

    var response = await makeRequest();

    // 401 → try to refresh and retry once
    if (response.statusCode == 401) {
      final refreshed = await _tryRefreshToken();
      if (!refreshed) {
        throw AuthException('Session expired. Please log in again.');
      }
      response = await makeRequest(); // retry with new token
    }

    return _handleResponse(response);
  }

  // ── Public HTTP Methods ──────────────────────────────────────────────────
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _request('GET', endpoint, queryParameters: queryParameters);

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) =>
      _request('POST', endpoint, body: body);

  Future<dynamic> patch(String endpoint, {Map<String, dynamic>? body}) =>
      _request('PATCH', endpoint, body: body);

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) =>
      _request('PUT', endpoint, body: body);

  Future<dynamic> delete(String endpoint) => _request('DELETE', endpoint);

  // ── Response Handler ─────────────────────────────────────────────────────
  dynamic _handleResponse(http.Response response) {
    final decoded =
        response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    // Extract the most useful error message from Django's response
    String errorMessage = 'Something went wrong';
    if (decoded is Map) {
      errorMessage = decoded['detail'] ??
          decoded['error'] ??
          decoded['message'] ??
          _extractFirstFieldError(decoded) ??
          errorMessage;
    }

    throw ApiException(errorMessage, statusCode: response.statusCode);
  }

  // Extracts the first validation error from DRF field errors
  // e.g. {"email": ["This field is required."]} → "email: This field is required."
  String? _extractFirstFieldError(Map decoded) {
    for (final entry in decoded.entries) {
      final value = entry.value;
      if (value is List && value.isNotEmpty) {
        return '${entry.key}: ${value.first}';
      }
      if (value is String) {
        return '${entry.key}: $value';
      }
    }
    return null;
  }
}

// ── Custom Exceptions ────────────────────────────────────────────────────────
// AuthException signals that the user needs to log in again.
// The auth controller listens for this and clears state → GoRouter redirects.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

// ApiException carries the HTTP status code for more granular error handling.
class ApiException implements Exception {
  final String message;
  final int statusCode;
  const ApiException(this.message, {required this.statusCode});

  @override
  String toString() => message;
}
