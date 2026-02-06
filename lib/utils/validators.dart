import 'constants.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must not exceed ${AppConstants.maxPasswordLength} characters';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < AppConstants.minNameLength) {
      return 'Name must be at least ${AppConstants.minNameLength} characters';
    }

    if (value.length > AppConstants.maxNameLength) {
      return 'Name must not exceed ${AppConstants.maxNameLength} characters';
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  // Phone number validation (Indian format)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and special characters
    final cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanedValue.length != AppConstants.phoneNumberLength) {
      return 'Phone number must be ${AppConstants.phoneNumberLength} digits';
    }

    // Check if starts with valid Indian mobile prefix (6, 7, 8, 9)
    if (!RegExp(r'^[6-9]').hasMatch(cleanedValue)) {
      return 'Please enter a valid Indian mobile number';
    }

    return null;
  }

  // Age validation
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }

    if (age < 0 || age > 150) {
      return 'Please enter a valid age between 0 and 150';
    }

    return null;
  }

  // OTP validation
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    if (value.length != AppConstants.otpLength) {
      return 'OTP must be ${AppConstants.otpLength} digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Number validation
  static String? validateNumber(String? value, {String fieldName = 'Value'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  // Number range validation
  static String? validateNumberRange(
      String? value, {
        required double min,
        required double max,
        String fieldName = 'Value',
      }) {
    final numberValidation = validateNumber(value, fieldName: fieldName);
    if (numberValidation != null) return numberValidation;

    final number = double.parse(value!);
    if (number < min || number > max) {
      return '$fieldName must be between $min and $max';
    }

    return null;
  }

  // Blood pressure validation
  static String? validateBloodPressure(String? systolic, String? diastolic) {
    if (systolic != null && systolic.isNotEmpty) {
      final systolicValue = double.tryParse(systolic);
      if (systolicValue == null) {
        return 'Please enter valid systolic blood pressure';
      }
      if (systolicValue < 70 || systolicValue > 200) {
        return 'Systolic blood pressure should be between 70 and 200';
      }
    }

    if (diastolic != null && diastolic.isNotEmpty) {
      final diastolicValue = double.tryParse(diastolic);
      if (diastolicValue == null) {
        return 'Please enter valid diastolic blood pressure';
      }
      if (diastolicValue < 40 || diastolicValue > 130) {
        return 'Diastolic blood pressure should be between 40 and 130';
      }
    }

    return null;
  }

  // Heart rate validation
  static String? validateHeartRate(String? value) {
    if (value == null || value.isEmpty) return null; // Optional field

    final heartRate = double.tryParse(value);
    if (heartRate == null) {
      return 'Please enter a valid heart rate';
    }

    if (heartRate < 40 || heartRate > 200) {
      return 'Heart rate should be between 40 and 200 bpm';
    }

    return null;
  }

  // Temperature validation (in Celsius)
  static String? validateTemperature(String? value) {
    if (value == null || value.isEmpty) return null; // Optional field

    final temperature = double.tryParse(value);
    if (temperature == null) {
      return 'Please enter a valid temperature';
    }

    if (temperature < 35 || temperature > 42) {
      return 'Temperature should be between 35°C and 42°C';
    }

    return null;
  }

  // Blood sugar validation
  static String? validateBloodSugar(String? value) {
    if (value == null || value.isEmpty) return null; // Optional field

    final bloodSugar = double.tryParse(value);
    if (bloodSugar == null) {
      return 'Please enter a valid blood sugar level';
    }

    if (bloodSugar < 40 || bloodSugar > 600) {
      return 'Blood sugar should be between 40 and 600 mg/dL';
    }

    return null;
  }

  // Medicine dosage validation
  static String? validateDosage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Dosage is required';
    }

    if (value.length > 50) {
      return 'Dosage description is too long';
    }

    return null;
  }

  // URL validation
  static String? validateURL(String? value) {
    if (value == null || value.isEmpty) return null; // Optional field

    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // Time validation (HH:MM format)
  static String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Time is required';
    }

    final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(value)) {
      return 'Please enter time in HH:MM format';
    }

    return null;
  }

  // Date validation
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }

    final now = DateTime.now();
    if (value.isAfter(now)) {
      return 'Date cannot be in the future';
    }

    return null;
  }

  // Access code validation
  static String? validateAccessCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Access code is required';
    }

    if (value.length != 6) {
      return 'Access code must be 6 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Access code must contain only numbers';
    }

    return null;
  }

  // Custom validation with regex
  static String? validateWithRegex(
      String? value,
      String pattern,
      String errorMessage,
      ) {
    if (value == null || value.isEmpty) return null;

    if (!RegExp(pattern).hasMatch(value)) {
      return errorMessage;
    }

    return null;
  }
}