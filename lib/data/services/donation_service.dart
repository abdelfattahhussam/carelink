import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/failures.dart';
import '../models/donation_model.dart';

/// Donation API service
class DonationService {
  final Dio _dio;
  DonationService({required Dio dio}) : _dio = dio;

  /// Create a new medicine donation
  Future<DonationModel> createDonation({
    required String name,
    required String notes,
    required String expiryDate,
    required int quantity,
    required String unit,
    String? category,
    String? boxImagePath,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.donations,
      data: {
        'name': name,
        'notes': notes,
        'expiryDate': expiryDate,
        'quantity': quantity,
        'unit': unit,
        'category': category ?? 'General',
        'boxImagePath': boxImagePath,
      },
    );

    if (response.statusCode == 201 && response.data['success'] == true) {
      return DonationModel.fromJson(response.data['data']);
    }
    throw ServerFailure(message: response.data['error'] ?? 'Failed to create donation');
  }

  /// Get all donations (filtered by role on server side)
  Future<List<DonationModel>> getDonations() async {
    final response = await _dio.get(ApiEndpoints.donations);

    if (response.statusCode == 200 && response.data['success'] == true) {
      final list = response.data['data'] as List;
      return list.map((e) => DonationModel.fromJson(e)).toList();
    }
    throw ServerFailure(message: 'Failed to fetch donations');
  }

  /// Get pending donations for pharmacist review
  Future<List<DonationModel>> getPendingDonations() async {
    final response = await _dio.get(ApiEndpoints.pendingDonations);

    if (response.statusCode == 200 && response.data['success'] == true) {
      final list = response.data['data'] as List;
      return list.map((e) => DonationModel.fromJson(e)).toList();
    }
    throw ServerFailure(message: 'Failed to fetch pending donations');
  }

  /// Review a donation (approve or reject) — pharmacist only
  Future<DonationModel> reviewDonation({
    required String donationId,
    required String action, // 'approve' or 'reject'
    String? notes,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.reviewDonation,
      data: {
        'donationId': donationId,
        'action': action,
        'notes': notes ?? '',
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return DonationModel.fromJson(response.data['data']);
    }
    throw ServerFailure(message: response.data['error'] ?? 'Review failed');
  }

  /// Update donation status (for QR confirmation flow)
  Future<DonationModel> updateDonationStatus(String id, String status) async {
    final response = await _dio.post(
      '${ApiEndpoints.donations}/$id/status',
      data: {'status': status},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return DonationModel.fromJson(response.data['data']);
    }
    throw ServerFailure(message: response.data['error'] ?? 'Status update failed');
  }
}
