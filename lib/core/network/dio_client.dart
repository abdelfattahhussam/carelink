import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_endpoints.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import 'mock_interceptor.dart';
import 'secure_storage.dart';

const bool kUseMock = bool.fromEnvironment('USE_MOCK', defaultValue: false);

/// Singleton Dio HTTP client with auth token injection and mock support
class DioClient {
  static DioClient? _instance;
  late final Dio dio;

  DioClient._({required AuthBloc authBloc}) {
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
          final token = await SecureStorage.instance.read('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 — clear token and notify AuthBloc to redirect to login
          if (error.response?.statusCode == 401) {
            await SecureStorage.instance.delete('auth_token');
            await SecureStorage.instance.delete('user_data');
            authBloc.add(
              AuthLogoutRequested(),
            ); // NOTIFY AuthBloc → router reacts
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

  factory DioClient({required AuthBloc authBloc}) {
    _instance ??= DioClient._(authBloc: authBloc);
    return _instance!;
  }

  /// Reset singleton — for testing purposes only
  @visibleForTesting
  static void resetInstance() {
    _instance = null;
  }
}
