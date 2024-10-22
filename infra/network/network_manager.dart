import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:jarvis/domain/repositories/logger_repository.dart';
import 'package:http/http.dart' as http;

import 'circuit_breaker/circuit_breaker.dart';

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
    _logger.logInfo('Performing $method request to $url');

    if (queryParams != null && queryParams.isNotEmpty) {
      final queryString = Uri(queryParameters: queryParams).query;
      url = '$url?$queryString';
    }

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

class CachedNetworkManager<T> implements NetworkManager<T> {
  final NetworkManager<T> _wrapped;
  final Map<String, T> _cache = {};

  CachedNetworkManager(this._wrapped);

  @override
  Future<T> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    }
    final result = await _wrapped.get(
      url,
      headers: headers,
      queryParams: queryParams,
    );
    _cache[url] = result;
    return result;
  }

  @override
  Future<T> post(String url,
      {Map<String, String>? headers, dynamic body}) async {
    return _wrapped.post(url, headers: headers, body: body);
  }

  @override
  Future<T> put(String url,
      {Map<String, String>? headers, dynamic body}) async {
    return _wrapped.put(url, headers: headers, body: body);
  }

  @override
  Future<T> delete(String url, {Map<String, String>? headers}) async {
    return _wrapped.delete(url, headers: headers);
  }
}

class AuthenticatedNetworkManager<T> implements NetworkManager<T> {
  final NetworkManager<T> _wrapped;
  final String _authToken;

  AuthenticatedNetworkManager(this._wrapped, this._authToken);

  @override
  Future<T> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) {
    final updatedHeaders = _updateHeaders(headers);
    return _wrapped.get(
      url,
      headers: updatedHeaders,
      queryParams: queryParams,
    );
  }

  @override
  Future<T> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    final updatedHeaders = _updateHeaders(headers);
    return _wrapped.post(
      url,
      headers: updatedHeaders,
      body: body,
    );
  }

  @override
  Future<T> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    final updatedHeaders = _updateHeaders(headers);
    return _wrapped.put(
      url,
      headers: updatedHeaders,
      body: body,
    );
  }

  @override
  Future<T> delete(
    String url, {
    Map<String, String>? headers,
  }) {
    final updatedHeaders = _updateHeaders(headers);
    return _wrapped.delete(
      url,
      headers: updatedHeaders,
    );
  }

  Map<String, String> _updateHeaders(
    Map<String, String>? headers,
  ) {
    final updatedHeaders = headers ?? {};
    updatedHeaders['Authorization'] = 'Bearer $_authToken';
    return updatedHeaders;
  }
}

class RetryNetworkManager<T> implements NetworkManager<T> {
  final NetworkManager<T> _wrapped;
  final int maxAttempts;
  final Duration delay;

  RetryNetworkManager(this._wrapped,
      {this.maxAttempts = 3, this.delay = const Duration(seconds: 1)});

  @override
  Future<T> get(String url,
      {Map<String, String>? headers, Map<String, dynamic>? queryParams}) async {
    return _retry(
        () => _wrapped.get(url, headers: headers, queryParams: queryParams));
  }

  @override
  Future<T> post(String url,
      {Map<String, String>? headers, dynamic body}) async {
    return _retry(() => _wrapped.post(url, headers: headers, body: body));
  }

  @override
  Future<T> put(String url,
      {Map<String, String>? headers, dynamic body}) async {
    return _retry(() => _wrapped.put(url, headers: headers, body: body));
  }

  @override
  Future<T> delete(String url, {Map<String, String>? headers}) async {
    return _retry(() => _wrapped.delete(url, headers: headers));
  }

  Future<T> _retry(Future<T> Function() action) async {
    int attempt = 0;
    while (attempt < maxAttempts) {
      try {
        return await action();
      } catch (e) {
        attempt++;
        if (attempt >= maxAttempts) {
          rethrow;
        }
        await Future.delayed(delay);
      }
    }
    throw Exception('Max retries reached');
  }
}

class CircuitBreakerNetworkManager<T> implements NetworkManager<T> {
  final NetworkManager<T> _wrapped;
  final CircuitBreaker _circuitBreaker;

  CircuitBreakerNetworkManager(
    this._wrapped,
    this._circuitBreaker,
  );

  @override
  Future<T> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return _performWithCircuitBreaker(() => _wrapped.get(
          url,
          headers: headers,
          queryParams: queryParams,
        ));
  }

  @override
  Future<T> post(String url,
      {Map<String, String>? headers, dynamic body}) async {
    return _performWithCircuitBreaker(() => _wrapped.post(
          url,
          headers: headers,
          body: body,
        ));
  }

  @override
  Future<T> put(String url,
      {Map<String, String>? headers, dynamic body}) async {
    return _performWithCircuitBreaker(() => _wrapped.put(
          url,
          headers: headers,
          body: body,
        ));
  }

  @override
  Future<T> delete(String url, {Map<String, String>? headers}) async {
    return _performWithCircuitBreaker(() => _wrapped.delete(
          url,
          headers: headers,
        ));
  }

  Future<T> _performWithCircuitBreaker(Future<T> Function() action) async {
    if (!_circuitBreaker.canProceed()) {
      throw Exception('Circuit breaker is open');
    }

    try {
      final result = await action();
      _circuitBreaker.recordSuccess();
      return result;
    } catch (e) {
      _circuitBreaker.recordFailure();
      rethrow;
    }
  }
}
