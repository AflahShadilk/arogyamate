class AppValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Enter a valid number';
    }
    if (age <= 0 || age > 120) {
      return 'Enter a valid age (1-120)';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? validateFees(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Fees is required';
    }
    final fees = double.tryParse(value);
    if (fees == null || fees < 0) {
      return 'Enter a valid amount';
    }
    return null;
  }

  static String? validateExperience(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Experience is required';
    }
    final exp = int.tryParse(value);
    if (exp == null || exp < 0 || exp > 60) {
      return 'Enter a valid experience (0-60)';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
