import 'package:university_app_2/models/admission_model.dart';

/// ADMISSION FEE MODULE (FINANCIAL WORKFLOW ONLY)
///
/// This module handles:
/// - Actual fee collected from student
/// - University fee payable
/// - Consultancy profit calculation
/// - Agent commission calculation
/// - Admission-related expenses
/// - Consultancy net profit
/// - Ledger creation for University / Consultancy / Agent
///
/// This file contains ONLY fee & financial logic.

class FeeModule {
  // ================================================================
  // SECTION 1 — AUTO-FILLED (READ-ONLY VALUES)
  // ================================================================
  // These values load automatically from Course Setup (super admin)

  /// 1.1 University Fee (Fixed)
  /// - Non-editable
  /// - Base fee payable to university
  static double getUniversityFee(FeeDetails feeDetails) {
    return feeDetails.universityFee ?? 0.0;
  }

  /// 1.2 Students Display Fee
  /// - Non-editable
  /// - Used only to show expected profit
  static double getDisplayFee(FeeDetails feeDetails) {
    return feeDetails.displayFee ?? 0.0;
  }

  /// 1.3 Default Consultancy Profit (Reference only)
  /// default_profit = display_fee - university_fee
  static double calculateDefaultProfit({
    required double displayFee,
    required double universityFee,
  }) {
    return displayFee - universityFee;
  }

  // ================================================================
  // SECTION 2 — ACTUAL FEE FROM STUDENT
  // ================================================================

  /// 2.1 Calculate Actual Profit
  /// System auto-calculates: actual_profit = actual_fee_received - university_fee
  /// Display: Actual Fee, University Fee, Actual Consultancy Profit
  static double calculateActualProfit({
    required double actualFeeCollected,
    required double universityFee,
  }) {
    return actualFeeCollected - universityFee;
  }

  /// Convenience method to calculate from FeeDetails
  static double actualProfitFromFeeDetails(FeeDetails feeDetails) {
    final actualFee = feeDetails.actualFee ?? 0.0;
    final universityFee = feeDetails.universityFee ?? 0.0;
    return calculateActualProfit(
      actualFeeCollected: actualFee,
      universityFee: universityFee,
    );
  }

  // ================================================================
  // SECTION 3 — ADMISSION SOURCE
  // ================================================================
  // Dropdown: Consultancy or Agent
  // If Agent selected → Show agent commission module (Section 4)

  static String getAdmissionSource(FeeDetails feeDetails) {
    return feeDetails.admissionBy ?? 'Consultancy';
  }

  static bool isAgentAdmission(FeeDetails feeDetails) {
    return getAdmissionSource(feeDetails) == 'Agent';
  }

  // ================================================================
  // SECTION 4 — AGENT COMMISSION MODULE
  // ================================================================
  // Visible only when Admission By = Agent

  /// 4.1 Agent Code (auto-load agent details + share %)
  /// Fields are non-editable

  /// 4.2 Auto Calculation
  /// agent_commission = actual_profit * (agent_share_percentage / 100)
  static double calculateAgentCommission({
    required double actualProfit,
    required double agentSharePercentage,
  }) {
    if (agentSharePercentage <= 0) return 0.0;
    return actualProfit * (agentSharePercentage / 100.0);
  }

  /// Convenience method to calculate from FeeDetails
  static double agentCommissionFromFeeDetails(FeeDetails feeDetails) {
    final actualProfit = actualProfitFromFeeDetails(feeDetails);
    final agentShare = feeDetails.agentShareValue ?? 0.0;
    return calculateAgentCommission(
      actualProfit: actualProfit,
      agentSharePercentage: agentShare,
    );
  }

  // ================================================================
  // SECTION 5 — EXPENSES
  // ================================================================

  /// 5.1 Agent Expenses (Visible only for Agent admissions)
  /// Fields: Expense Title, Amount, Upload Proof
  /// System stores: agent_expenses_total

  /// 5.2 Consultancy Expenses
  /// Fields: Expense Title, Amount, Upload Proof
  /// System stores: consultancy_expenses_total

  /// Sum all expenses from a list
  static double sumExpenses(List<Expense>? expenses) {
    if (expenses == null || expenses.isEmpty) return 0.0;
    return expenses.fold<double>(0.0, (sum, e) => sum + (e.amount ?? 0));
  }

  /// Get total agent expenses
  static double getTotalAgentExpenses(FeeDetails feeDetails) {
    return feeDetails.agentExpensesTotal ??
        sumExpenses(feeDetails.agentExpenses);
  }

  /// Get total consultancy expenses
  static double getTotalConsultancyExpenses(FeeDetails feeDetails) {
    return feeDetails.consultancyExpensesTotal ??
        sumExpenses(feeDetails.consultancyExpenses);
  }

  // ================================================================
  // SECTION 6 — FINAL FINANCIAL SUMMARY (AUTO-CALCULATED)
  // ================================================================

  /// 6.1 Actual Fee Received
  /// = consultant input
  static double getActualFeeReceived(FeeDetails feeDetails) {
    return feeDetails.actualFee ?? 0.0;
  }

  /// 6.2 University Fee Payable
  /// = fixed (auto)
  static double getUniversityFeePayable(FeeDetails feeDetails) {
    return getUniversityFee(feeDetails);
  }

  /// 6.3 Consultancy Profit
  /// actual_profit = actual_fee_received - university_fee
  static double getConsultancyProfit(FeeDetails feeDetails) {
    return actualProfitFromFeeDetails(feeDetails);
  }

