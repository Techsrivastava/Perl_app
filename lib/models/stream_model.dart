class CourseStream {
  final String? id;
  final String? courseId;
  final String name;
  final String abbreviation;
  final String? description;
  final int? totalSeats;
  final int? availableSeats;
  final double? fees;
  final List<String>? eligibility;
  final List<String>? subjects;
  final String? specialization;
  final String? careerOptions;
  final bool isActive;
  final String status; // 'draft' or 'published'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CourseStream({
    this.id,
    this.courseId,
    required this.name,
    required this.abbreviation,
    this.description,
    this.totalSeats,
    this.availableSeats,
    this.fees,
    this.eligibility,
    this.subjects,
    this.specialization,
    this.careerOptions,
    this.isActive = true,
    this.status = 'draft',
    this.createdAt,
    this.updatedAt,
  });

  CourseStream copyWith({
    String? id,
    String? courseId,
    String? name,
    String? abbreviation,
    String? description,
    int? totalSeats,
    int? availableSeats,
    double? fees,
    List<String>? eligibility,
    List<String>? subjects,
    String? specialization,
    String? careerOptions,
    bool? isActive,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseStream(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      description: description ?? this.description,
      totalSeats: totalSeats ?? this.totalSeats,
      availableSeats: availableSeats ?? this.availableSeats,
      fees: fees ?? this.fees,
      eligibility: eligibility ?? this.eligibility,
      subjects: subjects ?? this.subjects,
      specialization: specialization ?? this.specialization,
      careerOptions: careerOptions ?? this.careerOptions,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CourseStream.fromJson(Map<String, dynamic> json) {
    return CourseStream(
      id: json['id'] as String?,
      courseId: json['courseId'] as String?,
      name: json['name'] as String,
      abbreviation: json['abbreviation'] as String,
      description: json['description'] as String?,
      totalSeats: json['totalSeats'] as int?,
      availableSeats: json['availableSeats'] as int?,
      fees: (json['fees'] as num?)?.toDouble(),
      eligibility: (json['eligibility'] as List?)?.cast<String>(),
      subjects: (json['subjects'] as List?)?.cast<String>(),
      specialization: json['specialization'] as String?,
      careerOptions: json['careerOptions'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      status: json['status'] as String? ?? 'draft',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'name': name,
      'abbreviation': abbreviation,
      'description': description,
      'totalSeats': totalSeats,
      'availableSeats': availableSeats,
      'fees': fees,
      'eligibility': eligibility,
      'subjects': subjects,
      'specialization': specialization,
      'careerOptions': careerOptions,
      'isActive': isActive,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  bool get isDraft => status == 'draft';
  bool get isPublished => status == 'published';
}
