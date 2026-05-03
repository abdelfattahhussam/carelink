import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../domain/repositories/qr_repository.dart';
import 'service_helpers.dart';

/// QR code verification service
class QrService implements QrRepository {
  final Dio _dio;
  QrService({required Dio dio}) : _dio = dio;

  /// Verify a scanned QR code against the backend
  @override
  Future<Map<String, dynamic>> verifyQr(String qrCode) async {
    return guardedDioCall(
      () => _dio.post(
        ApiEndpoints.verifyQr,
        data: {'qrCode': qrCode},
      ),
      (data) => data as Map<String, dynamic>,
    );
  }

  /// Update status of a donation or request (for confirmation workflow)
  @override
  Future<void> updateStatus(String id, String type, String status) async {
    final endpoint = type == 'donation'
        ? ApiEndpoints.donations
        : ApiEndpoints.requests;
    return guardedDioCall(
      () => _dio.post(
        '$endpoint/$id/status',
        data: {'status': status},
      ),
      (_) {},
    );
  }
}
