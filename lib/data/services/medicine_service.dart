import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../models/medicine_model.dart';
import 'service_helpers.dart';

/// Medicine API service
class MedicineService implements MedicineRepository {
  final Dio _dio;
  MedicineService({required Dio dio}) : _dio = dio;

  /// Get all approved medicines
  @override
  Future<List<MedicineModel>> getMedicines() async {
    return guardedDioCall(
      () => _dio.get(ApiEndpoints.medicines),
      (data) {
        final list = data['data'] as List;
        return list.map((e) => MedicineModel.fromJson(e)).toList();
      },
    );
  }

  /// Search medicines by name or category
  @override
  Future<List<MedicineModel>> searchMedicines(String query) async {
    return guardedDioCall(
      () => _dio.get(
        ApiEndpoints.searchMedicines,
        queryParameters: {'q': query},
      ),
      (data) {
        final list = data['data'] as List;
        return list.map((e) => MedicineModel.fromJson(e)).toList();
      },
    );
  }
}
