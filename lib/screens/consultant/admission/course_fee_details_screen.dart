import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/models/admission_model.dart';
import 'fee_module.dart';

class CourseFeeDetailsScreen extends StatefulWidget {
  final AdmissionForm admissionForm;

  const CourseFeeDetailsScreen({super.key, required this.admissionForm});

  @override
  State<CourseFeeDetailsScreen> createState() => _CourseFeeDetailsScreenState();
}

class _CourseFeeDetailsScreenState extends State<CourseFeeDetailsScreen> {
  late TextEditingController actualFeeController;
  late TextEditingController agentCodeController;
  late TextEditingController expenseTitleController;
  late TextEditingController expenseAmountController;

  String? selectedUniversity;
  String? selectedCourse;
  String? selectedAdmissionSource;
  List<Expense>? agentExpenses;
  List<Expense>? consultancyExpenses;

  // Mock data - replace with actual API calls
  final Map<String, List<String>> universityCourses = {
    'Delhi University': [
      'Bachelor of Commerce (B.Com)',
      'Bachelor of Science (B.Sc)',
      'Bachelor of Arts (B.A)',
    ],
    'Mumbai University': [
      'Master of Business Administration (MBA)',
      'Bachelor of Engineering (B.E)',
      'Bachelor of Commerce (B.Com)',
    ],
    'Bangalore Institute': [
      'Master of Computer Applications (MCA)',
      'Bachelor of Technology (B.Tech)',
      'Master of Business Administration (MBA)',
    ],
  };

  final Map<String, Map<String, String>> courseDetails = {
    'Bachelor of Commerce (B.Com)': {
      'duration': '3 Years',
      'mode': 'Regular',
      'universityFee': '50000',
      'displayFee': '75000',
    },
    'Bachelor of Science (B.Sc)': {
      'duration': '3 Years',
      'mode': 'Regular',
      'universityFee': '55000',
      'displayFee': '80000',
    },
    'Master of Business Administration (MBA)': {
      'duration': '2 Years',
      'mode': 'Regular',
      'universityFee': '150000',
      'displayFee': '200000',
    },
  };

  @override
  void initState() {
    super.initState();
    actualFeeController = TextEditingController(
      text:
          widget.admissionForm.feeDetails?.actualFee?.toString() ?? '',
    );
    agentCodeController = TextEditingController(
      text: widget.admissionForm.feeDetails?.agentCode ?? '',
    );
    expenseTitleController = TextEditingController();
    expenseAmountController = TextEditingController();

    selectedUniversity = widget.admissionForm.courseSelection?.universityName;
    selectedCourse = widget.admissionForm.courseSelection?.courseName;
    selectedAdmissionSource = widget.admissionForm.feeDetails?.admissionBy;
    agentExpenses = widget.admissionForm.feeDetails?.agentExpenses ?? [];
    consultancyExpenses =
        widget.admissionForm.feeDetails?.consultancyExpenses ?? [];
  }

  @override
  void dispose() {
    actualFeeController.dispose();
    agentCodeController.dispose();
    expenseTitleController.dispose();
    expenseAmountController.dispose();
    super.dispose();
  }

  void _onCourseSelected(String? course) {
    setState(() {
      selectedCourse = course;
      if (course != null) {
        final details = courseDetails[course];
        if (details != null) {
          widget.admissionForm.courseSelection = CourseSelection(
            universityName: selectedUniversity,
            universityId: selectedUniversity,
            courseName: course,
            courseId: course,
            duration: details['duration'],
            modeOfStudy: details['mode'],
          );

          // preserve existing expenses/agent data when changing course
          final prevFee = widget.admissionForm.feeDetails;
          final preservedAgentExpenses = prevFee?.agentExpenses ?? [];
          final preservedConsultancyExpenses =
              prevFee?.consultancyExpenses ?? [];
          final preservedAgentCode = prevFee?.agentCode;
          final preservedAgentName = prevFee?.agentName;
          final preservedAgentShare = prevFee?.agentShareValue;

          widget.admissionForm.feeDetails = FeeDetails(
            universityFee: double.parse(details['universityFee'] ?? '0'),
            displayFee: double.parse(details['displayFee'] ?? '0'),
            agentExpenses: preservedAgentExpenses,
            consultancyExpenses: preservedConsultancyExpenses,
            agentCode: preservedAgentCode,
            agentName: preservedAgentName,
            agentShareValue: preservedAgentShare,
          );

          widget.admissionForm.feeDetails!.defaultProfit =
              widget.admissionForm.feeDetails!.displayFee! -
              widget.admissionForm.feeDetails!.universityFee!;
        }
      }
    });
  }

