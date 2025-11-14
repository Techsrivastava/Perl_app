class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult({required this.isValid, this.errorMessage});

  factory ValidationResult.success() => ValidationResult(isValid: true);
  factory ValidationResult.error(String message) => 
      ValidationResult(isValid: false, errorMessage: message);
}

class ValidationService {
  /// Validate actual fee against university fee
  static ValidationResult validateActualFee({
    required double actualFee,
    required double universityFee,
  }) {
    if (actualFee < universityFee) {
      return ValidationResult.error(
        'Actual fee must be ≥ university fee (₹${universityFee.toStringAsFixed(0)})'
      );
    }
    return ValidationResult.success();
  }

  /// Validate agent admission
  static ValidationResult validateAgentAdmission({
    required bool isAgentAdmission,
    required String? agentCode,
    required String? agentName,
  }) {
    if (isAgentAdmission) {
      if (agentCode == null || agentCode.isEmpty) {
        return ValidationResult.error('Agent code is required');
      }
      if (agentName == null || agentName.isEmpty) {
        return ValidationResult.error('Please search and select agent');
      }
    }
    return ValidationResult.success();
  }

  /// Validate student details
  static ValidationResult validateStudentDetails({
    required String name,
    required String email,
    required String mobile,
  }) {
    if (name.isEmpty) {
      return ValidationResult.error('Name is required');
    }
    if (email.isEmpty) {
      return ValidationResult.error('Email is required');
    }
    if (mobile.isEmpty) {
      return ValidationResult.error('Mobile is required');
    }
    if (mobile.length != 10) {
      return ValidationResult.error('Mobile must be 10 digits');
    }
    return ValidationResult.success();
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate mobile format
  static bool isValidMobile(String mobile) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(mobile);
  }
}
