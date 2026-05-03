import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../domain/repositories/donation_repository.dart';
import '../models/donation_model.dart';
import 'service_helpers.dart';

/// Donation API service
class DonationService implements DonationRepository {
  final Dio _dio;
  DonationService({required Dio dio}) : _dio = dio;

  /// Create a new medicine donation
  @override
  Future<DonationModel> createDonation({
    required String name,
    required String notes,
    required String expiryDate,
    required int quantity,
    required String unit,
    String? category,
    String? boxImagePath,
    required String pharmacyId,
    required String pharmacyName,
  }) async {
    return guardedDioCall(
      () => _dio.post(
        ApiEndpoints.donations,
        data: {
          'name': name,
          'notes': notes,
          'expiryDate': expiryDate,
          'quantity': quantity,
          'unit': unit,
          'category': category ?? 'General',
          'boxImagePath': boxImagePath,
          'pharmacyId': pharmacyId,
          'pharmacyName': pharmacyName,
        },
      ),
      (data) => DonationModel.fromJson(data['data']),
    );
  }

  /// Get all donations (filtered by role on server side)
  @override
  Future<List<DonationModel>> getDonations() async {
    return guardedDioCall(
      () => _dio.get(ApiEndpoints.donations),
      (data) {
        final list = data['data'] as List;
        return list.map((e) => DonationModel.fromJson(e)).toList();
      },
    );
  }

  /// Get pending donations for pharmacist review
  @override
  Future<List<DonationModel>> getPendingDonations() async {
    return guardedDioCall(
      () => _dio.get(ApiEndpoints.pendingDonations),
      (data) {
        final list = data['data'] as List;
        return list.map((e) => DonationModel.fromJson(e)).toList();
      },
    );
  }

  /// Review a donation (approve or reject) — pharmacist only
  @override
  Future<DonationModel> reviewDonation({
    required String donationId,
    required String action, // 'approve' or 'reject'
    String? notes,
  }) async {
    return guardedDioCall(
      () => _dio.post(
        ApiEndpoints.reviewDonation,
        data: {
          'donationId': donationId,
          'action': action,
          'notes': notes ?? '',
        },
      ),
      (data) => DonationModel.fromJson(data['data']),
    );
  }

  /// Update donation status (for QR confirmation flow)
  @override
  Future<DonationModel> updateDonationStatus(String id, String status) async {
    return guardedDioCall(
      () => _dio.post(
        '${ApiEndpoints.donations}/$id/status',
        data: {'status': status},
      ),
      (data) => DonationModel.fromJson(data['data']),
    );
  }
}