  /// 6.4 Agent Commission
  /// agent_commission = actual_profit * agent_share%
  static double getAgentCommission(FeeDetails feeDetails) {
    return feeDetails.agentCommission ??
        agentCommissionFromFeeDetails(feeDetails);
  }

  /// 6.5 Agent Expenses
  /// = agent_expenses_total
  static double getAgentExpenses(FeeDetails feeDetails) {
    return getTotalAgentExpenses(feeDetails);
  }

  /// 6.6 Consultancy Expenses
  /// = consultancy_expenses_total
  static double getConsultancyExpenses(FeeDetails feeDetails) {
    return getTotalConsultancyExpenses(feeDetails);
  }

  /// 6.7 Total Payable to Agent
  /// agent_total_payout = agent_commission + agent_expenses_total
  static double calculateAgentTotalPayout(FeeDetails feeDetails) {
    final commission = getAgentCommission(feeDetails);
    final expenses = getAgentExpenses(feeDetails);
    return commission + expenses;
  }

  /// 6.8 Consultancy Net Profit
  /// net_profit = actual_profit - agent_commission - agent_expenses - consultancy_expenses
  static double calculateConsultancyNetProfit(FeeDetails feeDetails) {
    final actualProfit = getConsultancyProfit(feeDetails);
    final agentCommission = getAgentCommission(feeDetails);
    final agentExpenses = getAgentExpenses(feeDetails);
    final consultancyExpenses = getConsultancyExpenses(feeDetails);

    return actualProfit - agentCommission - agentExpenses - consultancyExpenses;
  }

  // ================================================================
  // SECTION 7 — LEDGER CREATION (AUTO)
  // ================================================================
  // When admission is submitted, create ledger entries

  /// A. Consultancy Ledger
  /// Stores: Admission ID, Student Name, Actual Fee Received, University Fee Payable,
  /// Agent Commission, Agent Expenses, Consultancy Expenses, Final Net Profit,
  /// Payment Mode, Timestamp
  static Map<String, dynamic> buildConsultancyLedger(
    String admissionId,
    AdmissionForm admissionForm,
  ) {
    final feeDetails = admissionForm.feeDetails!;
    final studentName =
        admissionForm.studentDetails?.studentFullName ?? 'Unknown';
    final courseName = admissionForm.courseSelection?.courseName ?? 'Unknown';

    return {
      'ledger_type': 'consultancy',
      'admission_id': admissionId,
      'student_name': studentName,
      'course_name': courseName,
      'actual_fee_received': getActualFeeReceived(feeDetails),
      'university_fee_payable': getUniversityFeePayable(feeDetails),
      'consultancy_profit': getConsultancyProfit(feeDetails),
      'agent_commission': getAgentCommission(feeDetails),
      'agent_expenses': getAgentExpenses(feeDetails),
      'consultancy_expenses': getConsultancyExpenses(feeDetails),
      'final_net_profit': calculateConsultancyNetProfit(feeDetails),
      'payment_mode': feeDetails.universityPaymentMode ?? 'Not Specified',
      'created_at': DateTime.now().toIso8601String(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// B. Agent Ledger (if applicable)
  /// Stores: Admission ID, Agent Code, Agent Share, Agent Commission,
  /// Agent Expenses, Total Agent Payable Amount
  static Map<String, dynamic> buildAgentLedger(
    String admissionId,
    AdmissionForm admissionForm,
  ) {
    final feeDetails = admissionForm.feeDetails!;

    // Only create agent ledger if admission source is Agent
    if (!isAgentAdmission(feeDetails)) {
      return {};
    }

    final agentCode = feeDetails.agentCode ?? 'Unknown';
    final agentName = feeDetails.agentName ?? 'Unknown';
    final agentShare = feeDetails.agentShareValue ?? 0.0;
    final studentName =
        admissionForm.studentDetails?.studentFullName ?? 'Unknown';

    return {
      'ledger_type': 'agent',
      'admission_id': admissionId,
      'student_name': studentName,
      'agent_code': agentCode,
      'agent_name': agentName,
      'agent_share_percentage': agentShare,
      'agent_commission': getAgentCommission(feeDetails),
      'agent_expenses': getAgentExpenses(feeDetails),
      'total_agent_payable': calculateAgentTotalPayout(feeDetails),
      'created_at': DateTime.now().toIso8601String(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// C. University Ledger
  /// Stores: Admission ID, University Fee Amount, Payable / Paid / Pending status
  static Map<String, dynamic> buildUniversityLedger(
    String admissionId,
    AdmissionForm admissionForm,
  ) {
    final feeDetails = admissionForm.feeDetails!;
    final universityName =
        admissionForm.courseSelection?.universityName ?? 'Unknown';
    final courseName = admissionForm.courseSelection?.courseName ?? 'Unknown';
    final studentName =
        admissionForm.studentDetails?.studentFullName ?? 'Unknown';

    return {
      'ledger_type': 'university',
      'admission_id': admissionId,
      'student_name': studentName,
      'university_name': universityName,
      'course_name': courseName,
      'university_fee_amount': getUniversityFeePayable(feeDetails),
      'status': 'payable', // Options: payable, paid, pending
      'created_at': DateTime.now().toIso8601String(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  // ================================================================
  // SECTION 8 — SUBMISSION OPTIONS
  // ================================================================
  // SAVE AS DRAFT: Consultant can revise later. Ledger not created.
  // FINAL SUBMIT: Creates University ledger, Consultancy ledger, Agent ledger,
  //               and sends notifications (University + Agent)
  //
  // Note: Save/Submit logic is handled in screens. This module only provides
  // the ledger data for persistence to backend.
}
