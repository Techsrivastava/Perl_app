class AdmissionConstants {
  // Admission Sources
  static const String admissionSourceConsultancy = 'Consultancy';
  static const String admissionSourceAgent = 'Agent';
  
  // Payment Modes
  static const String paymentModeShareDeduct = 'Share Deduct';
  static const String paymentModeFullFee = 'Full Fee';
  
  // Share Types
  static const String shareTypePercent = 'percent';
  static const String shareTypeFlat = 'flat';
  static const String shareTypeOneTime = 'one-time';
  
  // Required Documents
  static const List<String> requiredDocuments = [
    '10th Marksheet',
    '12th Marksheet',
    'Photo',
    'Signature',
    'Aadhaar Card',
    'Migration Certificate',
  ];
  
  // Step Names
  static const List<String> stepNames = [
    'Student\nDetails',
    'Academic\nDetails',
    'Documents',
    'Fee\nDetails',
    'Financial\nSummary',
    'Review &\nSubmit',
  ];
  
  // Validation Messages
  static const String msgFillRequiredFields = 'Please fill all required fields';
  static const String msgEnterAgentCode = 'Please enter agent code first';
  static const String msgAgentFound = '✅ Agent found';
  static const String msgInvalidAmount = 'Enter valid amount';
  static const String msgFeeLessThanUniversity = 'Must be ≥ university fee';
  
  // Mock Data (Replace with API)
  static const double mockUniversityFee = 80000;
  static const double mockDisplayFee = 120000;
  static const String mockConsultancyShareType = shareTypePercent;
  static const double mockConsultancyShareValue = 15;
  static const double mockAgentShareValue = 25;
}
