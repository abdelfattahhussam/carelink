import 'package:equatable/equatable.dart';
import 'package:carelink_app/data/models/medicine_status.dart';
import 'package:carelink_app/data/models/medicine_unit.dart';

/// Medicine model representing a donated medicine item
class MedicineModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime expiryDate;
  final int quantity;
  final MedicineUnit unit;
  final String donorId;
  final String donorName;
  final MedicineStatus status;
  final String imageUrl;
  final String category;
  final String? pharmacyId; // Nullable for backward compat
  final String? pharmacyName;
  final DateTime createdAt;

  const MedicineModel({
    required this.id,
    required this.name,
    required this.description,
    required this.expiryDate,
    required this.quantity,
    required this.unit,
    required this.donorId,
    required this.donorName,
    required this.status,
    required this.imageUrl,
    required this.category,
    this.pharmacyId,
    this.pharmacyName,
    required this.createdAt,
  });

  bool get isApproved => status == MedicineStatus.approved;
  bool get isPending => status == MedicineStatus.pending;
  bool get isExpired => expiryDate.isBefore(DateTime.now());
  bool get inStock => quantity > 0;

  /// Days until expiry (negative = already expired)
  int get daysUntilExpiry => expiryDate.difference(DateTime.now()).inDays;

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      expiryDate: DateTime.parse(json['expiryDate'].toString()),
      quantity: json['quantity'] ?? 0,
      unit: MedicineUnit.fromJson(json['unit']?.toString()),
      donorId: json['donorId'] ?? '',
      donorName: json['donorName'] ?? '',
      status: MedicineStatus.fromJson(json['status']?.toString()),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'General',
      pharmacyId: json['pharmacyId'],
      pharmacyName: json['pharmacyName'],
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'expiryDate': expiryDate.toIso8601String(),
      'quantity': quantity,
      'unit': unit.toJson(),
      'donorId': donorId,
      'donorName': donorName,
      'status': status.toJson(),
      'imageUrl': imageUrl,
      'category': category,
      'pharmacyId': pharmacyId,
      'pharmacyName': pharmacyName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    expiryDate,
    quantity,
    unit,
    donorId,
    donorName,
    status,
    imageUrl,
    category,
    pharmacyId,
    pharmacyName,
    createdAt,
  ];
}
