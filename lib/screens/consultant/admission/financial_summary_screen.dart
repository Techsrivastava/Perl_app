import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/models/admission_model.dart';
import 'fee_module.dart';

class FinancialSummaryScreen extends StatefulWidget {
  final AdmissionForm admissionForm;

  const FinancialSummaryScreen({super.key, required this.admissionForm});

  @override
  State<FinancialSummaryScreen> createState() => _FinancialSummaryScreenState();
}

class _FinancialSummaryScreenState extends State<FinancialSummaryScreen> {
  late List<bool> declarations;

  @override
  void initState() {
    super.initState();
    declarations = [
      widget.admissionForm.declarations?.studentDetailsCorrect ?? false,
      widget.admissionForm.declarations?.documentsVerified ?? false,
      widget.admissionForm.declarations?.nonRefundableAgreed ?? false,
      widget.admissionForm.declarations?.takeResponsibility ?? false,
    ];
  }

  double _calculateConsultancyNetProfit() {
    return FeeModule.calculateConsultancyNetProfit(
      widget.admissionForm.feeDetails!,
    );
  }

  void _submitAdmission() {
    if (!widget.admissionForm.declarations!.allDeclarationsChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please check all declarations before submitting'),
        ),
      );
      return;
    }
    // Mark timestamps and status
    widget.admissionForm.status = 'submitted';
    widget.admissionForm.submittedAt = DateTime.now();
    widget.admissionForm.updatedAt = DateTime.now();

    // Build ledger payloads using FeeModule
    final admissionId =
        widget.admissionForm.admissionId ??
        'TEMP_${DateTime.now().millisecondsSinceEpoch}';
    final consultancyLedger = FeeModule.buildConsultancyLedger(
      admissionId,
      widget.admissionForm,
    );
    final agentLedger = FeeModule.buildAgentLedger(
      admissionId,
      widget.admissionForm,
    );
    final universityLedger = FeeModule.buildUniversityLedger(
      admissionId,
      widget.admissionForm,
    );

    // TODO: Replace prints with API calls to persist ledgers
    print('--- Admission Submitted (JSON) ---');
    print(widget.admissionForm.toJson());
    print('--- Consultancy Ledger Payload ---');
    print(consultancyLedger);
    if (agentLedger.isNotEmpty) {
      print('--- Agent Ledger Payload ---');
      print(agentLedger);
    }
    print('--- University Ledger Payload ---');
    print(universityLedger);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Admission submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // navigate back to dashboard after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  void _saveAsDraft() {
    widget.admissionForm.status = 'draft';

    widget.admissionForm.updatedAt = DateTime.now();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Admission saved as draft'),
        backgroundColor: Colors.blue,
      ),
    );

    // TODO: Save to backend
    print('Draft saved: ${widget.admissionForm.toJson()}');

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final fee = widget.admissionForm.feeDetails!;
    final double actualFee = fee.actualFee ?? 0;
    final double universityFee = fee.universityFee ?? 0;
    final double displayFee = fee.displayFee ?? 0;
    final double actualProfit =
        fee.actualProfit ??
        FeeModule.calculateActualProfit(
          actualFeeCollected: actualFee,
          universityFee: universityFee,
        );
    final double agentCommission =
        fee.agentCommission ??
        FeeModule.calculateAgentCommission(
          actualProfit: actualProfit,
          agentSharePercentage: fee.agentShareValue ?? 0,
        );
    final double agentExpenses =
        fee.agentExpensesTotal ?? FeeModule.sumExpenses(fee.agentExpenses);
    final double consultancyExpenses =
        fee.consultancyExpensesTotal ??
        FeeModule.sumExpenses(fee.consultancyExpenses);
    final double agentTotalPayout = agentCommission + agentExpenses;
    // final double netProfit = FeeModule.calculateConsultancyNetProfit(fee);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Summary & Declaration'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student and Course Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryBlue),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admission Summary',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    'Student Name:',
                    widget.admissionForm.studentDetails?.studentFullName ??
                        'N/A',
                  ),
                  _buildSummaryRow(
                    'University:',
                    widget.admissionForm.courseSelection?.universityName ??
                        'N/A',
                  ),
                  _buildSummaryRow(
                    'Course:',
                    widget.admissionForm.courseSelection?.courseName ?? 'N/A',
                  ),
                  _buildSummaryRow(
                    'Duration:',
                    widget.admissionForm.courseSelection?.duration ?? 'N/A',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Financial Summary Section
            Text(
              'Financial Breakdown',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 12),

            // Revenue Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Revenue',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFinancialRow('Actual Fee Collected:', actualFee),
                  _buildFinancialRow(
                    'University Fee Payable:',
                    universityFee,
                    isNegative: true,
                  ),
                  const SizedBox(height: 8),
                  _buildFinancialRow('Student Display Fee:', displayFee),
                  const Divider(),
                  _buildFinancialRow(
                    'Actual Profit:',
                    actualProfit,
                    isBold: true,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Agent Commission Section (if Agent)
            if (widget.admissionForm.feeDetails?.admissionBy == 'Agent')
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agent Deductions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow('Agent Name:', fee.agentName ?? 'N/A'),
                    _buildSummaryRow(
                      'Agent Share:',
                      fee.agentShareValue != null
                          ? '${fee.agentShareValue!.toStringAsFixed(0)}%'
                          : 'N/A',
                    ),
                    const SizedBox(height: 12),
                    _buildFinancialRow(
                      'Agent Commission:',
                      agentCommission,
                      isNegative: true,
                    ),
                    if (agentExpenses > 0) ...[
                      _buildFinancialRow(
                        'Agent Expenses:',
                        agentExpenses,
                        isNegative: true,
                      ),
                      const SizedBox(height: 8),
                      // list agent expenses
                      if (fee.agentExpenses != null &&
                          fee.agentExpenses!.isNotEmpty)
                        ...fee.agentExpenses!
                            .map(
                              (e) => _buildSummaryRow(
                                e.title ?? 'Expense',
                                '₹${(e.amount ?? 0).toStringAsFixed(0)}',
                              ),
                            )
                            .toList(),
                    ],
                    const Divider(),
                    _buildFinancialRow(
                      'Total Payable to Agent:',
                      agentTotalPayout,
                      isBold: true,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Consultancy Expenses Section
            if (consultancyExpenses > 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consultancy Expenses',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFinancialRow(
                      'Total Expenses:',
                      consultancyExpenses,
                      isNegative: true,
                    ),
                    const SizedBox(height: 8),
                    if (fee.consultancyExpenses != null &&
                        fee.consultancyExpenses!.isNotEmpty)
                      ...fee.consultancyExpenses!
                          .map(
                            (e) => _buildSummaryRow(
                              e.title ?? 'Expense',
                              '₹${(e.amount ?? 0).toStringAsFixed(0)}',
                            ),
                          )
                          .toList(),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Net Profit Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryBlue, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consultancy Net Profit',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      '₹${_calculateConsultancyNetProfit().toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _calculateConsultancyNetProfit() >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Mode Info
            if (widget.admissionForm.feeDetails?.universityPaymentMode != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: AppTheme.primaryBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Mode:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            widget.admissionForm.feeDetails!.universityPaymentMode ??
                                'N/A',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Declarations Section
            Text(
              'Declarations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _buildDeclarationCheckbox(
                    0,
                    'I confirm the student details are correct',
                  ),
                  const SizedBox(height: 12),
                  _buildDeclarationCheckbox(
                    1,
                    'I have verified all submitted documents',
                  ),
                  const SizedBox(height: 12),
                  _buildDeclarationCheckbox(
                    2,
                    'I understand fee once submitted is non-refundable',
                  ),
                  const SizedBox(height: 12),
                  _buildDeclarationCheckbox(
                    3,
                    'I take full responsibility for submitted application',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _saveAsDraft,
                    icon: const Icon(Icons.save),
                    label: const Text('Save as Draft'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submitAdmission,
                    icon: const Icon(Icons.send),
                    label: const Text('Submit Admission'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: AppTheme.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(
    String label,
    double amount, {
    bool isNegative = false,
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${isNegative ? '- ' : ''}₹${amount.abs().toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeclarationCheckbox(int index, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          declarations[index] = !declarations[index];
          if (index == 0) {
            widget.admissionForm.declarations!.studentDetailsCorrect =
                declarations[index];
          } else if (index == 1) {
            widget.admissionForm.declarations!.documentsVerified =
                declarations[index];
          } else if (index == 2) {
            widget.admissionForm.declarations!.nonRefundableAgreed =
                declarations[index];
          } else if (index == 3) {
            widget.admissionForm.declarations!.takeResponsibility =
                declarations[index];
          }
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: declarations[index],
            onChanged: (bool? value) {
              setState(() {
                declarations[index] = value ?? false;
                if (index == 0) {
                  widget.admissionForm.declarations!.studentDetailsCorrect =
                      declarations[index];
                } else if (index == 1) {
                  widget.admissionForm.declarations!.documentsVerified =
                      declarations[index];
                } else if (index == 2) {
                  widget.admissionForm.declarations!.nonRefundableAgreed =
                      declarations[index];
                } else if (index == 3) {
                  widget.admissionForm.declarations!.takeResponsibility =
                      declarations[index];
                }
              });
            },
            activeColor: AppTheme.primaryBlue,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(text, style: const TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
