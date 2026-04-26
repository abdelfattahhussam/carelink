import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/request_repository.dart';
import '../models/request_model.dart';

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
    final response = await _dio.post(
      ApiEndpoints.requests,
      data: {
        'medicineId': medicineId,
        'patientNationalId': patientNationalId,
        'quantity': quantity,
        'isUrgent': isUrgent,
        'reason': reason,
        'prescriptionPath': ?prescriptionPath,
      },
    );

    if (response.statusCode == 201 && response.data['success'] == true) {
      return RequestModel.fromJson(response.data['data']);
    }
    throw ServerFailure(
      message: response.data['error'] ?? 'Failed to create request',
    );
  }

  /// Update request status (for QR confirmation flow)
  @override
  Future<RequestModel> updateRequestStatus(String id, String status) async {
    final response = await _dio.post(
      '${ApiEndpoints.requests}/$id/status',
      data: {'status': status},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return RequestModel.fromJson(response.data['data']);
    }
    throw ServerFailure(
      message: response.data['error'] ?? 'Status update failed',
    );
  }

  /// Get all requests (filtered by role on server side)
  @override
  Future<List<RequestModel>> getRequests() async {
    final response = await _dio.get(ApiEndpoints.requests);

    if (response.statusCode == 200 && response.data['success'] == true) {
      final list = response.data['data'] as List;
      return list.map((e) => RequestModel.fromJson(e)).toList();
    }
    throw const ServerFailure(message: 'Failed to fetch requests');
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
    final response = await _dio.post(
      ApiEndpoints.approveRequest,
      data: {
        'requestId': requestId,
        'action': action,
        'approvedBoxes': ?approvedBoxes,
        'approvedStrips': ?approvedStrips,
        'reviewReason': ?reviewReason,
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return RequestModel.fromJson(response.data['data']);
    }
    throw ServerFailure(message: response.data['error'] ?? 'Action failed');
  }
}
