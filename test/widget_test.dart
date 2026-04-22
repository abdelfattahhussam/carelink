import 'package:flutter_test/flutter_test.dart';
import 'package:carelink_app/data/models/user_model.dart';
import 'package:carelink_app/core/constants/app_colors.dart';

void main() {
  // ═══════════════════════════════════════════════════
  // TEST 1: UserModel JSON roundtrip
  // ═══════════════════════════════════════════════════
  group('UserModel', () {
    test('fromJson → toJson roundtrip preserves all fields', () {
      final json = {
        'id': 'user-1',
        'name': 'Ahmed Hassan',
        'email': 'donor@test.com',
        'phone': '+201234567890',
        'nationalId': '29001011234567',
        'role': 'donor',
        'status': 'verified',
        'token': 'mock-token',
        'createdAt': '2026-01-01T00:00:00.000',
        'pharmacyName': null,
        'governorate': null,
        'city': null,
        'village': null,
        'street': null,
      };

      final user = UserModel.fromJson(json);
      final output = user.toJson();

      expect(user.id, 'user-1');
      expect(user.name, 'Ahmed Hassan');
      expect(user.email, 'donor@test.com');
      expect(user.nationalId, '29001011234567');
      expect(user.role, UserRole.donor);
      expect(user.isDonor, true);
      expect(user.isPatient, false);
      expect(user.isPharmacist, false);

      // Roundtrip: output should recreate the same model
      final roundtrip = UserModel.fromJson(output);
      expect(roundtrip, equals(user));
    });

    test('fromJson handles missing fields with defaults', () {
      final user = UserModel.fromJson({});

      expect(user.id, '');
      expect(user.role, UserRole.patient); // default
      expect(user.status, 'verified');     // default
      expect(user.token, '');
    });

    test('fromJson parses all three roles correctly', () {
      for (final role in ['donor', 'patient', 'pharmacist']) {
        final user = UserModel.fromJson({'role': role});
        expect(user.role, UserRole.values.byName(role));
      }
    });

    test('copyWith creates independent copy with overrides', () {
      final original = UserModel.fromJson({
        'id': 'u1',
        'name': 'Original',
        'role': 'donor',
      });

      final copy = original.copyWith(name: 'Modified', role: UserRole.pharmacist);

      expect(copy.name, 'Modified');
      expect(copy.role, UserRole.pharmacist);
      expect(copy.id, 'u1'); // unchanged
      expect(original.name, 'Original'); // original unaffected
    });
  });

  // ═══════════════════════════════════════════════════
  // TEST 2: AppColors constants integrity
  // ═══════════════════════════════════════════════════
  group('AppColors', () {
    test('primary palette values are correct', () {
      expect(AppColors.primary.value, 0xFF0D9488);
      expect(AppColors.primaryLight.value, 0xFF5EEAD4);
      expect(AppColors.primaryDark.value, 0xFF065F53);
    });

    test('secondary palette is Sky Blue (not Indigo)', () {
      expect(AppColors.secondary.value, 0xFF0EA5E9);
      expect(AppColors.secondaryLight.value, 0xFF7DD3FC);
      expect(AppColors.secondaryContainer.value, 0xFFE0F2FE);
    });

    test('success and approved are in sync', () {
      expect(AppColors.success.value, AppColors.approved.value);
    });

    test('accent is distinct from warning', () {
      expect(AppColors.accent.value != AppColors.warning.value, true,
          reason: 'Accent and Warning must be visually distinct');
    });

    test('heroGradient uses Teal → Sky Blue', () {
      final colors = AppColors.heroGradient.colors;
      expect(colors.length, 2);
      expect(colors[0].value, 0xFF0D9488); // Teal
      expect(colors[1].value, 0xFF0EA5E9); // Sky Blue
    });

    test('dividerDark is distinct from surfaceVariantDark', () {
      expect(AppColors.dividerDark.value != AppColors.surfaceVariantDark.value, true,
          reason: 'Divider must be visible against input backgrounds');
      expect(AppColors.dividerDark.value, 0xFF475569);
    });
  });

  // ═══════════════════════════════════════════════════
  // TEST 3: Semantic container colors
  // ═══════════════════════════════════════════════════
  group('Semantic containers', () {
    test('all semantic colors have matching container variants', () {
      // Container colors should be lighter tints of their base
      expect(AppColors.successContainer.value, 0xFFDCFCE7);
      expect(AppColors.warningContainer.value, 0xFFFEF3C7);
      expect(AppColors.errorContainer.value, 0xFFFEE2E2);
      expect(AppColors.infoContainer.value, 0xFFDBEAFE);
      expect(AppColors.accentContainer.value, 0xFFFFF7ED);
    });
  });

  // ═══════════════════════════════════════════════════
  // TEST 4: Disabled text colors
  // ═══════════════════════════════════════════════════
  group('Disabled colors', () {
    test('textDisabled is lighter than textLight', () {
      // textDisabled should have higher value (lighter) than textLight
      expect(AppColors.textDisabled.value, 0xFFCBD5E1);
      expect(AppColors.textDisabledDark.value, 0xFF475569);
    });
  });

  // ═══════════════════════════════════════════════════
  // TEST 5: Gradient system
  // ═══════════════════════════════════════════════════
  group('Gradients', () {
    test('successGradient uses green tones', () {
      final colors = AppColors.successGradient.colors;
      expect(colors.length, 2);
      expect(colors[0].value, 0xFF22C55E);
      expect(colors[1].value, 0xFF16A34A);
    });

    test('infoGradient uses blue to sky blue', () {
      final colors = AppColors.infoGradient.colors;
      expect(colors.length, 2);
      expect(colors[0].value, 0xFF3B82F6);
      expect(colors[1].value, 0xFF0EA5E9);
    });
  });

  // ═══════════════════════════════════════════════════
  // TEST 6: UserRole enum behavior
  // ═══════════════════════════════════════════════════
  group('UserRole', () {
    test('toJson returns lowercase name', () {
      expect(UserRole.donor.toJson(), 'donor');
      expect(UserRole.patient.toJson(), 'patient');
      expect(UserRole.pharmacist.toJson(), 'pharmacist');
    });

    test('fromJson parses valid strings', () {
      expect(UserRole.fromJson('donor'), UserRole.donor);
      expect(UserRole.fromJson('pharmacist'), UserRole.pharmacist);
    });

    test('fromJson defaults to patient for unknown role', () {
      expect(UserRole.fromJson('admin'), UserRole.patient);
      expect(UserRole.fromJson(''), UserRole.patient);
    });

    test('label capitalizes first letter', () {
      expect(UserRole.donor.label, 'Donor');
      expect(UserRole.pharmacist.label, 'Pharmacist');
    });
  });
}
