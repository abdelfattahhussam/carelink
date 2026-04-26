import '../../data/models/user_model.dart';

/// Abstract authentication repository contract.
/// BLoCs depend on this interface; concrete implementations live in `data/services/`.
abstract class AuthRepository {
  /// Login with email and password → returns UserModel with JWT
  Future<UserModel> login(String email, String password);

  /// Register a new user
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
  });

  /// Update user profile (identity extracted from JWT by the backend)
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
  });

  /// Get current user profile using stored token
  Future<UserModel> getProfile();
}
