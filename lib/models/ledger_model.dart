// Ledger models for financial tracking

class ConsultancyLedger {
  final String? id;
  final String type = 'consultancy_profit';
  final double actualFee;
  final double universityFee;
  final double actualProfit;
  final double agentCommission;
  final double agentExpensesTotal;
  final double consultancyExpensesTotal;
  final double finalProfit;
  final String admissionId;
  final DateTime timestamp;
  final String? studentName;
  final String? courseName;

  ConsultancyLedger({
    this.id,
    required this.actualFee,
    required this.universityFee,
    required this.actualProfit,
    required this.agentCommission,
    required this.agentExpensesTotal,
    required this.consultancyExpensesTotal,
    required this.finalProfit,
    required this.admissionId,
    required this.timestamp,
    this.studentName,
    this.courseName,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'actualFee': actualFee,
    'universityFee': universityFee,
    'actualProfit': actualProfit,
    'agentCommission': agentCommission,
    'agentExpensesTotal': agentExpensesTotal,
    'consultancyExpensesTotal': consultancyExpensesTotal,
    'finalProfit': finalProfit,
    'admissionId': admissionId,
    'timestamp': timestamp.toIso8601String(),
    'studentName': studentName,
    'courseName': courseName,
  };

  factory ConsultancyLedger.fromJson(Map<String, dynamic> json) {
    return ConsultancyLedger(
      id: json['id'],
      actualFee: (json['actualFee'] ?? 0).toDouble(),
      universityFee: (json['universityFee'] ?? 0).toDouble(),
      actualProfit: (json['actualProfit'] ?? 0).toDouble(),
      agentCommission: (json['agentCommission'] ?? 0).toDouble(),
      agentExpensesTotal: (json['agentExpensesTotal'] ?? 0).toDouble(),
      consultancyExpensesTotal: (json['consultancyExpensesTotal'] ?? 0).toDouble(),
      finalProfit: (json['finalProfit'] ?? 0).toDouble(),
      admissionId: json['admissionId'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      studentName: json['studentName'],
      courseName: json['courseName'],
    );
  }
}

class UniversityLedger {
  final String? id;
  final String type = 'university_payable';
  final double universityFee;
  final double actualFeeReceived;
  final String paymentMode;
  final double amountToUniversity;
  final bool paid;
  final String admissionId;
  final DateTime timestamp;
  final String? universityName;
  final String? studentName;
  final String? courseName;

  UniversityLedger({
    this.id,
    required this.universityFee,
    required this.actualFeeReceived,
    required this.paymentMode,
    required this.amountToUniversity,
    this.paid = false,
    required this.admissionId,
    required this.timestamp,
    this.universityName,
    this.studentName,
    this.courseName,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'universityFee': universityFee,
    'actualFeeReceived': actualFeeReceived,
    'paymentMode': paymentMode,
    'amountToUniversity': amountToUniversity,
    'paid': paid,
    'admissionId': admissionId,
    'timestamp': timestamp.toIso8601String(),
    'universityName': universityName,
    'studentName': studentName,
    'courseName': courseName,
  };

  factory UniversityLedger.fromJson(Map<String, dynamic> json) {
    return UniversityLedger(
      id: json['id'],
      universityFee: (json['universityFee'] ?? 0).toDouble(),
      actualFeeReceived: (json['actualFeeReceived'] ?? 0).toDouble(),
      paymentMode: json['paymentMode'] ?? 'Share Deduct',
      amountToUniversity: (json['amountToUniversity'] ?? 0).toDouble(),
      paid: json['paid'] ?? false,
      admissionId: json['admissionId'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      universityName: json['universityName'],
      studentName: json['studentName'],
      courseName: json['courseName'],
    );
  }
}

class AgentLedger {
  final String? id;
  final String type = 'agent_payable';
  final String agentCode;
  final String? agentName;
  final double agentCommission;
  final double agentExpensesTotal;
  final double totalPayableToAgent;
  final bool paid;
  final String admissionId;
  final DateTime timestamp;
  final String? studentName;

  AgentLedger({
    this.id,
    required this.agentCode,
    this.agentName,
    required this.agentCommission,
    required this.agentExpensesTotal,
    required this.totalPayableToAgent,
    this.paid = false,
    required this.admissionId,
    required this.timestamp,
    this.studentName,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'agentCode': agentCode,
    'agentName': agentName,
    'agentCommission': agentCommission,
    'agentExpensesTotal': agentExpensesTotal,
    'totalPayableToAgent': totalPayableToAgent,
    'paid': paid,
    'admissionId': admissionId,
    'timestamp': timestamp.toIso8601String(),
    'studentName': studentName,
  };

  factory AgentLedger.fromJson(Map<String, dynamic> json) {
    return AgentLedger(
      id: json['id'],
      agentCode: json['agentCode'] ?? '',
      agentName: json['agentName'],
      agentCommission: (json['agentCommission'] ?? 0).toDouble(),
      agentExpensesTotal: (json['agentExpensesTotal'] ?? 0).toDouble(),
      totalPayableToAgent: (json['totalPayableToAgent'] ?? 0).toDouble(),
      paid: json['paid'] ?? false,
      admissionId: json['admissionId'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      studentName: json['studentName'],
    );
  }
}
