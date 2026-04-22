import 'package:equatable/equatable.dart';
import 'package:carelink_app/data/models/medicine_unit.dart';

/// Donation model — tracks a medicine donation through the review pipeline
class DonationModel extends Equatable {
  final String id;
  final String medicineId;
  final String medicineName;
  final String donorId;
  final String donorName;
  final String status; // 'pending', 'approved', 'rejected', 'rejectedPermanent'
  final String? qrCode; // Generated only after approval
  final int quantity;
  final MedicineUnit unit;
  final String notes;
  final String? boxImagePath; // Added box image path
  final String? reviewReason;
  final String? reviewedBy;
  final String? pharmacyId; // Nullable for backward compat
  final String? pharmacyName;
  final DateTime createdAt;

  const DonationModel({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.donorId,
    required this.donorName,
    required this.status,
    this.qrCode,
    required this.quantity,
    required this.unit,
    required this.notes,
    this.boxImagePath,
    this.reviewReason,
    this.reviewedBy,
    this.pharmacyId,
    this.pharmacyName,
    required this.createdAt,
  });

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected' || status == 'rejectedPermanent';
  bool get isRejectedPermanent => status == 'rejectedPermanent';
  bool get canResubmit => isRejected && !isRejectedPermanent;
  bool get isDelivered => status == 'delivered';
  bool get isDelivering => status == 'delivering';
  bool get hasQrCode => qrCode != null && qrCode!.isNotEmpty;
  /// Whether the QR code should be visible — only for active (non-finalized) statuses
  bool get canShowQr => hasQrCode && (isApproved || isDelivering);

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['id'] ?? '',
      medicineId: json['medicineId'] ?? '',
      medicineName: json['medicineName'] ?? '',
      donorId: json['donorId'] ?? '',
      donorName: json['donorName'] ?? '',
      status: json['status'] ?? 'pending',
      qrCode: json['qrCode'],
      quantity: json['quantity'] ?? 0,
      unit: MedicineUnit.fromJson(json['unit']?.toString()),
      notes: json['notes'] ?? '',
      boxImagePath: json['boxImagePath'],
      reviewReason: json['reviewReason'],
      reviewedBy: json['reviewedBy'],
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
      'medicineId': medicineId,
      'medicineName': medicineName,
      'donorId': donorId,
      'donorName': donorName,
      'status': status,
      'qrCode': qrCode,
      'quantity': quantity,
      'unit': unit.toJson(),
      'notes': notes,
      'boxImagePath': boxImagePath,
      'reviewReason': reviewReason,
      'reviewedBy': reviewedBy,
      'pharmacyId': pharmacyId,
      'pharmacyName': pharmacyName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        medicineId,
        medicineName,
        donorId,
        donorName,
        status,
        qrCode,
        quantity,
        unit,
        notes,
        boxImagePath,
        reviewReason,
        reviewedBy,
        pharmacyId,
        pharmacyName,
        createdAt,
      ];
}
