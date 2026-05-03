import 'package:dio/dio.dart';
import '../../core/errors/failures.dart';

/// Unified Dio call wrapper — handles both transport-level and
/// application-level errors in a single layer.
///
/// [call] produces the raw [Response].
/// [onSuccess] parses the response data on the happy path.
///
/// **Error strategy:**
/// 1. If Dio throws (network error, timeout), catch and wrap.
/// 2. If the response arrives but `data['success'] != true`, extract the
///    error message from the response body and throw [ServerFailure].
/// 3. If `response.data` is not a Map (e.g. HTML 502 page), detect and fail
///    with a generic message + status code.
Future<T> guardedDioCall<T>(
  Future<Response> Function() call,
  T Function(dynamic data) onSuccess,
) async {
  try {
    final response = await call();
    final data = response.data;

    // Guard: response body must be a JSON Map
    if (data is! Map<String, dynamic>) {
      throw ServerFailure(
        message: 'Unexpected response format',
        statusCode: response.statusCode,
      );
    }

    // Guard: API-level success flag
    if (data['success'] != true) {
      throw ServerFailure(
        message: data['error']?.toString() ??
            data['message']?.toString() ??
            'Request failed',
        statusCode: response.statusCode,
      );
    }

    return onSuccess(data);
  } on ServerFailure {
    // Don't double-wrap our own failures
    rethrow;
  } on DioException catch (e) {
    final data = e.response?.data;
    final message = (data is Map<String, dynamic>)
        ? data['error']?.toString() ?? data['message']?.toString()
        : null;
    throw ServerFailure(
      message: message ?? e.message ?? 'An unexpected error occurred',
      statusCode: e.response?.statusCode,
    );
  }
}
