class CommissionModel {
  final String type; // FLAT, PERCENTAGE, MIXED
  final double flatAmount;
  final double percentage;

  CommissionModel({
    required this.type,
    this.flatAmount = 0.0,
    this.percentage = 0.0,
  });

  factory CommissionModel.fromJson(Map<String, dynamic> json) {
    return CommissionModel(
      type: json['type'] ?? 'PERCENTAGE',
      flatAmount: (json['flatAmount'] ?? 0).toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'flatAmount': flatAmount,
    'percentage': percentage,
  };
}

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

  // Asset URLs
  final String? logoUrl;
  final String? coverUrl;
  final String? accreditationCertificateUrl;

  // Additional Details
  final Map<String, String>? socialLinks;
  final Map<String, dynamic>? authorizedPerson;
  final Map<String, dynamic>? entranceTest;
  final List<String> accreditations;

  // SaaS Specific Fields
  final CommissionModel? commissionModel;
  final bool isActive;

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
    this.logoUrl,
    this.coverUrl,
    this.accreditationCertificateUrl,
    this.socialLinks,
    this.authorizedPerson,
    this.entranceTest,
    this.accreditations = const [],
    this.commissionModel,
    this.isActive = true,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'] ?? json['_id'] ?? '',
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
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
      branch: json['branch'],
      logoUrl: json['logoUrl'] ?? json['logo'],
      coverUrl: json['coverUrl'] ?? json['backgroundImage'],
      accreditationCertificateUrl:
          json['accreditationCertificateUrl'] ??
          json['accreditationCertificate'],
      socialLinks: json['socialLinks'] != null
          ? Map<String, String>.from(json['socialLinks'])
          : null,
      authorizedPerson: json['authorizedPerson'],
      entranceTest: json['entranceTest'],
      accreditations: List<String>.from(json['accreditations'] ?? []),
      commissionModel: json['commissionModel'] != null
          ? CommissionModel.fromJson(json['commissionModel'])
          : null,
      isActive: json['isActive'] ?? true,
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
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'branch': branch,
      'logoUrl': logoUrl,
      'coverUrl': coverUrl,
      'accreditationCertificateUrl': accreditationCertificateUrl,
      'socialLinks': socialLinks,
      'authorizedPerson': authorizedPerson,
      'entranceTest': entranceTest,
      'accreditations': accreditations,
      'commissionModel': commissionModel?.toJson(),
      'isActive': isActive,
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
    String? logoUrl,
    String? coverUrl,
    String? accreditationCertificateUrl,
    Map<String, String>? socialLinks,
    Map<String, dynamic>? authorizedPerson,
    Map<String, dynamic>? entranceTest,
    List<String>? accreditations,
    CommissionModel? commissionModel,
    bool? isActive,
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
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      accreditationCertificateUrl:
          accreditationCertificateUrl ?? this.accreditationCertificateUrl,
      socialLinks: socialLinks ?? this.socialLinks,
      authorizedPerson: authorizedPerson ?? this.authorizedPerson,
      entranceTest: entranceTest ?? this.entranceTest,
      accreditations: accreditations ?? this.accreditations,
      commissionModel: commissionModel ?? this.commissionModel,
      isActive: isActive ?? this.isActive,
    );
  }
}
