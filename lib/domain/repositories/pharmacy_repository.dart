import '../../data/models/pharmacy_model.dart';

/// Abstract pharmacy repository contract.
abstract class PharmacyRepository {
  /// Get pharmacies, optionally filtered by location
  Future<List<PharmacyModel>> getPharmacies({
    String? governorate,
    String? city,
    String? district,
  });

  /// Get the pharmacy owned by a specific pharmacist
  Future<PharmacyModel?> getPharmacyByPharmacist(String pharmacistId);
}
