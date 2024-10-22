import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:jarvis/domain/repositories/logger_repository.dart';
import 'package:http/http.dart' as http;

abstract class NetworkManager<T> {
  Future<T> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  });

  Future<T> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future<T> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future<T> delete(
    String url, {
    Map<String, String>? headers,
  });
}

@LazySingleton(as: NetworkManager)
class NetworkManagerImpl<T> implements NetworkManager<T> {
  final LoggerRepository _logger;

  NetworkManagerImpl(this._logger);

  @override
  Future<T> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return await _performRequest(
      'GET',
      url,
      headers: headers,
      queryParams: queryParams,
    );
  }

  @override
  Future<T> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return await _performRequest(
      'POST',
      url,
      headers: headers,
      body: body,
    );
  }

  @override
  Future<T> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return await _performRequest(
      'PUT',
      url,
      headers: headers,
      body: body,
    );
  }

  @override
  Future<T> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    return await _performRequest(
      'DELETE',
      url,
      headers: headers,
    );
  }

  Future<T> _performRequest(
    String method,
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) async {
    // Log the request
    _logger.logInfo('Performing $method request to $url');

    // Apply query parameters if any
    if (queryParams != null && queryParams.isNotEmpty) {
      final queryString = Uri(queryParameters: queryParams).query;
      url = '$url?$queryString';
    }

    // Send the request
    http.Response response;
    try {
      switch (method) {
        case 'GET':
          response = await http.get(
            Uri.parse(url),
            headers: headers,
          );
          break;
        case 'POST':
          response = await http.post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(
            Uri.parse(url),
            headers: headers,
          );
          break;
        default:
          throw UnimplementedError();
      }

      // Log the response
      _logger.logInfo(
        'Response from $url: ${response.statusCode} ${response.body}',
      );

      if (response.statusCode == 200) {
        return _parseJson(response.body);
      } else {
        _logger.logError(
          'Failed request: ${response.statusCode}',
          Exception(response.body),
        );
        throw Exception('Failed request: ${response.statusCode}');
      }
    } catch (e) {
      _logger.logError('Exception during request: $e', e as Exception);
      rethrow;
    }
  }

  T _parseJson(String responseBody) {
    return jsonDecode(responseBody) as T;
  }
}
