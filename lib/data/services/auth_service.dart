import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import 'service_helpers.dart';

/// Authentication API service
class AuthService implements AuthRepository {
  final Dio _dio;
  AuthService({required Dio dio}) : _dio = dio;

  /// Login with email and password → returns UserModel with JWT
  @override
  Future<UserModel> login(String email, String password) async {
    return guardedDioCall(
      () => _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      ),
      (data) => UserModel.fromJson(data['data']),
    );
  }

  /// Register a new user
  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String nationalId,
    required String password,
    required UserRole role,
    String? pharmacyName,
    String? governorate,
    String? city,
    String? village,
    String? street,
    String? licensePath,
  }) async {
    return guardedDioCall(
      () => _dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'nationalId': nationalId,
          'password': password,
          'role': role.toJson(),
          'pharmacyName': ?pharmacyName,
          'governorate': ?governorate,
          'city': ?city,
          'village': ?village,
          'street': ?street,
          'licensePath': ?licensePath,
        },
      ),
      (data) => UserModel.fromJson(data['data']),
    );
  }

  /// Update user profile
  @override
  Future<UserModel> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? pharmacyName,
    String? governorate,
    String? city,
    String? village,
    String? street,
    String? profilePicturePath,
  }) async {
    return guardedDioCall(
      () => _dio.patch(
        ApiEndpoints.profile,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'pharmacyName': pharmacyName,
          'governorate': governorate,
          'city': city,
          'village': village,
          'street': street,
          'profilePicturePath': profilePicturePath,
        },
      ),
      (data) => UserModel.fromJson(data['data']),
    );
  }

  /// Get current user profile using stored token
  @override
  Future<UserModel> getProfile() async {
    return guardedDioCall(
      () => _dio.get(ApiEndpoints.profile),
      (data) => UserModel.fromJson(data['data']),
    );
  }
}
