class University {
  final String id;
  final String name;
  final String abbreviation;
  final int establishedYear;
  final String type;
  final List<String> facilities;
  final List<String> documents;
  final String description;
  final String contactEmail;
  final String contactPhone;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  // ✅ Newly added optional bank fields
  final String? bankName;
  final String? accountNumber;
  final String? ifscCode;
  final String? branch;

  University({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.establishedYear,
    required this.type,
    required this.facilities,
    required this.documents,
    required this.description,
    required this.contactEmail,
    required this.contactPhone,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.branch,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
      establishedYear: json['establishedYear'] ?? 0,
      type: json['type'] ?? '',
      facilities: List<String>.from(json['facilities'] ?? []),
      documents: List<String>.from(json['documents'] ?? []),
      description: json['description'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      address: json['address'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),

      // ✅ Added JSON parsing for bank fields
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
      branch: json['branch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'establishedYear': establishedYear,
      'type': type,
      'facilities': facilities,
      'documents': documents,
      'description': description,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),

      // ✅ Added for saving to backend
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'branch': branch,
    };
  }

  University copyWith({
    String? id,
    String? name,
    String? abbreviation,
    int? establishedYear,
    String? type,
    List<String>? facilities,
    List<String>? documents,
    String? description,
    String? contactEmail,
    String? contactPhone,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    String? branch,
  }) {
    return University(
      id: id ?? this.id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      establishedYear: establishedYear ?? this.establishedYear,
      type: type ?? this.type,
      facilities: facilities ?? this.facilities,
      documents: documents ?? this.documents,
      description: description ?? this.description,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      branch: branch ?? this.branch,
    );
  }
}
