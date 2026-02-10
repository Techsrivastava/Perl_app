class Student {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String courseId;
  final String consultancyId;
  final String status;
  final DateTime appliedDate;
  final List<String> documents;
  final String courseName;
  final String consultancyName;
  final DateTime createdAt;
  final DateTime updatedAt;

  // New fields for details view
  final String? fatherName;
  final String? motherName;
  final String? dob;
  final String? gender;
  final String? category;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? tenthBoard;
  final String? tenthMarks;
  final String? tenthYear;
  final String? twelfthBoard;
  final String? twelfthMarks;
  final String? twelfthYear;
  final String? mode;
  final String? duration;
  final String? addedBy;
  final double totalFee;
  final double paidAmount;
  final double pendingAmount;
  final double consultantShare;
  final String? utrNumber;
  final String? paymentStatus;
  final bool documentsVerified;
  final String? remarks;
  final String? universityRemarks;
  final String? universityName;
  final String? agentName;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.courseId,
    required this.consultancyId,
    required this.status,
    required this.appliedDate,
    required this.documents,
    required this.courseName,
    required this.consultancyName,
    required this.createdAt,
    required this.updatedAt,
    this.fatherName,
    this.motherName,
    this.dob,
    this.gender,
    this.category,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.tenthBoard,
    this.tenthMarks,
    this.tenthYear,
    this.twelfthBoard,
    this.twelfthMarks,
    this.twelfthYear,
    this.mode,
    this.duration,
    this.addedBy,
    this.totalFee = 0.0,
    this.paidAmount = 0.0,
    this.pendingAmount = 0.0,
    this.consultantShare = 0.0,
    this.utrNumber,
    this.paymentStatus,
    this.documentsVerified = false,
    this.remarks,
    this.universityRemarks,
    this.universityName,
    this.agentName,
  });

  // Getters for compatibility
  String get mobile => phone;
  DateTime get registeredDate => appliedDate;

  factory Student.fromJson(Map<String, dynamic> json) {
    // Check if the JSON is from the /students endpoint (direct student) or /admissions (nested)
    // The backend /admissions endpoint returns populated objects.

    final studentData = json['student'] is Map ? json['student'] : json;
    final courseData = json['course'] is Map ? json['course'] : {};
    final consultancyData = json['consultant'] is Map ? json['consultant'] : {};

    // Helper to parse double safely
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Student(
      id: json['_id'] ?? json['id'] ?? '',
      name: studentData['name'] ?? '',
      email: studentData['email'] ?? '',
      phone: studentData['phone'] ?? studentData['mobile'] ?? '',
      courseId: (courseData['_id'] ?? courseData['id']) ?? '',
      consultancyId: (consultancyData['_id'] ?? consultancyData['id']) ?? '',
      status: json['status'] ?? 'Pending',
      appliedDate: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      documents:
          (json['documents'] as List?)?.cast<String>() ??
          (studentData['documents'] as List?)?.cast<String>() ??
          [],
      courseName: courseData['name'] ?? 'Unknown Course',
      consultancyName: consultancyData['name'] ?? 'Unknown Consultancy',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      fatherName: studentData['father_name'],
      motherName: studentData['mother_name'],
      dob: studentData['dob'],
      gender: studentData['gender'],
      category: studentData['category'],
      address: studentData['address'],
      city: studentData['city'],
      state: studentData['state'],
      pincode: studentData['pincode'],
      tenthBoard: studentData['10th_board'],
      tenthMarks: studentData['10th_marks'],
      tenthYear: studentData['10th_year'],
      twelfthBoard: studentData['12th_board'],
      twelfthMarks: studentData['12th_marks'],
      twelfthYear: studentData['12th_year'],
      mode: studentData['mode'],
      duration: studentData['duration'],
      addedBy: studentData['added_by'],
      totalFee: parseDouble(studentData['total_fee']),
      paidAmount: parseDouble(studentData['paid_amount']),
      pendingAmount: parseDouble(studentData['pending_amount']),
      consultantShare: parseDouble(studentData['consultant_share']),
      utrNumber: studentData['utr_number'],
      paymentStatus: studentData['payment_status'],
      documentsVerified: studentData['documents_verified'] == true,
      remarks: studentData['remarks'],
      universityRemarks: studentData['university_remarks'],
      universityName: studentData['university'], // specific mapping if exists
      agentName: studentData['agent'] ?? consultancyData['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'courseId': courseId,
      'consultancyId': consultancyId,
      'status': status,
      'appliedDate': appliedDate.toIso8601String(),
      'documents': documents,
      'courseName': courseName,
      'consultancyName': consultancyName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'father_name': fatherName,
      'mother_name': motherName,
      'dob': dob,
      'gender': gender,
      'category': category,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      '10th_board': tenthBoard,
      '10th_marks': tenthMarks,
      '10th_year': tenthYear,
      '12th_board': twelfthBoard,
      '12th_marks': twelfthMarks,
      '12th_year': twelfthYear,
      'mode': mode,
      'duration': duration,
      'added_by': addedBy,
      'total_fee': totalFee,
      'paid_amount': paidAmount,
      'pending_amount': pendingAmount,
      'consultant_share': consultantShare,
      'utr_number': utrNumber,
      'payment_status': paymentStatus,
      'documents_verified': documentsVerified,
      'remarks': remarks,
      'university_remarks': universityRemarks,
      'university': universityName,
      'agent': agentName,
    };
  }

  Student copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? courseId,
    String? consultancyId,
    String? status,
    DateTime? appliedDate,
    List<String>? documents,
    String? courseName,
    String? consultancyName,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fatherName,
    String? motherName,
    String? dob,
    String? gender,
    String? category,
    String? address,
    String? city,
    String? state,
    String? pincode,
    String? tenthBoard,
    String? tenthMarks,
    String? tenthYear,
    String? twelfthBoard,
    String? twelfthMarks,
    String? twelfthYear,
    String? mode,
    String? duration,
    String? addedBy,
    double? totalFee,
    double? paidAmount,
    double? pendingAmount,
    double? consultantShare,
    String? utrNumber,
    String? paymentStatus,
    bool? documentsVerified,
    String? remarks,
    String? universityRemarks,
    String? universityName,
    String? agentName,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      courseId: courseId ?? this.courseId,
      consultancyId: consultancyId ?? this.consultancyId,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
      documents: documents ?? this.documents,
      courseName: courseName ?? this.courseName,
      consultancyName: consultancyName ?? this.consultancyName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      category: category ?? this.category,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      tenthBoard: tenthBoard ?? this.tenthBoard,
      tenthMarks: tenthMarks ?? this.tenthMarks,
      tenthYear: tenthYear ?? this.tenthYear,
      twelfthBoard: twelfthBoard ?? this.twelfthBoard,
      twelfthMarks: twelfthMarks ?? this.twelfthMarks,
      twelfthYear: twelfthYear ?? this.twelfthYear,
      mode: mode ?? this.mode,
      duration: duration ?? this.duration,
      addedBy: addedBy ?? this.addedBy,
      totalFee: totalFee ?? this.totalFee,
      paidAmount: paidAmount ?? this.paidAmount,
      pendingAmount: pendingAmount ?? this.pendingAmount,
      consultantShare: consultantShare ?? this.consultantShare,
      utrNumber: utrNumber ?? this.utrNumber,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      documentsVerified: documentsVerified ?? this.documentsVerified,
      remarks: remarks ?? this.remarks,
      universityRemarks: universityRemarks ?? this.universityRemarks,
      universityName: universityName ?? this.universityName,
      agentName: agentName ?? this.agentName,
    );
  }
}
