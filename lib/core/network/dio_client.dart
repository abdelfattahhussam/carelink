import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_endpoints.dart';
import '../constants/storage_keys.dart';
import 'auth_storage.dart';
import 'mock_interceptor.dart';

const bool kUseMock = bool.fromEnvironment('USE_MOCK', defaultValue: false);

/// Dio HTTP client with auth token injection and mock support.
///
/// No singleton — a single instance is managed by the DI layer in [app.dart].
/// Accepts [AuthStorage] for testability and a [VoidCallback] for 401 handling
/// so that the network layer is fully decoupled from the BLoC layer.
class DioClient {
  late final Dio dio;

  DioClient({
    required AuthStorage storage,
    required VoidCallback onUnauthorized,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add auth token interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(StorageKeys.authToken);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 — clear auth keys and notify caller to redirect to login
          if (error.response?.statusCode == 401) {
            for (final key in StorageKeys.all) {
              await storage.delete(key);
            }
            onUnauthorized();
          }
          handler.next(error);
        },
      ),
    );

    if (kUseMock) {
      dio.interceptors.add(MockInterceptor());
      debugPrint('⚠️ MockInterceptor ACTIVE');
    }
  }
}
