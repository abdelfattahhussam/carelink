import 'package:flutter_test/flutter_test.dart';
import 'package:carelink_app/core/utils/validators.dart';

void main() {
  // ═══════════════════════════════════════════════════
  // Validators.email
  // ═══════════════════════════════════════════════════
  group('Validators.email', () {
    test('returns null for valid email', () {
      expect(Validators.email('test@example.com'), isNull);
    });

    test('returns null for email with subdomain', () {
      expect(Validators.email('user@mail.example.com'), isNull);
    });

    test('returns error for empty string', () {
      expect(Validators.email('', requiredMsg: 'Req'), 'Req');
    });

    test('returns error for null', () {
      expect(Validators.email(null, requiredMsg: 'Req'), 'Req');
    });

    test('returns error for invalid format', () {
      expect(Validators.email('not-email', invalidMsg: 'Bad'), 'Bad');
    });

    test('returns error for missing domain', () {
      expect(Validators.email('user@', invalidMsg: 'Bad'), 'Bad');
    });
  });

  // ═══════════════════════════════════════════════════
  // Validators.password
  // ═══════════════════════════════════════════════════
  group('Validators.password', () {
    test('returns null for 6+ characters', () {
      expect(Validators.password('123456'), isNull);
    });

    test('returns null for long password', () {
      expect(Validators.password('a' * 20), isNull);
    });

    test('returns error for too short', () {
      expect(Validators.password('12345', weakMsg: 'Weak'), 'Weak');
    });

    test('returns error for empty', () {
      expect(Validators.password('', requiredMsg: 'Req'), 'Req');
    });

    test('returns error for null', () {
      expect(Validators.password(null, requiredMsg: 'Req'), 'Req');
    });
  });

  // ═══════════════════════════════════════════════════
  // Validators.phone
  // ═══════════════════════════════════════════════════
  group('Validators.phone', () {
    test('returns null for 11 digits', () {
      expect(Validators.phone('01234567890'), isNull);
    });

    test('returns error for wrong length', () {
      expect(Validators.phone('01234', invalidMsg: 'Bad'), 'Bad');
    });

    test('returns error for too many digits', () {
      expect(Validators.phone('012345678901', invalidMsg: 'Bad'), 'Bad');
    });

    test('returns error for empty', () {
      expect(Validators.phone('', requiredMsg: 'Req'), 'Req');
    });

    test('returns error for non-numeric', () {
      expect(Validators.phone('0123456789a', invalidMsg: 'Bad'), 'Bad');
    });
  });

  // ═══════════════════════════════════════════════════
  // Validators.nationalId
  // ═══════════════════════════════════════════════════
  group('Validators.nationalId', () {
    test('returns null for 14 digits', () {
      expect(Validators.nationalId('12345678901234', 'Req', 'Bad'), isNull);
    });

    test('returns error for wrong length', () {
      expect(Validators.nationalId('123', 'Req', 'Bad'), 'Bad');
    });

    test('returns error for empty', () {
      expect(Validators.nationalId('', 'Req', 'Bad'), 'Req');
    });

    test('returns error for null', () {
      expect(Validators.nationalId(null, 'Req', 'Bad'), 'Req');
    });

    test('returns error for non-numeric', () {
      expect(Validators.nationalId('1234567890123a', 'Req', 'Bad'), 'Bad');
    });
  });

  // ═══════════════════════════════════════════════════
  // Validators.quantity
  // ═══════════════════════════════════════════════════
  group('Validators.quantity', () {
    test('returns null for positive int', () {
      expect(Validators.quantity('5'), isNull);
    });

    test('returns null for large quantity', () {
      expect(Validators.quantity('999'), isNull);
    });

    test('returns error for zero', () {
      expect(Validators.quantity('0'), isNotNull);
    });

    test('returns error for negative', () {
      expect(Validators.quantity('-1'), isNotNull);
    });

    test('returns error for non-numeric', () {
      expect(Validators.quantity('abc'), isNotNull);
    });

    test('returns error for empty', () {
      expect(Validators.quantity(''), isNotNull);
    });
  });

  // ═══════════════════════════════════════════════════
  // Validators.required
  // ═══════════════════════════════════════════════════
  group('Validators.required', () {
    test('returns null for non-empty', () {
      expect(Validators.required('hello'), isNull);
    });

    test('returns error for empty', () {
      expect(Validators.required('', 'Field'), 'Field is required');
    });

    test('returns error for whitespace only', () {
      expect(Validators.required('   ', 'Field'), 'Field is required');
    });

    test('returns error for null', () {
      expect(Validators.required(null, 'Field'), 'Field is required');
    });
  });

  // ═══════════════════════════════════════════════════
  // Validators.confirmPassword
  // ═══════════════════════════════════════════════════
  group('Validators.confirmPassword', () {
    test('returns null when matching', () {
      expect(Validators.confirmPassword('abc123', 'abc123'), isNull);
    });

    test('returns error when mismatching', () {
      expect(
        Validators.confirmPassword(
          'abc123',
          'different',
          mismatchMsg: 'No match',
        ),
        'No match',
      );
    });

    test('returns error for empty', () {
      expect(Validators.confirmPassword('', 'any', requiredMsg: 'Req'), 'Req');
    });

    test('returns error for null', () {
      expect(
        Validators.confirmPassword(null, 'any', requiredMsg: 'Req'),
        'Req',
      );
    });
  });
}
