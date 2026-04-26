import '../../data/models/donation_model.dart';

/// Abstract donation repository contract.
abstract class DonationRepository {
  /// Create a new medicine donation
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
  });

  /// Get all donations (filtered by role on server side)
  Future<List<DonationModel>> getDonations();

  /// Get pending donations for pharmacist review
  Future<List<DonationModel>> getPendingDonations();

  /// Review a donation (approve or reject) — pharmacist only
  Future<DonationModel> reviewDonation({
    required String donationId,
    required String action,
    String? notes,
  });

  /// Update donation status (for QR confirmation flow)
  Future<DonationModel> updateDonationStatus(String id, String status);
}
