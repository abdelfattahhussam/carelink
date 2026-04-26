import 'package:equatable/equatable.dart';
import 'package:carelink_app/core/config/rbac_config.dart';

enum UserRole {
  user,
  pharmacist;

  static UserRole fromJson(String json) => switch (json) {
    'pharmacist' => UserRole.pharmacist,
    _            => UserRole.user, // maps 'donor', 'patient', 'user' → user
  };

  String toJson() => name; // produces 'user' or 'pharmacist'

  String get label => switch (this) {
    UserRole.user       => 'User',
    UserRole.pharmacist => 'Pharmacist',
  };
}

/// User model with JSON serialization
class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String nationalId; // Added National ID
  final UserRole role;
  final String status; // 'pending', 'verified'
  final String token;
  final DateTime createdAt;

  // Pharmacist/User specific fields
  final String? pharmacyName;
  final String? governorate;
  final String? city;
  final String? village;
  final String? street;
  final String? licensePath;
  final String? profilePicturePath;

  // Multi-step identity verification fields
  final String? idCardFrontPath;
  final String? idCardBackPath;
  final String? selfiePath;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.nationalId,
    required this.role,
    required this.status,
    required this.token,
    required this.createdAt,
    this.pharmacyName,
    this.governorate,
    this.city,
    this.village,
    this.street,
    this.licensePath,
    this.profilePicturePath,
    this.idCardFrontPath,
    this.idCardBackPath,
    this.selfiePath,
  });

  /// Whether the user's identity has been verified
  // TODO(backend): Replace with real verification check once backend implements user verification flow.
  // Currently hardcoded to true — all users are treated as verified.
  bool get isVerified => true;
  bool get isUser => role == UserRole.user;
  bool get isPharmacist => role == UserRole.pharmacist;

  /// Centralized permission check — delegates to RBAC single source of truth
  bool get canRequestMedicine =>
      RBACConfig.hasPermission(role, AppPermission.requestMedicine);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      nationalId: json['nationalId'] ?? '',
      role: UserRole.fromJson(json['role'] ?? 'patient'),
      status: json['status'] ?? 'verified',
      token: json['token'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      pharmacyName: json['pharmacyName'],
      governorate: json['governorate'],
      city: json['city'],
      village: json['village'],
      street: json['street'],
      licensePath: json['licensePath'],
      profilePicturePath: json['profilePicturePath'],
      idCardFrontPath: json['idCardFrontPath'],
      idCardBackPath: json['idCardBackPath'],
      selfiePath: json['selfiePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'nationalId': nationalId,
      'role': role.toJson(),
      'status': status,
      'token': token,
      'createdAt': createdAt.toIso8601String(),
      'pharmacyName': pharmacyName,
      'governorate': governorate,
      'city': city,
      'village': village,
      'street': street,
      'licensePath': licensePath,
      'profilePicturePath': profilePicturePath,
      'idCardFrontPath': idCardFrontPath,
      'idCardBackPath': idCardBackPath,
      'selfiePath': selfiePath,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? nationalId,
    UserRole? role,
    String? status,
    String? token,
    DateTime? createdAt,
    String? pharmacyName,
    String? governorate,
    String? city,
    String? village,
    String? street,
    String? licensePath,
    String? profilePicturePath,
    String? idCardFrontPath,
    String? idCardBackPath,
    String? selfiePath,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nationalId: nationalId ?? this.nationalId,
      role: role ?? this.role,
      status: status ?? this.status,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      village: village ?? this.village,
      street: street ?? this.street,
      licensePath: licensePath ?? this.licensePath,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      idCardFrontPath: idCardFrontPath ?? this.idCardFrontPath,
      idCardBackPath: idCardBackPath ?? this.idCardBackPath,
      selfiePath: selfiePath ?? this.selfiePath,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    role,
    status,
    token,
    pharmacyName,
    governorate,
    city,
    village,
    street,
    licensePath,
    profilePicturePath,
    idCardFrontPath,
    idCardBackPath,
    selfiePath,
  ];
}
