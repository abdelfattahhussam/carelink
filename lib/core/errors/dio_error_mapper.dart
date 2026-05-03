import 'dart:io';
import 'package:dio/dio.dart';

/// Converts a [DioException] to a user-friendly error message.
/// Centralises all Dio error handling — single source of truth.
class DioErrorMapper {
  const DioErrorMapper._();

  static String toMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Server is taking too long to respond. Please try again.';
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          return data['error']?.toString() ??
              data['message']?.toString() ??
              'Server error (${e.response?.statusCode})';
        }
        return 'Server error (${e.response?.statusCode})';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return 'No internet connection. Please check your network.';
        }
        return 'An unexpected error occurred.';
      default:
        return e.message ?? 'An unexpected error occurred.';
    }
  }
}
