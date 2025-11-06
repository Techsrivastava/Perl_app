import 'package:university_app_2/config/constants.dart';

enum CommissionType { percentage, flat, oneTime }

class Consultancy {
  final String id;
  final String name;
  final String email;
  final String phone;
  final CommissionType commissionType;
  final double commissionValue;
  final String status;
  final int studentsCount;
  final double totalCommission;
  final DateTime createdAt;
  final DateTime updatedAt;

  Consultancy({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.commissionType,
    required this.commissionValue,
    required this.status,
    required this.studentsCount,
    required this.totalCommission,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Consultancy.fromJson(Map<String, dynamic> json) {
    return Consultancy(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      commissionType: _parseCommissionType(json['commissionType']),
      commissionValue: (json['commissionValue'] ?? 0).toDouble(),
      status: json['status'] ?? AppConstants.statusActive,
      studentsCount: json['studentsCount'] ?? 0,
      totalCommission: (json['totalCommission'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  static CommissionType _parseCommissionType(String? type) {
    switch (type) {
      case 'percentage':
        return CommissionType.percentage;
      case 'flat':
        return CommissionType.flat;
      case 'oneTime':
        return CommissionType.oneTime;
      default:
        return CommissionType.percentage;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'commissionType': commissionType.name,
      'commissionValue': commissionValue,
      'status': status,
      'studentsCount': studentsCount,
      'totalCommission': totalCommission,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Consultancy copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    CommissionType? commissionType,
    double? commissionValue,
    String? status,
    int? studentsCount,
    double? totalCommission,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Consultancy(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      commissionType: commissionType ?? this.commissionType,
      commissionValue: commissionValue ?? this.commissionValue,
      status: status ?? this.status,
      studentsCount: studentsCount ?? this.studentsCount,
      totalCommission: totalCommission ?? this.totalCommission,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CommissionTransaction {
  final String id;
  final String consultancyId;
  final String studentId;
  final String courseId;
  final CommissionType commissionType;
  final double commissionValue;
  final double courseFees;
  final double calculatedCommission;
  final DateTime transactionDate;
  final String status;
  final String studentName;
  final String courseName;
  final String consultancyName;

  CommissionTransaction({
    required this.id,
    required this.consultancyId,
    required this.studentId,
    required this.courseId,
    required this.commissionType,
    required this.commissionValue,
    required this.courseFees,
    required this.calculatedCommission,
    required this.transactionDate,
    required this.status,
    required this.studentName,
    required this.courseName,
    required this.consultancyName,
  });

  factory CommissionTransaction.fromJson(Map<String, dynamic> json) {
    return CommissionTransaction(
      id: json['id'] ?? '',
      consultancyId: json['consultancyId'] ?? '',
      studentId: json['studentId'] ?? '',
      courseId: json['courseId'] ?? '',
      commissionType: Consultancy._parseCommissionType(json['commissionType']),
      commissionValue: (json['commissionValue'] ?? 0).toDouble(),
      courseFees: (json['courseFees'] ?? 0).toDouble(),
      calculatedCommission: (json['calculatedCommission'] ?? 0).toDouble(),
      transactionDate: DateTime.parse(
        json['transactionDate'] ?? DateTime.now().toIso8601String(),
      ),
      status: json['status'] ?? 'Pending',
      studentName: json['studentName'] ?? '',
      courseName: json['courseName'] ?? '',
      consultancyName: json['consultancyName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consultancyId': consultancyId,
      'studentId': studentId,
      'courseId': courseId,
      'commissionType': commissionType.name,
      'commissionValue': commissionValue,
      'courseFees': courseFees,
      'calculatedCommission': calculatedCommission,
      'transactionDate': transactionDate.toIso8601String(),
      'status': status,
      'studentName': studentName,
      'courseName': courseName,
      'consultancyName': consultancyName,
    };
  }
}
