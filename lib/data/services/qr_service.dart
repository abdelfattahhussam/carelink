import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/failures.dart';

/// QR code verification service
class QrService {
  final Dio _dio;
  QrService({required Dio dio}) : _dio = dio;

  /// Verify a scanned QR code against the backend
  Future<Map<String, dynamic>> verifyQr(String qrCode) async {
    final response = await _dio.post(
      ApiEndpoints.verifyQr,
      data: {'qrCode': qrCode},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data;
    }
    throw ServerFailure(message: response.data['error'] ?? 'QR verification failed');
  }

  /// Update status of a donation or request (for confirmation workflow)
  Future<void> updateStatus(String id, String type, String status) async {
    final endpoint = type == 'donation' ? ApiEndpoints.donations : ApiEndpoints.requests;
    await _dio.post(
      '$endpoint/$id/status',
      data: {'status': status},
    );
  }
}
