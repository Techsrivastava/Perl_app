// Admission Form Data Model

class StudentDetails {
  String? studentFullName;
  String? gender; // Male, Female, Other
  DateTime? dateOfBirth;
  String? mobileNumber;
  String? alternateMobileNumber;
  String? emailId;
  String? fatherName;
  String? motherName;
  String? parentContactNumber;
  String? streetAddress;
  String? city;
  String? district;
  String? state;
  String? pinCode;
  String? studentPhotoPath; // File path

  StudentDetails({
    this.studentFullName,
    this.gender,
    this.dateOfBirth,
    this.mobileNumber,
    this.alternateMobileNumber,
    this.emailId,
    this.fatherName,
    this.motherName,
    this.parentContactNumber,
    this.streetAddress,
    this.city,
    this.district,
    this.state,
    this.pinCode,
    this.studentPhotoPath,
  });

  Map<String, dynamic> toJson() => {
    'studentFullName': studentFullName,
    'gender': gender,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'mobileNumber': mobileNumber,
    'alternateMobileNumber': alternateMobileNumber,
    'emailId': emailId,
    'fatherName': fatherName,
    'motherName': motherName,
    'parentContactNumber': parentContactNumber,
    'streetAddress': streetAddress,
    'city': city,
    'district': district,
    'state': state,
    'pinCode': pinCode,
    'studentPhotoPath': studentPhotoPath,
  };
}

class AcademicDetails {
  String? highestQualification; // 10th, 12th, Diploma, Graduation, PG, Other
  int? passingYear;
  String? schoolCollegeName;
  double? marksPercentage;
  String? marksheetCertificatePath; // File path

  AcademicDetails({
    this.highestQualification,
    this.passingYear,
    this.schoolCollegeName,
    this.marksPercentage,
    this.marksheetCertificatePath,
  });

  Map<String, dynamic> toJson() => {
    'highestQualification': highestQualification,
    'passingYear': passingYear,
    'schoolCollegeName': schoolCollegeName,
    'marksPercentage': marksPercentage,
    'marksheetCertificatePath': marksheetCertificatePath,
  };
}

class CourseSelection {
  String? universityId;
  String? universityName;
  String? courseId;
  String? courseName;
  String? specialization;
  String? duration; // Read-only, auto-filled
  String? modeOfStudy; // Regular, Distance, Online (auto-filled)

  CourseSelection({
    this.universityId,
    this.universityName,
    this.courseId,
    this.courseName,
    this.specialization,
    this.duration,
    this.modeOfStudy,
  });

  Map<String, dynamic> toJson() => {
    'universityId': universityId,
    'universityName': universityName,
    'courseId': courseId,
    'courseName': courseName,
    'specialization': specialization,
    'duration': duration,
    'modeOfStudy': modeOfStudy,
  };
}

class FeeDetails {
  // AUTO-FILLED (READ-ONLY) from Course Setup
  double? universityFee; // Fixed Base Fee
  double? displayFee; // Shown to students
  String? consultancyShareType; // percent / flat / one-time
  double? consultancyShareValue;
  double? defaultProfit; // Read-only, calculated

  // CONSULTANCY FILLABLE
  double? actualFee; // Required - amount collected from student

  // ADMISSION SOURCE
  String? admissionBy; // Consultancy | Agent

  // AGENT LOGIC (IF admission_by = Agent)
  String? agentCode;
  String? agentName;
  String? agentShareType; // percent / flat
  double? agentShareValue;
  double? agentCommission; // Auto-calculated

  // EXPENSES MODULE
  List<Expense>? agentExpenses;
  double? agentExpensesTotal; // Auto-calculated
  List<Expense>? consultancyExpenses;
  double? consultancyExpensesTotal; // Auto-calculated

  // SYSTEM AUTO-CALCULATIONS
  double? actualProfit; // actual_fee - university_fee
  double? agentTotalPayout; // agent_commission + agent_expenses_total
  double? finalProfit; // actual_profit - agent_commission - agent_expenses_total - consultancy_expenses_total

  // UNIVERSITY PAYMENT MODE
  String? universityPaymentMode; // "Share Deduct" | "Full Fee"
  double? amountToUniversity; // Auto-calculated based on payment mode

  FeeDetails({
    this.universityFee,
    this.displayFee,
    this.consultancyShareType,
    this.consultancyShareValue,
    this.defaultProfit,
    this.actualFee,
    this.admissionBy,
    this.agentCode,
    this.agentName,
    this.agentShareType,
    this.agentShareValue,
    this.agentCommission,
    this.agentExpenses,
    this.agentExpensesTotal,
    this.consultancyExpenses,
    this.consultancyExpensesTotal,
    this.actualProfit,
    this.agentTotalPayout,
    this.finalProfit,
    this.universityPaymentMode,
    this.amountToUniversity,
  });

  // Calculate actual profit
  void calculateActualProfit() {
    if (actualFee != null && universityFee != null) {
      actualProfit = actualFee! - universityFee!;
    }
  }

  // Calculate agent commission based on share type
  void calculateAgentCommission() {
    if (admissionBy != 'Agent') {
      agentCommission = 0;
      return;
    }

    if (agentShareType == 'percent' && actualProfit != null && agentShareValue != null) {
      agentCommission = actualProfit! * (agentShareValue! / 100);
    } else if (agentShareType == 'flat' && agentShareValue != null) {
      agentCommission = agentShareValue!;
    } else {
      agentCommission = 0;
    }
  }

