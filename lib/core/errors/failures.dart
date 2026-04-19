import 'package:equatable/equatable.dart';

/// Base failure class for clean error handling
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server-side failure (API errors)
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Cache/local storage failure
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Network connectivity failure
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

/// Authentication failure (401, expired token, etc.)
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed'});
}

/// Validation failure (form/input errors)
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}
