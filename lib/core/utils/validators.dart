/// Input validators for forms
class Validators {
  Validators._();

  static String? email(String? value, {
    String requiredMsg = 'Email is required',
    String invalidMsg = 'Please enter a valid email',
  }) {
    if (value == null || value.isEmpty) {
      return requiredMsg;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return invalidMsg;
    }
    return null;
  }

  static String? password(String? value, {
    String requiredMsg = 'Password is required',
    String weakMsg = 'Password must be at least 6 characters',
  }) {
    if (value == null || value.isEmpty) {
      return requiredMsg;
    }
    if (value.length < 6) {
      return weakMsg;
    }
    return null;
  }

  static String? confirmPassword(String? value, String password, {
    String requiredMsg = 'Please confirm your password',
    String mismatchMsg = 'Passwords do not match',
  }) {
    if (value == null || value.isEmpty) {
      return requiredMsg;
    }
    if (value != password) {
      return mismatchMsg;
    }
    return null;
  }

  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? phone(String? value, {
    String requiredMsg = 'Phone number is required',
    String invalidMsg = 'Please enter a valid phone number',
  }) {
    if (value == null || value.isEmpty) {
      return requiredMsg;
    }
    final phoneRegex = RegExp(r'^\d{11}$');
    if (!phoneRegex.hasMatch(value)) {
      return invalidMsg;
    }
    return null;
  }

  static String? quantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }
    final qty = int.tryParse(value);
    if (qty == null || qty <= 0) {
      return 'Please enter a valid quantity';
    }
    return null;
  }

  static String? nationalId(String? value, String errorRequired, String errorInvalid) {
    if (value == null || value.trim().isEmpty) {
      return errorRequired;
    }
    final nationalIdRegex = RegExp(r'^\d{14}$');
    if (!nationalIdRegex.hasMatch(value)) {
      return errorInvalid;
    }
    return null;
  }
}