  void _calculateActualProfit() {
    if (actualFeeController.text.isNotEmpty) {
      final actualFee = double.tryParse(actualFeeController.text) ?? 0;
      final universityFee = widget.admissionForm.feeDetails?.universityFee ?? 0;
      final actualProfit = FeeModule.calculateActualProfit(
        actualFeeCollected: actualFee,
        universityFee: universityFee,
      );

      setState(() {
        widget.admissionForm.feeDetails!.actualFee = actualFee;
        widget.admissionForm.feeDetails!.actualProfit = actualProfit;

        if (selectedAdmissionSource == 'Agent' &&
            (widget.admissionForm.feeDetails!.agentShareValue ?? 0) > 0) {
          widget
              .admissionForm
              .feeDetails!
              .agentCommission = FeeModule.calculateAgentCommission(
            actualProfit: widget.admissionForm.feeDetails!.actualProfit ?? 0,
            agentSharePercentage:
                widget.admissionForm.feeDetails!.agentShareValue ?? 0,
          );
        }
      });
    }
  }

  void _addExpense(bool isAgent) {
    if (expenseTitleController.text.isEmpty ||
        expenseAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all expense fields')),
      );
      return;
    }

    final expense = Expense(
      title: expenseTitleController.text,
      amount: double.tryParse(expenseAmountController.text) ?? 0,
    );

