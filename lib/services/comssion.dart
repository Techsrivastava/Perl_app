import 'package:flutter/foundation.dart';

/// Service class to handle commission calculations
class CommissionService {
  /// Stores commission rates for different courses
  final Map<String, double> _courseCommissions = {
    'computer_science': 0.10, // 10% commission
    'business': 0.12, // 12% commission
    'engineering': 0.15, // 15% commission
    'arts': 0.08, // 8% commission
  };

  /// Default commission rate for courses not in the map
  static const double defaultCommissionRate = 0.1; // 10%

  /// University-wide commission rate (if applicable)
  static const double universityWideRate = 0.08; // 8%

  /// Calculate commission for a specific course
  /// Returns the commission amount
  double calculateCourseCommission(String courseName, double amount) {
    if (amount <= 0) return 0.0;

    final commissionRate =
        _courseCommissions[courseName.toLowerCase()] ?? defaultCommissionRate;
    return amount * commissionRate;
  }

  /// Calculate university-wide commission
  double calculateUniversityWideCommission(double amount) {
    if (amount <= 0) return 0.0;
    return amount * universityWideRate;
  }

  /// Add or update a course commission rate
  void updateCourseCommission(String courseName, double rate) {
    if (rate < 0 || rate > 1) {
      throw ArgumentError('Commission rate must be between 0 and 1');
    }
    _courseCommissions[courseName] = rate;
  }

  /// Get all commission rates (returns a copy to prevent external modifications)
  Map<String, double> getAllCommissions() {
    return Map<String, double>.from(_courseCommissions);
  }
}

// Singleton instance of the CommissionService
final commissionService = CommissionService();
