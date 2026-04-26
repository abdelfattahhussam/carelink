import '../../data/models/request_model.dart';

/// Abstract request repository contract.
abstract class RequestRepository {
  /// Create a new medicine request
  Future<RequestModel> createRequest({
    required String medicineId,
    required String patientNationalId,
    required int quantity,
    required bool isUrgent,
    required String reason,
    String? prescriptionPath,
  });

  /// Get all requests (filtered by role on server side)
  Future<List<RequestModel>> getRequests();

  /// Approve or reject a patient request — pharmacist only
  Future<RequestModel> approveRequest({
    required String requestId,
    required String action,
    int? approvedBoxes,
    int? approvedStrips,
    String? reviewReason,
  });

  /// Update request status (for QR confirmation flow)
  Future<RequestModel> updateRequestStatus(String id, String status);
}
