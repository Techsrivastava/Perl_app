enum UserRole { SUPER_ADMIN, CONSULTANT, AGENT }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? parentId; // Used for Agents to link to Consultants
  final bool isActive;
  final String? referralCode;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.parentId,
    this.isActive = true,
    this.referralCode,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: _parseRole(json['role']),
      parentId: json['parentId'],
      isActive: json['isActive'] ?? true,
      referralCode: json['referralCode'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  static UserRole _parseRole(String? role) {
    switch (role) {
      case 'SUPER_ADMIN':
        return UserRole.SUPER_ADMIN;
      case 'AGENT':
        return UserRole.AGENT;
      default:
        return UserRole.CONSULTANT;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'parentId': parentId,
      'isActive': isActive,
      'referralCode': referralCode,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
