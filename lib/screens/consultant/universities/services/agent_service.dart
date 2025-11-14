import '../constants/admission_constants.dart';

class AgentDetails {
  final String agentCode;
  final String agentName;
  final String shareType;
  final double shareValue;

  AgentDetails({
    required this.agentCode,
    required this.agentName,
    required this.shareType,
    required this.shareValue,
  });
}

class AgentService {
  /// Fetch agent details by code
  /// TODO: Replace with actual API call
  static Future<AgentDetails?> fetchAgentByCode(String agentCode) async {
    if (agentCode.isEmpty) return null;
    
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data - replace with actual API
    return AgentDetails(
      agentCode: agentCode,
      agentName: 'Agent Name for $agentCode',
      shareType: AdmissionConstants.shareTypePercent,
      shareValue: AdmissionConstants.mockAgentShareValue,
    );
  }
  
  /// Calculate agent commission based on share type
  static double calculateCommission({
    required double actualProfit,
    required String shareType,
    required double shareValue,
  }) {
    if (shareType == AdmissionConstants.shareTypePercent) {
      return actualProfit * (shareValue / 100);
    } else if (shareType == AdmissionConstants.shareTypeFlat) {
      return shareValue;
    }
    return 0;
  }
  
  /// Calculate agent total payout (commission + expenses)
  static double calculateTotalPayout({
    required double commission,
    required double expenses,
  }) {
    return commission + expenses;
  }
}
