import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/network/auth_storage.dart';
import '../../../core/network/secure_storage.dart';
import '../../../core/errors/dio_error_mapper.dart';
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
  const AuthState();

  /// Returns the authenticated user if this state carries one, null otherwise.
  /// Override in any state subclass that represents a valid session.
  UserModel? get authenticatedUser => null;

  /// Convenience check — true when this state carries a valid user.
  bool get isAuthenticated => authenticatedUser != null;

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  const AuthAuthenticated({required this.user});

  @override
  UserModel get authenticatedUser => user;

  @override
  List<Object?> get props => [user];
}

class AuthProfileUpdateSuccess extends AuthState {
  final UserModel user;
  const AuthProfileUpdateSuccess({required this.user});

  @override
  UserModel get authenticatedUser => user;

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
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
      super(const AuthInitial()) {
    _registerHandlers();
  }

  /// Temporary empty constructor for DI bootstrap.
  /// Must call [init] before dispatching any service-dependent events.
  AuthBloc.empty({AuthStorage? authStorage})
    : _authService = null,
      _authStorage = authStorage ?? const SecureStorage(),
      super(const AuthInitial()) {
    _registerHandlers();
  }

  /// Returns the service, throwing a descriptive error if [init] was not called.
  AuthRepository get _requireService {
    final s = _authService;
    if (s == null) {
      throw StateError(
        'AuthBloc: _authService is null. '
        'Call init(service:) before dispatching service-dependent events.',
      );
    }
    return s;
  }

  /// Sets the service and triggers initial auth check.
  /// Must only be called on [AuthBloc.empty] instances after DioClient is constructed.
  void init({required AuthRepository service}) {
    if (_authService != null) {
      throw StateError(
        'AuthBloc.init() must only be called on instances created with AuthBloc.empty().',
      );
    }
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
    emit(const AuthLoading());
    try {
      final token = await _authStorage.read(StorageKeys.authToken);
      final userData = await _authStorage.read(StorageKeys.userData);

      if (token != null && userData != null) {
        final user = UserModel.fromJson(jsonDecode(userData));
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Login with email/password
  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _requireService.login(event.email, event.password);

      await _authStorage.write(StorageKeys.authToken, user.token);
      await _authStorage.write(StorageKeys.userData, jsonEncode(user.toJson()));

      emit(AuthAuthenticated(user: user));
    } on DioException catch (e) {
      emit(AuthError(message: DioErrorMapper.toMessage(e)));
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
    emit(const AuthLoading());
    try {
      final user = await _requireService.register(
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

      await _authStorage.write(StorageKeys.authToken, user.token);
      await _authStorage.write(StorageKeys.userData, jsonEncode(user.toJson()));

      emit(AuthAuthenticated(user: user));
    } on DioException catch (e) {
      emit(AuthError(message: DioErrorMapper.toMessage(e)));
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
    final currentUser = state.authenticatedUser;

    if (currentUser == null) {
      emit(const AuthError(message: 'Authentication required to update profile.'));
      return;
    }

    emit(const AuthLoading());
    try {
      final updatedUser = await _requireService.updateProfile(
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

      await _authStorage.write(StorageKeys.userData, jsonEncode(updatedUser.toJson()));

      emit(AuthProfileUpdateSuccess(user: updatedUser));
    } on DioException catch (e) {
      emit(AuthError(message: DioErrorMapper.toMessage(e)));
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
    for (final key in StorageKeys.all) {
      try {
        await _authStorage.delete(key);
      } catch (_) {
        // Per-key failure is non-fatal — continue deleting remaining keys
      }
    }
    emit(const AuthUnauthenticated());
  }


}
