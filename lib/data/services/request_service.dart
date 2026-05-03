import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../domain/repositories/request_repository.dart';
import '../models/request_model.dart';
import 'service_helpers.dart';

/// Patient request API service
class RequestService implements RequestRepository {
  final Dio _dio;
  RequestService({required Dio dio}) : _dio = dio;

  /// Create a new medicine request
  @override
  Future<RequestModel> createRequest({
    required String medicineId,
    required String patientNationalId, // Added patient National ID
    required int quantity,
    required bool isUrgent,
    required String reason,
    String? prescriptionPath,
  }) async {
    return guardedDioCall(
      () => _dio.post(
        ApiEndpoints.requests,
        data: {
          'medicineId': medicineId,
          'patientNationalId': patientNationalId,
          'quantity': quantity,
          'isUrgent': isUrgent,
          'reason': reason,
          'prescriptionPath': ?prescriptionPath,
        },
      ),
      (data) => RequestModel.fromJson(data['data']),
    );
  }

  /// Update request status (for QR confirmation flow)
  @override
  Future<RequestModel> updateRequestStatus(String id, String status) async {
    return guardedDioCall(
      () => _dio.post(
        '${ApiEndpoints.requests}/$id/status',
        data: {'status': status},
      ),
      (data) => RequestModel.fromJson(data['data']),
    );
  }

  /// Get all requests (filtered by role on server side)
  @override
  Future<List<RequestModel>> getRequests() async {
    return guardedDioCall(
      () => _dio.get(ApiEndpoints.requests),
      (data) {
        final list = data['data'] as List;
        return list.map((e) => RequestModel.fromJson(e)).toList();
      },
    );
  }

  /// Approve or reject a patient request — pharmacist only
  @override
  Future<RequestModel> approveRequest({
    required String requestId,
    required String action, // 'approve' or 'reject'
    int? approvedBoxes,
    int? approvedStrips,
    String? reviewReason,
  }) async {
    return guardedDioCall(
      () => _dio.post(
        ApiEndpoints.approveRequest,
        data: {
          'requestId': requestId,
          'action': action,
          'approvedBoxes': ?approvedBoxes,
          'approvedStrips': ?approvedStrips,
          'reviewReason': ?reviewReason,
        },
      ),
      (data) => RequestModel.fromJson(data['data']),
    );
  }
}
