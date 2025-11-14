/// Common input validators for forms
class Validators {
  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    
    return null;
  }

  /// Validate password (minimum 6 characters)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  /// Validate required field
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    return null;
  }

  /// Validate phone number (Indian format)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return 'Enter a valid 10-digit phone number';
    }
    
    return null;
  }

  /// Validate number
  static String? number(String? value, [String fieldName = 'This field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    }
    
    return null;
  }

  /// Validate positive number
  static String? positiveNumber(String? value, [String fieldName = 'This field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    final numValue = double.tryParse(value);
    
    if (numValue == null) {
      return 'Enter a valid number';
    }
    
    if (numValue <= 0) {
      return '$fieldName must be greater than 0';
    }
    
    return null;
  }

  /// Validate OTP (4 digits)
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    
    if (value.length != 4) {
      return 'OTP must be 4 digits';
    }
    
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }
    
    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int length, [String fieldName = 'This field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length < length) {
      return '$fieldName must be at least $length characters';
    }
    
    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int length, [String fieldName = 'This field']) {
    if (value != null && value.length > length) {
      return '$fieldName must not exceed $length characters';
    }
    
    return null;
  }

  /// Validate URL
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Enter a valid URL';
    }
    
    return null;
  }
}
