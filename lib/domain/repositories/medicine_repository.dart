import '../../data/models/medicine_model.dart';

/// Abstract medicine repository contract.
abstract class MedicineRepository {
  /// Get all approved medicines
  Future<List<MedicineModel>> getMedicines();

  /// Search medicines by name or category
  Future<List<MedicineModel>> searchMedicines(String query);
}
