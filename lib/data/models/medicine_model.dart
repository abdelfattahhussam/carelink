import 'package:equatable/equatable.dart';
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
  final String status; // 'pending', 'approved', 'rejected', 'expired'
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

  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';
  bool get isExpired => expiryDate.isBefore(DateTime.now());
  bool get inStock => quantity > 0;

  /// Days until expiry (negative = already expired)
  int get daysUntilExpiry => expiryDate.difference(DateTime.now()).inDays;

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : DateTime.now().add(const Duration(days: 90)),
      quantity: json['quantity'] ?? 0,
      unit: MedicineUnit.fromJson(json['unit']?.toString()),
      donorId: json['donorId'] ?? '',
      donorName: json['donorName'] ?? '',
      status: json['status'] ?? 'pending',
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'General',
      pharmacyId: json['pharmacyId'],
      pharmacyName: json['pharmacyName'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
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
      'status': status,
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
    status,
    quantity,
    unit,
    expiryDate,
    pharmacyId,
    pharmacyName,
  ];
}
