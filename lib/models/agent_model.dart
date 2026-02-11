class Agent {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String firmName;
  final String city;
  final String state;
  final String address;
  final String pincode;
  final String status;
  final DateTime joinedDate;
  final int totalLeads;
  final int verifiedAdmissions;
  final int pendingAdmissions;
  final double totalEarnings;
  final String commissionType;
  final double commissionValue;
  final bool blocked; // Mapped from !isActive

  Agent({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.firmName,
    required this.city,
    required this.state,
    required this.address,
    required this.pincode,
    required this.status,
    required this.joinedDate,
    required this.totalLeads,
    required this.verifiedAdmissions,
    required this.pendingAdmissions,
    required this.totalEarnings,
    required this.commissionType,
    required this.commissionValue,
    required this.blocked,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    final rule = json['commission_rule'] ?? {};
    double commValue = 0;
    String commType = 'Percentage';

    if (rule['percentage'] != null && rule['percentage'] > 0) {
      commValue = (rule['percentage'] as num).toDouble();
      commType = 'Percentage';
    } else if (rule['flatAmount'] != null && rule['flatAmount'] > 0) {
      commValue = (rule['flatAmount'] as num).toDouble();
      commType = 'Flat';
    }

    return Agent(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      firmName: json['firmName'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      address: json['address'] ?? '',
      pincode: json['pincode'] ?? '',
      status: (json['isActive'] == true) ? 'Active' : 'Inactive',
      joinedDate: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      totalLeads: json['total_leads'] ?? 0,
      verifiedAdmissions: json['verified_admissions'] ?? 0,
      pendingAdmissions: json['pending_admissions'] ?? 0,
      totalEarnings: (json['total_earnings'] ?? 0).toDouble(),
      commissionType: commType,
      commissionValue: commValue,
      blocked: json['isActive'] == false, // Simplified mapping
    );
  }
}
