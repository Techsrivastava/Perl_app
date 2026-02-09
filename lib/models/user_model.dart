/// User roles recognised by the application.  The backend now exposes
/// additional roles (UNIVERSITY and STUDENT) that must be reflected in
/// the client.  Keep the order consistent with the backend for clarity.
enum UserRole { SUPER_ADMIN, UNIVERSITY, CONSULTANT, AGENT, STUDENT }

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
      case 'UNIVERSITY':
        return UserRole.UNIVERSITY;
      case 'CONSULTANT':
        return UserRole.CONSULTANT;
      case 'AGENT':
        return UserRole.AGENT;
      case 'STUDENT':
        return UserRole.STUDENT;
      default:
        // Fallback to student for unrecognised roles to ensure minimal access
        return UserRole.STUDENT;
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
