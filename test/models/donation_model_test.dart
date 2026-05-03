import 'package:flutter_test/flutter_test.dart';
import 'package:carelink_app/data/models/donation_model.dart';
import 'package:carelink_app/data/models/donation_status.dart';
import 'package:carelink_app/data/models/medicine_unit.dart';

void main() {
  // ═══════════════════════════════════════════════════
  // DonationModel JSON roundtrip
  // ═══════════════════════════════════════════════════
  group('DonationModel', () {
    final json = {
      'id': 'don-1',
      'medicineId': 'med-1',
      'medicineName': 'Aspirin',
      'donorId': 'user-1',
      'donorName': 'Ahmed',
      'status': 'approved',
      'qrCode': 'QR-DON-001',
      'quantity': 10,
      'unit': 'box',
      'notes': 'test notes',
      'boxImagePath': '/images/box.png',
      'reviewReason': null,
      'reviewedBy': null,
      'pharmacyId': 'pharm-1',
      'pharmacyName': 'Health Plus',
      'createdAt': '2026-01-01T00:00:00.000',
    };

    test('fromJson → toJson roundtrip preserves all fields', () {
      final model = DonationModel.fromJson(json);
      final output = model.toJson();

      expect(output['id'], 'don-1');
      expect(output['medicineId'], 'med-1');
      expect(output['medicineName'], 'Aspirin');
      expect(output['donorId'], 'user-1');
      expect(output['donorName'], 'Ahmed');
      expect(output['status'], 'approved');
      expect(output['qrCode'], 'QR-DON-001');
      expect(output['quantity'], 10);
      expect(output['unit'], 'box');
      expect(output['notes'], 'test notes');
      expect(output['pharmacyId'], 'pharm-1');
      expect(output['pharmacyName'], 'Health Plus');

      // Roundtrip check
      final roundtrip = DonationModel.fromJson(output);
      expect(roundtrip.id, model.id);
      expect(roundtrip.medicineName, model.medicineName);
      expect(roundtrip.quantity, model.quantity);
    });

    test('missing fields get defaults', () {
      final model = DonationModel.fromJson({
        'status': 'pending',
        'createdAt': '2026-01-01T00:00:00.000',
      });

      expect(model.id, '');
      expect(model.medicineId, '');
      expect(model.medicineName, '');
      expect(model.donorId, '');
      expect(model.donorName, '');
      expect(model.status, DonationStatus.pending);
      expect(model.quantity, 0);
      expect(model.notes, '');
      expect(model.qrCode, isNull);
      expect(model.pharmacyId, isNull);
    });

    // ═══════════════════════════════════════════════════
    // Status getters
    // ═══════════════════════════════════════════════════
    group('status getters', () {
      test('isPending', () {
        final m = DonationModel.fromJson({...json, 'status': 'pending'});
        expect(m.isPending, true);
        expect(m.isApproved, false);
        expect(m.isRejected, false);
        expect(m.isDelivered, false);
      });

      test('isApproved with QR shows canShowQr', () {
        final m = DonationModel.fromJson({
          ...json,
          'status': 'approved',
          'qrCode': 'QR-1',
        });
        expect(m.isApproved, true);
        expect(m.hasQrCode, true);
        expect(m.canShowQr, true);
      });

      test('isRejected allows resubmit', () {
        final m = DonationModel.fromJson({...json, 'status': 'rejected'});
        expect(m.isRejected, true);
        expect(m.isRejectedPermanent, false);
        expect(m.canResubmit, true);
      });

      test('isRejectedPermanent blocks resubmit', () {
        final m = DonationModel.fromJson({
          ...json,
          'status': 'rejectedPermanent',
        });
        expect(m.isRejected, true);
        expect(m.isRejectedPermanent, true);
        expect(m.canResubmit, false);
      });

      test('isDelivered hides QR', () {
        final m = DonationModel.fromJson({
          ...json,
          'status': 'delivered',
          'qrCode': 'QR-1',
        });
        expect(m.isDelivered, true);
        expect(m.hasQrCode, true);
        expect(m.canShowQr, false);
      });

      test('isDelivering shows QR', () {
        final m = DonationModel.fromJson({
          ...json,
          'status': 'delivering',
          'qrCode': 'QR-1',
        });
        expect(m.isDelivering, true);
        expect(m.canShowQr, true);
      });

      test('hasQrCode is false when null', () {
        final m = DonationModel.fromJson({...json, 'qrCode': null});
        expect(m.hasQrCode, false);
      });

      test('hasQrCode is false when empty', () {
        final m = DonationModel.fromJson({...json, 'qrCode': ''});
        expect(m.hasQrCode, false);
      });
    });

    // ═══════════════════════════════════════════════════
    // MedicineUnit parsing
    // ═══════════════════════════════════════════════════
    group('unit parsing', () {
      test('parses box unit', () {
        final m = DonationModel.fromJson({...json, 'unit': 'box'});
        expect(m.unit, MedicineUnit.box);
      });

      test('parses strip unit', () {
        final m = DonationModel.fromJson({...json, 'unit': 'strip'});
        expect(m.unit, MedicineUnit.strip);
      });

      test('defaults to box for null unit', () {
        final m = DonationModel.fromJson({...json, 'unit': null});
        expect(m.unit, MedicineUnit.box);
      });
    });

    // ═══════════════════════════════════════════════════
    // Equatable
    // ═══════════════════════════════════════════════════
    test('two models with same data are equal', () {
      final a = DonationModel.fromJson(json);
      final b = DonationModel.fromJson(json);
      expect(a, equals(b));
    });
  });
}
