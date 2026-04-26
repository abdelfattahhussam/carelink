import 'package:equatable/equatable.dart';

/// Pharmacy model — represents a physical pharmacy location
class PharmacyModel extends Equatable {
  final String id;
  final String name;
  final String pharmacistId;
  final String governorate;
  final String city;
  final String district;
  final String address;
  final bool isActive;

  const PharmacyModel({
    required this.id,
    required this.name,
    required this.pharmacistId,
    required this.governorate,
    required this.city,
    required this.district,
    required this.address,
    required this.isActive,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      pharmacistId: json['pharmacistId'] ?? '',
      governorate: json['governorate'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      address: json['address'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'pharmacistId': pharmacistId,
    'governorate': governorate,
    'city': city,
    'district': district,
    'address': address,
    'isActive': isActive,
  };

  String get displayLocation => '$governorate — $city';
  String get fullLocation => '$governorate، $city، $district';

  @override
  List<Object?> get props => [
    id,
    name,
    pharmacistId,
    governorate,
    city,
    isActive,
  ];
}
