import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/pharmacy_repository.dart';
import '../models/pharmacy_model.dart';
import 'service_helpers.dart';

/// Pharmacy API service — fetches pharmacy listings with optional filters
class PharmacyService implements PharmacyRepository {
  final Dio _dio;
  PharmacyService({required Dio dio}) : _dio = dio;

  /// Get pharmacies, optionally filtered by location
  @override
  Future<List<PharmacyModel>> getPharmacies({
    String? governorate,
    String? city,
    String? district,
  }) async {
    return guardedDioCall(
      () => _dio.get(
        ApiEndpoints.pharmacies,
        queryParameters: {
          'governorate': ?governorate,
          'city': ?city,
          'district': ?district,
        },
      ),
      (data) {
        final list = data['data'] as List;
        return list.map((e) => PharmacyModel.fromJson(e)).toList();
      },
    );
  }

  /// Get the pharmacy owned by a specific pharmacist.
  ///
  /// Returns `null` when the backend reports no pharmacy for this user
  /// (e.g. 404 or `success: false`), rather than throwing.
  @override
  Future<PharmacyModel?> getPharmacyByPharmacist(String pharmacistId) async {
    try {
      return await guardedDioCall(
        () => _dio.get(ApiEndpoints.pharmacyByPharmacist(pharmacistId)),
        (data) => PharmacyModel.fromJson(data['data']),
      );
    } on ServerFailure {
      // "No pharmacy found" is a valid domain state, not an error.
      return null;
    }
  }
}
