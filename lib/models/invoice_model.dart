class CommissionBreakdown {
  final double universityTotal;
  final double consultantShare;
  final double agentShare;
  final double systemNet;

  CommissionBreakdown({
    required this.universityTotal,
    required this.consultantShare,
    required this.agentShare,
    required this.systemNet,
  });

  factory CommissionBreakdown.fromJson(Map<String, dynamic> json) {
    return CommissionBreakdown(
      universityTotal: (json['universityTotal'] ?? 0).toDouble(),
      consultantShare: (json['consultantShare'] ?? 0).toDouble(),
      agentShare: (json['agentShare'] ?? 0).toDouble(),
      systemNet: (json['systemNet'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'universityTotal': universityTotal,
    'consultantShare': consultantShare,
    'agentShare': agentShare,
    'systemNet': systemNet,
  };
}

class Invoice {
  final String id;
  final String admissionId;
  final String invoiceNumber;
  final double totalFee;
  final CommissionBreakdown commissionBreakdown;
  final String status; // DRAFT, ISSUED, PAID, SETTLED
  final DateTime? dueDate;
  final DateTime? paidAt;
  final DateTime createdAt;

  Invoice({
    required this.id,
    required this.admissionId,
    required this.invoiceNumber,
    required this.totalFee,
    required this.commissionBreakdown,
    required this.status,
    this.dueDate,
    this.paidAt,
    required this.createdAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? json['_id'] ?? '',
      admissionId: json['admission'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      totalFee: (json['totalFee'] ?? 0).toDouble(),
      commissionBreakdown: CommissionBreakdown.fromJson(
        json['commissionBreakdown'] ?? {},
      ),
      status: json['status'] ?? 'DRAFT',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'admission': admissionId,
    'invoiceNumber': invoiceNumber,
    'totalFee': totalFee,
    'commissionBreakdown': commissionBreakdown.toJson(),
    'status': status,
    'dueDate': dueDate?.toIso8601String(),
    'paidAt': paidAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };
}
