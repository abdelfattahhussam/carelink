import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/network/auth_storage.dart';
import '../../../core/network/secure_storage.dart';
import '../../../core/errors/failures.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/repositories/auth_repository.dart';

// ─── EVENTS ───

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  AuthLoginRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String nationalId;
  final String password;
  final UserRole role;

  // Optional Pharmacist fields
  final String? pharmacyName;
  final String? governorate;
  final String? city;
  final String? village;
  final String? street;
  final String? licensePath;

  AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.phone,
    required this.nationalId,
    required this.password,
    required this.role,
    this.pharmacyName,
    this.governorate,
    this.city,
    this.village,
    this.street,
    this.licensePath,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    nationalId,
    password,
    role,
    pharmacyName,
    governorate,
    city,
    village,
    street,
    licensePath,
  ];
}

class AuthUpdateProfileRequested extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String? pharmacyName;
  final String? governorate;
  final String? city;
  final String? village;
  final String? street;
  final String? profilePicturePath;

  AuthUpdateProfileRequested({
    required this.name,
    required this.email,
    required this.phone,
    this.pharmacyName,
    this.governorate,
    this.city,
    this.village,
    this.street,
    this.profilePicturePath,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    pharmacyName,
    governorate,
    city,
    village,
    street,
    profilePicturePath,
  ];
}

class AuthLogoutRequested extends AuthEvent {}

// ─── STATES ───

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  AuthAuthenticated({required this.user});
  @override
  List<Object?> get props => [user];
}

class AuthProfileUpdateSuccess extends AuthAuthenticated {
  AuthProfileUpdateSuccess({required super.user});
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
  @override
  List<Object?> get props => [message];
}

// ─── BLOC ───

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository? _authService;
  final AuthStorage _authStorage;

  AuthBloc({required AuthRepository authService, AuthStorage? authStorage})
    : _authService = authService,
      _authStorage = authStorage ?? const SecureStorage(),
      super(AuthInitial()) {
    _registerHandlers();
  }

  /// Temporary empty constructor for DI bootstrap.
  /// Must call [init] before dispatching any service-dependent events.
  AuthBloc.empty({AuthStorage? authStorage})
    : _authService = null,
      _authStorage = authStorage ?? const SecureStorage(),
      super(AuthInitial()) {
    _registerHandlers();
  }

  /// Sets the service and triggers initial auth check.
  /// Used after DioClient is constructed with this bloc reference.
  void init({required AuthRepository service}) {
    _authService = service;
    add(AuthCheckRequested());
  }

  void _registerHandlers() {
    on<AuthCheckRequested>(_onCheckAuth);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthUpdateProfileRequested>(_onUpdateProfile);
    on<AuthLogoutRequested>(_onLogout);
  }

  /// Check if user is already authenticated (on app start)
  Future<void> _onCheckAuth(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await _authStorage.read('auth_token');
      final userData = await _authStorage.read('user_data');

      if (token != null && userData != null) {
        final user = UserModel.fromJson(jsonDecode(userData));
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  /// Login with email/password
  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authService!.login(event.email, event.password);

      await _authStorage.write('auth_token', user.token);
      await _authStorage.write('user_data', jsonEncode(user.toJson()));

      emit(AuthAuthenticated(user: user));
    } on DioException catch (e) {
      emit(AuthError(message: _mapDioExceptionToMessage(e)));
    } on Failure catch (f) {
      emit(AuthError(message: f.message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Register new account
  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authService!.register(
        name: event.name,
        email: event.email,
        phone: event.phone,
        nationalId: event.nationalId,
        password: event.password,
        role: event.role,
        pharmacyName: event.pharmacyName,
        governorate: event.governorate,
        city: event.city,
        village: event.village,
        street: event.street,
        licensePath: event.licensePath,
      );

      await _authStorage.write('auth_token', user.token);
      await _authStorage.write('user_data', jsonEncode(user.toJson()));

      emit(AuthAuthenticated(user: user));
    } on DioException catch (e) {
      emit(AuthError(message: _mapDioExceptionToMessage(e)));
    } on Failure catch (f) {
      emit(AuthError(message: f.message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Update user profile
  Future<void> _onUpdateProfile(
    AuthUpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    UserModel? currentUser;
    if (currentState is AuthAuthenticated) currentUser = currentState.user;

    if (currentUser == null) return;

    emit(AuthLoading());
    try {
      final updatedUser = await _authService!.updateProfile(
        name: event.name,
        email: event.email,
        phone: event.phone,
        pharmacyName: event.pharmacyName,
        governorate: event.governorate,
        city: event.city,
        village: event.village,
        street: event.street,
        profilePicturePath: event.profilePicturePath,
      );

      await _authStorage.write('user_data', jsonEncode(updatedUser.toJson()));

      emit(AuthProfileUpdateSuccess(user: updatedUser));
    } on DioException catch (e) {
      emit(AuthError(message: _mapDioExceptionToMessage(e)));
    } on Failure catch (f) {
      emit(AuthError(message: f.message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Logout — clear all stored data
  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authStorage.delete('auth_token');
    await _authStorage.delete('user_data');
    emit(AuthUnauthenticated());
  }

  String _mapDioExceptionToMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure().message;
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return const AuthFailure().message;
        }
        return ServerFailure(
          message: e.response?.data?['error'] ?? 'Authentication server error',
          statusCode: statusCode,
        ).message;
      default:
        return ServerFailure(
          message: e.message ?? 'Unexpected authentication error',
        ).message;
    }
  }
}
