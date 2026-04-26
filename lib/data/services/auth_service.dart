import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

/// Authentication API service
class AuthService implements AuthRepository {
  final Dio _dio;
  AuthService({required Dio dio}) : _dio = dio;

  /// Login with email and password → returns UserModel with JWT
  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return UserModel.fromJson(response.data['data']);
    }
    throw ServerFailure(message: response.data['error'] ?? 'Login failed');
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
    final response = await _dio.post(
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
    );

    if (response.statusCode == 201 && response.data['success'] == true) {
      return UserModel.fromJson(response.data['data']);
    }
    throw ServerFailure(
      message: response.data['error'] ?? 'Registration failed',
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
    // In a real app, this would be a PATCH or PUT request
    final response = await _dio.post(
      ApiEndpoints.profile, // Assuming profile endpoint supports updates
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
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return UserModel.fromJson(response.data['data']);
    }
    throw ServerFailure(
      message: response.data['error'] ?? 'Profile update failed',
    );
  }

  /// Get current user profile using stored token
  @override
  Future<UserModel> getProfile() async {
    final response = await _dio.get(ApiEndpoints.profile);

    if (response.statusCode == 200 && response.data['success'] == true) {
      return UserModel.fromJson(response.data['data']);
    }
    throw ServerFailure(
      message: response.data['error'] ?? 'Failed to get profile',
    );
  }
}
