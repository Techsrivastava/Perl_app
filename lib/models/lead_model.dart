enum LeadStatus { NEW, CONTACTED, INTERESTED, CONVERTED, LOST }

class Lead {
  final String id;
  final String studentName;
  final String email;
  final String phone;
  final List<String> interestedCourseIds;
  final LeadStatus status;
  final String source; // BANNER, LEAD_FORM, MANUAL
  final String agentId;
  final String consultantId;
  final List<String>? notes;
  final DateTime createdAt;

  Lead({
    required this.id,
    required this.studentName,
    required this.email,
    required this.phone,
    required this.interestedCourseIds,
    this.status = LeadStatus.NEW,
    this.source = 'MANUAL',
    required this.agentId,
    required this.consultantId,
    this.notes,
    required this.createdAt,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'] ?? json['_id'] ?? '',
      studentName: json['studentName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      interestedCourseIds: List<String>.from(json['interestedCourses'] ?? []),
      status: _parseStatus(json['status']),
      source: json['source'] ?? 'MANUAL',
      agentId: json['agent'] ?? '',
      consultantId: json['consultant'] ?? '',
      notes: List<String>.from(json['notes'] ?? []),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  static LeadStatus _parseStatus(String? status) {
    return LeadStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => LeadStatus.NEW,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentName': studentName,
      'email': email,
      'phone': phone,
      'interestedCourses': interestedCourseIds,
      'status': status.name,
      'source': source,
      'agent': agentId,
      'consultant': consultantId,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
