import 'package:flutter/material.dart';
import 'package:university_app_2/models/university_model.dart';
import 'package:university_app_2/models/course_model.dart';
import 'package:university_app_2/models/student_model.dart';
import 'package:university_app_2/models/consultancy_model.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/data/indian_courses_data.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // University Data
  University get university => University(
    id: 'uni_001',
    name: 'Stanford University',
    abbreviation: 'Stanford',
    establishedYear: 1885,
    type: 'Private',
    facilities: [
      'Hostel',
      'Library',
      'Laboratories',
      'Transport',
      'Placement Cell',
      'Sports Complex',
      'Research Centers',
    ],
    documents: [
      'ugc_certificate.pdf',
      'aicte_certificate.pdf',
      'naac_certificate.pdf',
      'authorization_letter.pdf',
      'university_prospectus.pdf',
    ],
    description:
        'Stanford University is a private research university in Stanford, California. The campus occupies 8,180 acres, among the largest in the United States.',
    contactEmail: 'info@stanford.edu',
    contactPhone: '+1-650-723-2300',
    address: '450 Serra Mall, Stanford, CA 94305, USA',
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
    updatedAt: DateTime.now(),
  );

  // Courses Data - Using comprehensive Indian courses
  List<Course> get courses => IndianCoursesData.getIndianCourses();

  // Students Data
  List<Student> get students => [
    Student(
      id: 'student_001',
      name: 'John Smith',
      email: 'john.smith@email.com',
      phone: '+1-555-0123',
      courseId: 'course_001',
      consultancyId: 'consultancy_001',
      status: AppConstants.statusApproved,
      appliedDate: DateTime.now().subtract(const Duration(days: 30)),
      documents: ['Transcript', 'TOEFL', 'Passport', 'Recommendation'],
      courseName: 'Computer Science',
      consultancyName: 'EduConsult Pro',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    Student(
      id: 'student_002',
      name: 'Sarah Johnson',
      email: 'sarah.johnson@email.com',
      phone: '+1-555-0124',
      courseId: 'course_002',
      consultancyId: 'consultancy_002',
      status: AppConstants.statusPending,
      appliedDate: DateTime.now().subtract(const Duration(days: 15)),
      documents: ['Transcript', 'GMAT', 'Passport', 'Recommendation'],
      courseName: 'Business Administration',
      consultancyName: 'Global Education Hub',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now(),
    ),
    Student(
      id: 'student_003',
      name: 'Michael Brown',
      email: 'michael.brown@email.com',
      phone: '+1-555-0125',
      courseId: 'course_001',
      consultancyId: 'consultancy_001',
      status: AppConstants.statusApproved,
      appliedDate: DateTime.now().subtract(const Duration(days: 45)),
      documents: ['Transcript', 'IELTS', 'Passport', 'Recommendation'],
      courseName: 'Computer Science',
      consultancyName: 'EduConsult Pro',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now(),
    ),
    Student(
      id: 'student_004',
      name: 'Emily Davis',
      email: 'emily.davis@email.com',
      phone: '+1-555-0126',
      courseId: 'course_003',
      consultancyId: 'consultancy_003',
      status: AppConstants.statusRejected,
      appliedDate: DateTime.now().subtract(const Duration(days: 20)),
      documents: ['Transcript', 'TOEFL', 'Passport'],
      courseName: 'Mechanical Engineering',
      consultancyName: 'Study Abroad Solutions',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
    ),
    Student(
      id: 'student_005',
      name: 'David Wilson',
      email: 'david.wilson@email.com',
      phone: '+1-555-0127',
      courseId: 'course_002',
      consultancyId: 'consultancy_002',
      status: AppConstants.statusPending,
      appliedDate: DateTime.now().subtract(const Duration(days: 10)),
      documents: ['Transcript', 'GMAT', 'Passport', 'Recommendation', 'SOP'],
      courseName: 'Business Administration',
      consultancyName: 'Global Education Hub',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
  ];

  // Consultancies Data
  List<Consultancy> get consultancies => [
    Consultancy(
      id: 'consultancy_001',
      name: 'EduConsult Pro',
      email: 'contact@educonsultpro.com',
      phone: '+1-555-1001',
      commissionType: CommissionType.percentage,
      commissionValue: 15.0,
      status: AppConstants.statusActive,
      studentsCount: 2,
      totalCommission: 15000.0,
      createdAt: DateTime.now().subtract(const Duration(days: 400)),
      updatedAt: DateTime.now(),
    ),
    Consultancy(
      id: 'consultancy_002',
      name: 'Global Education Hub',
      email: 'info@globaledhub.com',
      phone: '+1-555-1002',
      commissionType: CommissionType.flat,
      commissionValue: 500.0,
      status: AppConstants.statusActive,
      studentsCount: 2,
      totalCommission: 1000.0,
      createdAt: DateTime.now().subtract(const Duration(days: 350)),
      updatedAt: DateTime.now(),
    ),
    Consultancy(
      id: 'consultancy_003',
      name: 'Study Abroad Solutions',
      email: 'hello@studyabroadsolutions.com',
      phone: '+1-555-1003',
      commissionType: CommissionType.oneTime,
      commissionValue: 1000.0,
      status: AppConstants.statusActive,
      studentsCount: 1,
      totalCommission: 1000.0,
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
      updatedAt: DateTime.now(),
    ),
    Consultancy(
      id: 'consultancy_004',
      name: 'Academic Partners',
      email: 'support@academicpartners.com',
      phone: '+1-555-1004',
      commissionType: CommissionType.percentage,
      commissionValue: 12.0,
      status: AppConstants.statusInactive,
      studentsCount: 0,
      totalCommission: 0.0,
      createdAt: DateTime.now().subtract(const Duration(days: 250)),
      updatedAt: DateTime.now(),
    ),
  ];

  // Commission Transactions Data
  List<CommissionTransaction> get commissionTransactions => [
    CommissionTransaction(
      id: 'trans_001',
      consultancyId: 'consultancy_001',
      studentId: 'student_001',
      courseId: 'course_001',
      commissionType: CommissionType.percentage,
      commissionValue: 15.0,
      courseFees: 50000.0,
      calculatedCommission: 7500.0,
      transactionDate: DateTime.now().subtract(const Duration(days: 25)),
      status: 'Paid',
      studentName: 'John Smith',
      courseName: 'Computer Science',
      consultancyName: 'EduConsult Pro',
    ),
    CommissionTransaction(
      id: 'trans_002',
      consultancyId: 'consultancy_001',
      studentId: 'student_003',
      courseId: 'course_001',
      commissionType: CommissionType.percentage,
      commissionValue: 15.0,
      courseFees: 50000.0,
      calculatedCommission: 7500.0,
      transactionDate: DateTime.now().subtract(const Duration(days: 40)),
      status: 'Paid',
      studentName: 'Michael Brown',
      courseName: 'Computer Science',
      consultancyName: 'EduConsult Pro',
    ),
    CommissionTransaction(
      id: 'trans_003',
      consultancyId: 'consultancy_002',
      studentId: 'student_002',
      courseId: 'course_002',
      commissionType: CommissionType.flat,
      commissionValue: 500.0,
      courseFees: 75000.0,
      calculatedCommission: 500.0,
      transactionDate: DateTime.now().subtract(const Duration(days: 10)),
      status: 'Pending',
      studentName: 'Sarah Johnson',
      courseName: 'Business Administration',
      consultancyName: 'Global Education Hub',
    ),
    CommissionTransaction(
      id: 'trans_004',
      consultancyId: 'consultancy_002',
      studentId: 'student_005',
      courseId: 'course_002',
      commissionType: CommissionType.flat,
      commissionValue: 500.0,
      courseFees: 75000.0,
      calculatedCommission: 500.0,
      transactionDate: DateTime.now().subtract(const Duration(days: 5)),
      status: 'Pending',
      studentName: 'David Wilson',
      courseName: 'Business Administration',
      consultancyName: 'Global Education Hub',
    ),
    CommissionTransaction(
      id: 'trans_005',
      consultancyId: 'consultancy_003',
      studentId: 'student_004',
      courseId: 'course_003',
      commissionType: CommissionType.oneTime,
      commissionValue: 1000.0,
      courseFees: 55000.0,
      calculatedCommission: 1000.0,
      transactionDate: DateTime.now().subtract(const Duration(days: 15)),
      status: 'Cancelled',
      studentName: 'Emily Davis',
      courseName: 'Mechanical Engineering',
      consultancyName: 'Study Abroad Solutions',
    ),
  ];

  // Dashboard Statistics
  Map<String, dynamic> get dashboardStats => {
    'totalCourses': courses.length,
    'totalStudents': students.length,
    'totalConsultancies': consultancies.length,
    'pendingApplications': students
        .where((s) => s.status == AppConstants.statusPending)
        .length,
    'totalCommission': commissionTransactions
        .where((t) => t.status == 'Paid')
        .fold(0.0, (sum, t) => sum + t.calculatedCommission),
  };

  // Recent Activity
  List<Map<String, dynamic>> get recentActivity => [
    {
      'type': 'new_application',
      'title': 'New Application Received',
      'description': 'David Wilson applied for Business Administration',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': Icons.person_add,
    },
    {
      'type': 'course_update',
      'title': 'Course Updated',
      'description': 'Computer Science course seats updated',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'icon': Icons.edit,
    },
    {
      'type': 'partnership_approval',
      'title': 'Partnership Approved',
      'description': 'Global Education Hub partnership approved',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.business,
    },
    {
      'type': 'commission_paid',
      'title': 'Commission Paid',
      'description': 'Commission paid to EduConsult Pro',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'icon': Icons.payment,
    },
  ];
}
