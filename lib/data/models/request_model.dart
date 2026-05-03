import 'package:equatable/equatable.dart';
import 'package:carelink_app/data/models/medicine_unit.dart';
import 'package:carelink_app/data/models/request_status.dart';

/// Request model — a patient's request for a specific medicine
class RequestModel extends Equatable {
  final String id;
  final String patientId;
  final String patientName;
  final String patientNationalId; // Added National ID for verification
  final String medicineId;
  final String medicineName;
  final int quantity;
  final MedicineUnit unit;
  final RequestStatus status;
  final bool isUrgent;
  final String reason;
  final String? qrCode; // Generated after pharmacist approval
  final String? prescriptionPath; // Added for prescription uploads
  final String? pharmacyId; // Nullable for backward compat
  final String? pharmacyName;

  // Review fields
  final int? approvedBoxes;
  final int? approvedStrips;
  final String? reviewReason;
  final String? reviewedBy;
  final DateTime? reviewedAt;

  final DateTime createdAt;

  const RequestModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientNationalId,
    required this.medicineId,
    required this.medicineName,
    required this.quantity,
    required this.unit,
    required this.status,
    required this.isUrgent,
    required this.reason,
    this.qrCode,
    this.prescriptionPath,
    this.pharmacyId,
    this.pharmacyName,
    this.approvedBoxes,
    this.approvedStrips,
    this.reviewReason,
    this.reviewedBy,
    this.reviewedAt,
    required this.createdAt,
  });

  bool get isPending => status == RequestStatus.pending;
  bool get isApproved => status == RequestStatus.approved;
  bool get isRejected => status == RequestStatus.rejected;
  bool get isDelivered => status == RequestStatus.delivered;
  bool get isDelivering => status == RequestStatus.delivering;
  bool get hasQrCode => qrCode != null && qrCode!.isNotEmpty;

  /// Whether the QR code should be visible — only for active (non-finalized) statuses
  bool get canShowQr => hasQrCode && (isApproved || isDelivering);

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      patientNationalId: json['patientNationalId'] ?? '',
      medicineId: json['medicineId'] ?? '',
      medicineName: json['medicineName'] ?? '',
      quantity: json['quantity'] ?? 1,
      unit: MedicineUnit.fromJson(json['unit']?.toString()),
      status: RequestStatus.fromJson(json['status']?.toString()),
      isUrgent: json['isUrgent'] ?? false,
      reason: json['reason'] ?? '',
      qrCode: json['qrCode'],
      prescriptionPath: json['prescriptionPath'],
      pharmacyId: json['pharmacyId'],
      pharmacyName: json['pharmacyName'],
      approvedBoxes: json['approvedBoxes'],
      approvedStrips: json['approvedStrips'],
      reviewReason: json['reviewReason'],
      reviewedBy: json['reviewedBy'],
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'patientNationalId': patientNationalId,
      'medicineId': medicineId,
      'medicineName': medicineName,
      'quantity': quantity,
      'unit': unit.toJson(),
      'status': status.toJson(),
      'isUrgent': isUrgent,
      'reason': reason,
      'qrCode': qrCode,
      'prescriptionPath': prescriptionPath,
      'pharmacyId': pharmacyId,
      'pharmacyName': pharmacyName,
      'approvedBoxes': approvedBoxes,
      'approvedStrips': approvedStrips,
      'reviewReason': reviewReason,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    patientId,
    patientName,
    patientNationalId,
    medicineId,
    medicineName,
    quantity,
    unit,
    status,
    isUrgent,
    reason,
    qrCode,
    prescriptionPath,
    pharmacyId,
    pharmacyName,
    approvedBoxes,
    approvedStrips,
    reviewReason,
    reviewedBy,
    reviewedAt,
    createdAt,
  ];
}
