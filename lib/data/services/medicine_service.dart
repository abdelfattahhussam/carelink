import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/failures.dart';
import '../models/medicine_model.dart';

/// Medicine API service
class MedicineService {
  final Dio _dio;
  MedicineService({required Dio dio}) : _dio = dio;

  /// Get all approved medicines
  Future<List<MedicineModel>> getMedicines() async {
    final response = await _dio.get(ApiEndpoints.medicines);

    if (response.statusCode == 200 && response.data['success'] == true) {
      final list = response.data['data'] as List;
      return list.map((e) => MedicineModel.fromJson(e)).toList();
    }
    throw ServerFailure(message: response.data['error'] ?? 'Failed to fetch medicines');
  }

  /// Search medicines by name or category
  Future<List<MedicineModel>> searchMedicines(String query) async {
    final response = await _dio.get(
      ApiEndpoints.searchMedicines,
      queryParameters: {'q': query},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final list = response.data['data'] as List;
      return list.map((e) => MedicineModel.fromJson(e)).toList();
    }
    throw ServerFailure(message: response.data['error'] ?? 'Search failed');
  }
}
