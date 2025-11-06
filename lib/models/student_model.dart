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
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      courseId: json['courseId'] ?? '',
      consultancyId: json['consultancyId'] ?? '',
      status: json['status'] ?? 'Pending',
      appliedDate: DateTime.parse(
        json['appliedDate'] ?? DateTime.now().toIso8601String(),
      ),
      documents: List<String>.from(json['documents'] ?? []),
      courseName: json['courseName'] ?? '',
      consultancyName: json['consultancyName'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
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
    );
  }
}