    setState(() {
      if (isAgent) {
        agentExpenses?.add(expense);
        widget.admissionForm.feeDetails!.agentExpenses = agentExpenses;
        widget.admissionForm.feeDetails!.agentExpensesTotal =
            FeeModule.sumExpenses(agentExpenses);
      } else {
        consultancyExpenses?.add(expense);
        widget.admissionForm.feeDetails!.consultancyExpenses =
            consultancyExpenses;
        widget.admissionForm.feeDetails!.consultancyExpensesTotal =
            FeeModule.sumExpenses(consultancyExpenses);
      }

      expenseTitleController.clear();
      expenseAmountController.clear();
    });
  }

  void _saveAndContinue() {
    if (selectedUniversity == null ||
        selectedCourse == null ||
        selectedAdmissionSource == null ||
        actualFeeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    _calculateActualProfit();

    widget.admissionForm.feeDetails!.admissionBy = selectedAdmissionSource;

    if (selectedAdmissionSource == 'Agent' &&
        agentCodeController.text.isNotEmpty) {
      widget.admissionForm.feeDetails!.agentCode = agentCodeController.text;
      // Mock agent data - replace with actual API call
      widget.admissionForm.feeDetails!.agentName =
          'Agent: ${agentCodeController.text}';
      widget.admissionForm.feeDetails!.agentShareType = 'percent';
      widget.admissionForm.feeDetails!.agentShareValue = 25.0;
      widget.admissionForm.feeDetails!.agentCommission =
          FeeModule.calculateAgentCommission(
            actualProfit: widget.admissionForm.feeDetails!.actualProfit ?? 0,
            agentSharePercentage:
                widget.admissionForm.feeDetails!.agentShareValue ?? 0,
          );
    }

    widget.admissionForm.updatedAt = DateTime.now();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course & Fee Details'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Selection Section
            Text(
              'Course Selection',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedUniversity,
              decoration: InputDecoration(
                labelText: 'Select University *',
                prefixIcon: const Icon(Icons.school),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: universityCourses.keys.map((String university) {
                return DropdownMenuItem<String>(
                  value: university,
                  child: Text(university),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedUniversity = newValue;
                  selectedCourse = null;
                });
              },
            ),
            const SizedBox(height: 12),

            if (selectedUniversity != null)
              DropdownButtonFormField<String>(
                value: selectedCourse,
                decoration: InputDecoration(
                  labelText: 'Select Course *',
                  prefixIcon: const Icon(Icons.book),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: universityCourses[selectedUniversity!]!.map((
                  String course,
                ) {
                  return DropdownMenuItem<String>(
                    value: course,
                    child: Text(course),
                  );
                }).toList(),
                onChanged: _onCourseSelected,
              ),
            const SizedBox(height: 24),

            // Course Details Display
            if (selectedCourse != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.primaryBlue),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Duration:',
                      widget.admissionForm.courseSelection?.duration ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Mode of Study:',
                      widget.admissionForm.courseSelection?.modeOfStudy ??
                          'N/A',
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Fee Details Section
            Text(
              'Fee Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),

            // University Fee Display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('University Fee (Fixed):'),
                  Text(
                    '₹${widget.admissionForm.feeDetails?.universityFee?.toStringAsFixed(0) ?? '0'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Display Fee
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Student Display Fee:'),
                  Text(
                    '₹${widget.admissionForm.feeDetails?.displayFee?.toStringAsFixed(0) ?? '0'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Actual Fee Input
            TextField(
              controller: actualFeeController,
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculateActualProfit(),
              decoration: InputDecoration(
                labelText: 'Actual Fee Collected *',
                prefixText: '₹ ',
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Actual Profit Display
            if (widget.admissionForm.feeDetails?.actualProfit != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Actual Profit:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₹${widget.admissionForm.feeDetails!.actualProfit!.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Admission Source
            Text(
              'Admission Source',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 12),

            SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(
                  value: 'Consultancy',
                  label: Text('Consultancy'),
                  icon: Icon(Icons.business),
                ),
                ButtonSegment<String>(
                  value: 'Agent',
                  label: Text('Agent'),
                  icon: Icon(Icons.person),
                ),
              ],
              selected: <String>{selectedAdmissionSource ?? 'Consultancy'},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  selectedAdmissionSource = newSelection.first;
                  if (selectedAdmissionSource == 'Consultancy') {
                    agentCodeController.clear();
                  }
                });
              },
            ),
            const SizedBox(height: 24),

            // Agent Section (Conditional)
            if (selectedAdmissionSource == 'Agent') ...[
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
                      'Agent Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: agentCodeController,
                      decoration: InputDecoration(
                        labelText: 'Agent Code *',
                        hintText: 'Enter agent code',
                        prefixIcon: const Icon(Icons.badge),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.admissionForm.feeDetails?.agentName != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            'Agent Name:',
                            widget.admissionForm.feeDetails!.agentName ?? 'N/A',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Agent Share:',
                            '${widget.admissionForm.feeDetails?.agentShareValue?.toStringAsFixed(0)}%',
                          ),
                          const SizedBox(height: 8),
                          if (widget
                                  .admissionForm
                                  .feeDetails
                                  ?.agentCommission !=
                              null)
                            _buildInfoRow(
                              'Agent Commission:',
                              '₹${widget.admissionForm.feeDetails!.agentCommission!.toStringAsFixed(0)}',
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Agent Expenses
              Text(
                'Agent Expenses',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expenseTitleController,
                      decoration: InputDecoration(
                        labelText: 'Expense Title',
                        hintText: 'e.g., Travel',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: expenseAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixText: '₹ ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _addExpense(true),
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: AppTheme.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Agent Expenses List
              if (agentExpenses != null && agentExpenses!.isNotEmpty)
                Column(
                  children: agentExpenses!
                      .asMap()
                      .entries
                      .map(
                        (entry) => Dismissible(
                          key: Key('agent_expense_${entry.key}'),
                          onDismissed: (_) {
                            setState(() {
                              agentExpenses!.removeAt(entry.key);
                              widget.admissionForm.feeDetails!.agentExpenses =
                                  agentExpenses;
                              widget
                                  .admissionForm
                                  .feeDetails!
                                  .agentExpensesTotal = agentExpenses!
                                  .fold<double>(
                                    0,
                                    (sum, e) => sum + (e.amount ?? 0),
                                  );
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.value.title ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₹${entry.value.amount?.toStringAsFixed(0) ?? '0'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 12),

              if (widget.admissionForm.feeDetails?.agentExpensesTotal != null &&
                  widget.admissionForm.feeDetails!.agentExpensesTotal! > 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Agent Expenses:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${widget.admissionForm.feeDetails!.agentExpensesTotal!.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
            ],

            // Consultancy Expenses
            Text(
              'Consultancy Expenses',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expenseTitleController,
                    decoration: InputDecoration(
                      labelText: 'Expense Title',
                      hintText: 'e.g., Verification',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: expenseAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _addExpense(false),
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: AppTheme.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Consultancy Expenses List
            if (consultancyExpenses != null && consultancyExpenses!.isNotEmpty)
              Column(
                children: consultancyExpenses!
                    .asMap()
                    .entries
                    .map(
                      (entry) => Dismissible(
                        key: Key('consultancy_expense_${entry.key}'),
                        onDismissed: (_) {
                          setState(() {
                            consultancyExpenses!.removeAt(entry.key);
                            widget
                                    .admissionForm
                                    .feeDetails!
                                    .consultancyExpenses =
                                consultancyExpenses;
                            widget
                                .admissionForm
                                .feeDetails!
                                .consultancyExpensesTotal = consultancyExpenses!
                                .fold<double>(
                                  0,
                                  (sum, e) => sum + (e.amount ?? 0),
                                );
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.value.title ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₹${entry.value.amount?.toStringAsFixed(0) ?? '0'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 12),

            if (widget.admissionForm.feeDetails?.consultancyExpensesTotal !=
                    null &&
                widget.admissionForm.feeDetails!.consultancyExpensesTotal! > 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Consultancy Expenses:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₹${widget.admissionForm.feeDetails!.consultancyExpensesTotal!.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveAndContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: AppTheme.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Continue to Summary'),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
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
    );
  }
}