  // Calculate agent total payout
  void calculateAgentTotalPayout() {
    agentTotalPayout = (agentCommission ?? 0) + (agentExpensesTotal ?? 0);
  }

  // Calculate final consultancy net profit
  void calculateFinalProfit() {
    finalProfit = (actualProfit ?? 0) - 
                  (agentCommission ?? 0) - 
                  (agentExpensesTotal ?? 0) - 
                  (consultancyExpensesTotal ?? 0);
  }

  // Calculate amount to university based on payment mode
  void calculateAmountToUniversity() {
    if (universityPaymentMode == 'Share Deduct') {
      amountToUniversity = universityFee ?? 0;
    } else if (universityPaymentMode == 'Full Fee') {
      amountToUniversity = actualFee ?? 0;
    } else {
      amountToUniversity = universityFee ?? 0;
    }
  }

  // Calculate all totals
  void calculateExpenseTotals() {
    agentExpensesTotal = agentExpenses?.fold<double>(0, (sum, e) => sum + (e.amount ?? 0)) ?? 0;
    consultancyExpensesTotal = consultancyExpenses?.fold<double>(0, (sum, e) => sum + (e.amount ?? 0)) ?? 0;
  }

  // Calculate all financial values
  void calculateAll() {
    calculateActualProfit();
    calculateAgentCommission();
    calculateExpenseTotals();
    calculateAgentTotalPayout();
    calculateFinalProfit();
    calculateAmountToUniversity();
  }

  Map<String, dynamic> toJson() => {
    'universityFee': universityFee,
    'displayFee': displayFee,
    'consultancyShareType': consultancyShareType,
    'consultancyShareValue': consultancyShareValue,
    'defaultProfit': defaultProfit,
    'actualFee': actualFee,
    'admissionBy': admissionBy,
    'agentCode': agentCode,
    'agentName': agentName,
    'agentShareType': agentShareType,
    'agentShareValue': agentShareValue,
    'agentCommission': agentCommission,
    'agentExpenses': agentExpenses?.map((e) => e.toJson()).toList(),
    'agentExpensesTotal': agentExpensesTotal,
    'consultancyExpenses': consultancyExpenses?.map((e) => e.toJson()).toList(),
    'consultancyExpensesTotal': consultancyExpensesTotal,
    'actualProfit': actualProfit,
    'agentTotalPayout': agentTotalPayout,
    'finalProfit': finalProfit,
    'universityPaymentMode': universityPaymentMode,
    'amountToUniversity': amountToUniversity,
  };
}

class Expense {
  String? title;
  double? amount;
  String? proofPath; // File path

  Expense({this.title, this.amount, this.proofPath});

  Map<String, dynamic> toJson() => {
    'title': title,
    'amount': amount,
    'proofPath': proofPath,
  };
}

class Documents {
  String? idProofPath;
  String? addressProofPath;
  String? transferCertificatePath;
  String? migrationCertificatePath;
  String? passportPhotoPath;
  List<String>? otherDocumentsPaths;

  Documents({
    this.idProofPath,
    this.addressProofPath,
    this.transferCertificatePath,
    this.migrationCertificatePath,
    this.passportPhotoPath,
    this.otherDocumentsPaths,
  });

  Map<String, dynamic> toJson() => {
    'idProofPath': idProofPath,
    'addressProofPath': addressProofPath,
    'transferCertificatePath': transferCertificatePath,
    'migrationCertificatePath': migrationCertificatePath,
    'passportPhotoPath': passportPhotoPath,
    'otherDocumentsPaths': otherDocumentsPaths,
  };
}

class Declarations {
  bool studentDetailsCorrect = false;
  bool documentsVerified = false;
  bool nonRefundableAgreed = false;
  bool takeResponsibility = false;

  bool get allDeclarationsChecked =>
      studentDetailsCorrect &&
      documentsVerified &&
      nonRefundableAgreed &&
      takeResponsibility;

  Map<String, dynamic> toJson() => {
    'studentDetailsCorrect': studentDetailsCorrect,
    'documentsVerified': documentsVerified,
    'nonRefundableAgreed': nonRefundableAgreed,
    'takeResponsibility': takeResponsibility,
  };
}

class AdmissionForm {
  String? admissionId;
  String? status; // draft, submitted, approved, rejected, processing
  StudentDetails? studentDetails;
  AcademicDetails? academicDetails;
  CourseSelection? courseSelection;
  FeeDetails? feeDetails;
  Documents? documents;
  Declarations? declarations;

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? submittedAt;

  AdmissionForm({
    this.admissionId,
    this.status = 'draft',
    this.studentDetails,
    this.academicDetails,
    this.courseSelection,
    this.feeDetails,
    this.documents,
    this.declarations,
    this.createdAt,
    this.updatedAt,
    this.submittedAt,
  }) {
    createdAt ??= DateTime.now();
    updatedAt ??= DateTime.now();
    studentDetails ??= StudentDetails();
    academicDetails ??= AcademicDetails();
    courseSelection ??= CourseSelection();
    feeDetails ??= FeeDetails();
    documents ??= Documents();
    declarations ??= Declarations();
  }

  Map<String, dynamic> toJson() => {
    'admissionId': admissionId,
    'status': status,
    'studentDetails': studentDetails?.toJson(),
    'academicDetails': academicDetails?.toJson(),
    'courseSelection': courseSelection?.toJson(),
    'feeDetails': feeDetails?.toJson(),
    'documents': documents?.toJson(),
    'declarations': declarations?.toJson(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'submittedAt': submittedAt?.toIso8601String(),
  };
}
