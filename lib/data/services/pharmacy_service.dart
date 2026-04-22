import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/failures.dart';
import '../models/pharmacy_model.dart';

/// Pharmacy API service — fetches pharmacy listings with optional filters
class PharmacyService {
  final Dio _dio;
  PharmacyService({required Dio dio}) : _dio = dio;

  /// Get pharmacies, optionally filtered by location
  Future<List<PharmacyModel>> getPharmacies({
    String? governorate,
    String? city,
    String? district,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.pharmacies,
      queryParameters: {
        if (governorate != null) 'governorate': governorate,
        if (city != null) 'city': city,
        if (district != null) 'district': district,
      },
    );
    if (response.statusCode == 200 && response.data['success'] == true) {
      final list = response.data['data'] as List;
      return list.map((e) => PharmacyModel.fromJson(e)).toList();
    }
    throw ServerFailure(message: 'Failed to fetch pharmacies');
  }

  /// Get the pharmacy owned by a specific pharmacist
  Future<PharmacyModel?> getPharmacyByPharmacist(String pharmacistId) async {
    final response = await _dio.get(
      ApiEndpoints.pharmacyByPharmacist(pharmacistId),
    );
    if (response.statusCode == 200 && response.data['success'] == true) {
      return PharmacyModel.fromJson(response.data['data']);
    }
    return null;
  }
}
