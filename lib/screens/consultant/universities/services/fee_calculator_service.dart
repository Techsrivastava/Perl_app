class FeeCalculationResult {
  final double actualProfit;
  final double agentCommission;
  final double agentExpensesTotal;
  final double consultancyExpensesTotal;
  final double agentTotalPayout;
  final double finalProfit;
  final double amountToUniversity;

  FeeCalculationResult({
    required this.actualProfit,
    required this.agentCommission,
    required this.agentExpensesTotal,
    required this.consultancyExpensesTotal,
    required this.agentTotalPayout,
    required this.finalProfit,
    required this.amountToUniversity,
  });
}

class FeeCalculatorService {
  /// Calculate all financial values in one go
  static FeeCalculationResult calculateAll({
    required double actualFee,
    required double universityFee,
    required bool isAgentAdmission,
    String? agentShareType,
    double? agentShareValue,
    required List<Map<String, dynamic>> agentExpenses,
    required List<Map<String, dynamic>> consultancyExpenses,
    required String universityPaymentMode,
  }) {
    // 1. Actual Profit
    final actualProfit = actualFee - universityFee;

    // 2. Agent Commission
    double agentCommission = 0;
    if (isAgentAdmission && agentShareType != null && agentShareValue != null) {
      if (agentShareType == 'percent') {
        agentCommission = actualProfit * (agentShareValue / 100);
      } else if (agentShareType == 'flat') {
        agentCommission = agentShareValue;
      }
    }

    // 3. Calculate expense totals
    final agentExpensesTotal = _sumExpenses(agentExpenses);
    final consultancyExpensesTotal = _sumExpenses(consultancyExpenses);

    // 4. Agent Total Payout
    final agentTotalPayout = agentCommission + agentExpensesTotal;

    // 5. Final Consultancy Net Profit
    final finalProfit = actualProfit - agentCommission - agentExpensesTotal - consultancyExpensesTotal;

    // 6. Amount to University
    final amountToUniversity = universityPaymentMode == 'Share Deduct' 
        ? universityFee 
        : actualFee;

    return FeeCalculationResult(
      actualProfit: actualProfit,
      agentCommission: agentCommission,
      agentExpensesTotal: agentExpensesTotal,
      consultancyExpensesTotal: consultancyExpensesTotal,
      agentTotalPayout: agentTotalPayout,
      finalProfit: finalProfit,
      amountToUniversity: amountToUniversity,
    );
  }

  static double _sumExpenses(List<Map<String, dynamic>> expenses) {
    return expenses.fold<double>(0, (sum, e) => sum + (e['amount'] ?? 0));
  }
}
