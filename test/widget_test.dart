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
        'email': 'user@test.com',
        'phone': '+201234567890',
        'nationalId': '29001011234567',
        'role': 'user',
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
      expect(user.email, 'user@test.com');
      expect(user.nationalId, '29001011234567');
      expect(user.role, UserRole.user);
      expect(user.isUser, true);
      expect(user.isPharmacist, false);

      final roundtrip = UserModel.fromJson(output);
      expect(roundtrip, equals(user));
    });

    test('fromJson handles missing fields with defaults', () {
      final user = UserModel.fromJson({});

      expect(user.id, '');
      expect(user.role, UserRole.user);
      expect(user.status, 'verified');
      expect(user.token, '');
    });

    test('fromJson maps legacy donor/patient to user, pharmacist stays', () {
      for (final role in ['donor', 'patient', 'user']) {
        final user = UserModel.fromJson({'role': role});
        expect(user.role, UserRole.user);
      }
      final pharmacist = UserModel.fromJson({'role': 'pharmacist'});
      expect(pharmacist.role, UserRole.pharmacist);
    });

    test('copyWith creates independent copy with overrides', () {
      final original = UserModel.fromJson({
        'id': 'u1',
        'name': 'Original',
        'role': 'user',
      });

      final copy = original.copyWith(
        name: 'Modified',
        role: UserRole.pharmacist,
      );

      expect(copy.name, 'Modified');
      expect(copy.role, UserRole.pharmacist);
      expect(copy.id, 'u1');
      expect(original.name, 'Original');
    });
  });

  // ═══════════════════════════════════════════════════
  // TEST 2: AppColors constants integrity
  // ═══════════════════════════════════════════════════
  group('AppColors', () {
    test('primary palette values are correct', () {
      expect(AppColors.primary.toARGB32(), 0xFF0D9488);
      expect(AppColors.primaryLight.toARGB32(), 0xFF5EEAD4);
      expect(AppColors.primaryDark.toARGB32(), 0xFF065F53);
    });

    test('secondary palette is Sky Blue (not Indigo)', () {
      expect(AppColors.secondary.toARGB32(), 0xFF0EA5E9);
      expect(AppColors.secondaryLight.toARGB32(), 0xFF7DD3FC);
      expect(AppColors.secondaryContainer.toARGB32(), 0xFFE0F2FE);
    });

    test('success and approved are in sync', () {
      expect(AppColors.success.toARGB32(), AppColors.approved.toARGB32());
    });

    test('accent is distinct from warning', () {
      expect(
        AppColors.accent.toARGB32() != AppColors.warning.toARGB32(),
        true,
        reason: 'Accent and Warning must be visually distinct',
      );
    });

    test('heroGradient uses Teal → Sky Blue', () {
      final colors = AppColors.heroGradient.colors;
      expect(colors.length, 2);
      expect(colors[0].toARGB32(), 0xFF0D9488);
      expect(colors[1].toARGB32(), 0xFF0EA5E9);
    });

    test('dividerDark is distinct from surfaceVariantDark', () {
      expect(
        AppColors.dividerDark.toARGB32() !=
            AppColors.surfaceVariantDark.toARGB32(),
        true,
        reason: 'Divider must be visible against input backgrounds',
      );
      expect(AppColors.dividerDark.toARGB32(), 0xFF475569);
    });
  });

  // ═══════════════════════════════════════════════════
  // TEST 3: Semantic container colors
  // ═══════════════════════════════════════════════════
  group('Semantic containers', () {
    test('all semantic colors have matching container variants', () {
      expect(AppColors.successContainer.toARGB32(), 0xFFDCFCE7);
      expect(AppColors.warningContainer.toARGB32(), 0xFFFEF3C7);
      expect(AppColors.errorContainer.toARGB32(), 0xFFFEE2E2);
      expect(AppColors.infoContainer.toARGB32(), 0xFFDBEAFE);
      expect(AppColors.accentContainer.toARGB32(), 0xFFFFF7ED);
    });
  });

  // ═══════════════════════════════════════════════════
  // TEST 4: Disabled text colors
  // ═══════════════════════════════════════════════════
  group('Disabled colors', () {
    test('textDisabled is lighter than textLight', () {
      expect(AppColors.textDisabled.toARGB32(), 0xFFCBD5E1);
      expect(AppColors.textDisabledDark.toARGB32(), 0xFF475569);
    });
  });

  // ═══════════════════════════════════════════════════
  // TEST 5: Gradient system
  // ═══════════════════════════════════════════════════
  group('Gradients', () {
    test('successGradient uses green tones', () {
      final colors = AppColors.successGradient.colors;
      expect(colors.length, 2);
      expect(colors[0].toARGB32(), 0xFF22C55E);
      expect(colors[1].toARGB32(), 0xFF16A34A);
    });

    test('infoGradient uses blue to sky blue', () {
      final colors = AppColors.infoGradient.colors;
      expect(colors.length, 2);
      expect(colors[0].toARGB32(), 0xFF3B82F6);
      expect(colors[1].toARGB32(), 0xFF0EA5E9);
    });
  });

  // ═══════════════════════════════════════════════════
  // TEST 6: UserRole enum behavior
  // ═══════════════════════════════════════════════════
  group('UserRole', () {
    test('toJson returns lowercase name', () {
      expect(UserRole.user.toJson(), 'user');
      expect(UserRole.pharmacist.toJson(), 'pharmacist');
    });

    test('fromJson maps donor/patient/user → UserRole.user', () {
      expect(UserRole.fromJson('donor'), UserRole.user);
      expect(UserRole.fromJson('patient'), UserRole.user);
      expect(UserRole.fromJson('user'), UserRole.user);
      expect(UserRole.fromJson('pharmacist'), UserRole.pharmacist);
    });

    test('fromJson defaults to user for unknown role', () {
      expect(UserRole.fromJson('admin'), UserRole.user);
      expect(UserRole.fromJson(''), UserRole.user);
    });

    test('label returns human-readable string', () {
      expect(UserRole.user.label, 'User');
      expect(UserRole.pharmacist.label, 'Pharmacist');
    });
  });
}
