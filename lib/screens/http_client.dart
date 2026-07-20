import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:textile_tracking/screens/env_config.dart';
import 'package:textile_tracking/screens/storage_service.dart';

class HttpClient {
  static bool _isRefreshing = false;
  static final List<Function> _requestQueue = [];

  static bool _isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  /// Send GET request with automatic token refresh on 401
  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    final requestHeaders = Map<String, String>.from(
      headers ?? await EnvConfig.apiHeader(),
    );
    final response = await http.get(url, headers: requestHeaders);

    if (response.statusCode == 401) {
      return await _handleTokenExpiration(() async {
        final newHeaders = await EnvConfig.apiHeader();
        return http.get(url, headers: newHeaders);
      });
    }

    return response;
  }

  /// Send POST request with automatic token refresh on 401
  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final requestHeaders = Map<String, String>.from(
      headers ?? await EnvConfig.apiHeader(),
    );
    final response = await http.post(url, headers: requestHeaders, body: body);

    if (response.statusCode == 401) {
      return await _handleTokenExpiration(() async {
        final newHeaders = await EnvConfig.apiHeader();
        return http.post(url, headers: newHeaders, body: body);
      });
    }

    return response;
  }

  /// Send PUT request with automatic token refresh on 401
  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final requestHeaders = Map<String, String>.from(
      headers ?? await EnvConfig.apiHeader(),
    );
    final response = await http.put(url, headers: requestHeaders, body: body);

    if (response.statusCode == 401) {
      return await _handleTokenExpiration(() async {
        final newHeaders = await EnvConfig.apiHeader();
        return http.put(url, headers: newHeaders, body: body);
      });
    }

    return response;
  }

  /// Send PUT request with automatic token refresh on 401
  static Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final requestHeaders = Map<String, String>.from(
      headers ?? await EnvConfig.apiHeader(),
    );
    final response = await http.patch(url, headers: requestHeaders, body: body);

    if (response.statusCode == 401) {
      return await _handleTokenExpiration(() async {
        final newHeaders = await EnvConfig.apiHeader();
        return http.patch(url, headers: newHeaders, body: body);
      });
    }

    return response;
  }

  /// Send DELETE request with automatic token refresh on 401
  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final requestHeaders = Map<String, String>.from(
      headers ?? await EnvConfig.apiHeader(),
    );
    final response = await http.delete(
      url,
      headers: requestHeaders,
      body: body,
    );

    if (response.statusCode == 401) {
      return await _handleTokenExpiration(() async {
        final newHeaders = await EnvConfig.apiHeader();
        return http.delete(url, headers: newHeaders, body: body);
      });
    }

    return response;
  }

  /// Send Multipart request (for file uploads) with automatic token refresh on 401
  static Future<http.Response> multipart({
    required String method,
    required Uri url,
    Map<String, String>? headers,
    Map<String, String>? fields,
    Map<String, http.MultipartFile>? files,
  }) async {
    return await _sendMultipartRequest(
      method: method,
      url: url,
      headers: headers,
      fields: fields,
      files: files,
    );
  }

  /// Internal method to send multipart request
  static Future<http.Response> _sendMultipartRequest({
    required String method,
    required Uri url,
    Map<String, String>? headers,
    Map<String, String>? fields,
    Map<String, http.MultipartFile>? files,
  }) async {
    final requestHeaders = Map<String, String>.from(
      headers ?? await EnvConfig.apiHeader(includeContentType: false),
    );

    // Remove Content-Type header for multipart requests
    // The correct boundary will be set automatically by MultipartRequest
    requestHeaders.remove('Content-Type');

    // Create multipart request
    final request = http.MultipartRequest(method, url);
    request.headers.addAll(requestHeaders);

    // Add fields
    if (fields != null) {
      request.fields.addAll(fields);
    }

    // Add files
    if (files != null) {
      files.forEach((key, file) {
        request.files.add(file);
      });
    }

    // Send request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Handle token expiration
    if (response.statusCode == 401) {
      return await _handleTokenExpiration(() async {
        return _sendMultipartRequest(
          method: method,
          url: url,
          headers: null, // Will regenerate with new token
          fields: fields,
          files: files,
        );
      });
    }

    return response;
  }

  /// Handle token expiration by refreshing and retrying the request
  static Future<http.Response> _handleTokenExpiration(
    Future<http.Response> Function() retryRequest,
  ) async {
    // If already refreshing, add to queue
    if (_isRefreshing) {
      return await _addToQueue(retryRequest);
    }

    _isRefreshing = true;

    try {
      // Attempt to refresh token
      final refreshSuccess = await _refreshToken();

      if (refreshSuccess) {
        // Retry original request with new token
        final response = await retryRequest();

        // Process queued requests
        if (_requestQueue.isNotEmpty) {
          await _processQueue();
        }

        return response;
      } else {
        await StorageService.clearAll();

        // Throw specific exception that can be caught in UI layer
        throw TokenRefreshFailedException(
          'Token refresh failed. Please login again.',
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Refresh the authentication token
  static Future<bool> _refreshToken() async {
    try {
      final url = Uri.parse('${EnvConfig.apiUrl}/refresh-token');
      final refreshToken = await StorageService.getRefreshToken();
      final response = await http.post(
        url,
        headers: await EnvConfig.apiHeader(),
        body: refreshToken == null
            ? null
            : jsonEncode({
                'refresh_token': refreshToken,
              }),
      );

      if (_isSuccess(response)) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final authData = data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : data;

        if (authData['access_token'] == null) {
          return false;
        }

        await StorageService.saveUser(authData);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Public method to manually refresh token
  static Future<Map<String, dynamic>> refreshToken() async {
    try {
      final success = await _refreshToken();

      if (success) {
        return {'success': true, 'message': 'Token refreshed successfully'};
      } else {
        return {'success': false, 'message': 'Failed to refresh token'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Token refresh error: ${e.toString()}',
      };
    }
  }

  /// Add request to queue while token is being refreshed
  static Future<http.Response> _addToQueue(
    Future<http.Response> Function() request,
  ) async {
    final completer = Completer<http.Response>();

    _requestQueue.add(() async {
      try {
        final response = await request();
        completer.complete(response);
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future;
  }

  /// Process all queued requests after token refresh
  static Future<void> _processQueue() async {
    final queue = List.from(_requestQueue);
    _requestQueue.clear();

    for (var request in queue) {
      try {
        await request();
      } catch (e) {
        rethrow;
      }
    }
  }
}

/// Custom exception for token refresh failures
class TokenRefreshFailedException implements Exception {
  final String message;

  TokenRefreshFailedException(this.message);

  @override
  String toString() => message;
}
