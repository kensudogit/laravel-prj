import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laravel_mobile_app/core/providers/providers.dart';
import 'package:logger/logger.dart';

class ApiService {
  final Dio _dio;
  final Logger _logger;

  ApiService(WidgetRef ref) : _logger = Logger() {
    final baseUrl = ref.read(apiBaseUrlProvider);
    
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => _logger.d(obj),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if available
        // final token = await _getAuthToken();
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        handler.next(options);
      },
      onError: (error, handler) {
        _logger.e('API Error: ${error.message}');
        handler.next(error);
      },
    ));
  }

  // Generic GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      _logger.e('GET request failed: $e');
      rethrow;
    }
  }

  // Generic POST request
  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      _logger.e('POST request failed: $e');
      rethrow;
    }
  }

  // Generic PUT request
  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      _logger.e('PUT request failed: $e');
      rethrow;
    }
  }

  // Generic DELETE request
  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      _logger.e('DELETE request failed: $e');
      rethrow;
    }
  }

  // Auth endpoints
  Future<Response> login(String email, String password) async {
    return await post('/auth/login', data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> register(String name, String email, String password, String passwordConfirmation) async {
    return await post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }

  Future<Response> logout() async {
    return await post('/auth/logout');
  }

  Future<Response> getUser() async {
    return await get('/auth/user');
  }

  // User endpoints
  Future<Response> getUsers({Map<String, dynamic>? params}) async {
    return await get('/users', queryParameters: params);
  }

  Future<Response> getUserById(int id) async {
    return await get('/users/$id');
  }

  // Health check
  Future<Response> healthCheck() async {
    return await get('/health');
  }
}

// Provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref);
}); 