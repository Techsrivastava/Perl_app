import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/models/admission_model.dart';
import 'package:university_app_2/screens/consultant/admission/student_details_screen.dart';
import 'package:university_app_2/screens/consultant/admission/course_fee_details_screen.dart';
import 'package:university_app_2/screens/consultant/admission/financial_summary_screen.dart';
import 'fee_module.dart';

class AdmissionFormScreen extends StatefulWidget {
  const AdmissionFormScreen({super.key});

  @override
  State<AdmissionFormScreen> createState() => _AdmissionFormScreenState();
}

class _AdmissionFormScreenState extends State<AdmissionFormScreen> {
  late AdmissionForm admissionForm;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    admissionForm = AdmissionForm();
  }

  void _goToStep(int step) {
    setState(() {
      currentStep = step;
    });
  }

  void _navigateToStudentDetails() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StudentDetailsScreen(admissionForm: admissionForm),
      ),
    );
    setState(() {});
    // If student details were filled, advance to the course step
    if (admissionForm.studentDetails?.studentFullName != null) {
      _goToStep(1);
    }
  }

  void _navigateToCourseAndFee() async {
    if (admissionForm.studentDetails?.studentFullName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete Student Details first')),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CourseFeeDetailsScreen(admissionForm: admissionForm),
      ),
    );
    setState(() {});
    // If course & fee were filled, advance to the summary step
    if (admissionForm.courseSelection?.courseName != null) {
      _goToStep(2);
    }
  }

  void _navigateToSummary() async {
    if (admissionForm.courseSelection?.courseName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete Course & Fee Details first'),
        ),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FinancialSummaryScreen(admissionForm: admissionForm),
      ),
    );
    setState(() {});
    // After returning from the summary screen, keep user on final step
    if (admissionForm.declarations?.allDeclarationsChecked ?? false) {
      _goToStep(2);
    } else {
      _goToStep(2);
    }
  }

  bool _isStepComplete(int step) {
    switch (step) {
      case 0:
        return admissionForm.studentDetails?.studentFullName != null;
      case 1:
        return admissionForm.courseSelection?.courseName != null;
      case 2:
        return admissionForm.declarations?.allDeclarationsChecked ?? false;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Admission'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Stepper Section
          Container(
            color: AppTheme.primaryBlue.withAlpha(25),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStepperButton(
                        0,
                        'Student\nDetails',
                        _isStepComplete(0),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: 30,
                      color: currentStep >= 1
                          ? AppTheme.primaryBlue
                          : Colors.grey.shade300,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    Expanded(
                      child: _buildStepperButton(
                        1,
                        'Course &\nFee Details',
                        _isStepComplete(1),
                        badge: admissionForm.feeDetails != null
                            ? '₹${admissionForm.feeDetails?.actualFee?.toStringAsFixed(0) ?? '0'}'
                            : null,
                      ),
                    ),
                    Container(
                      height: 2,
                      width: 30,
                      color: currentStep >= 2
                          ? AppTheme.primaryBlue
                          : Colors.grey.shade300,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    Expanded(
                      child: _buildStepperButton(
                        2,
                        'Summary &\nSubmit',
                        _isStepComplete(2),
                        badge: admissionForm.feeDetails != null
                            ? 'Net ₹${FeeModule.calculateConsultancyNetProfit(admissionForm.feeDetails!).toStringAsFixed(0)}'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: (currentStep + 1) / 3,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: currentStep == 0
                  ? _buildStep0Content()
                  : currentStep == 1
                  ? _buildStep1Content()
                  : _buildStep2Content(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton(
    int step,
    String label,
    bool isComplete, {
    String? badge,
  }) {
    final isActive = step == currentStep;
    return GestureDetector(
      onTap: step <= currentStep ? () => _goToStep(step) : null,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? AppTheme.primaryBlue
                  : isComplete
                  ? Colors.green
                  : Colors.grey.shade300,
            ),
            child: Center(
              child: isComplete && !isActive
                  ? const Icon(Icons.check, color: Colors.white, size: 28)
                  : Text(
                      '${step + 1}',
                      style: TextStyle(
                        color: isActive || isComplete
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppTheme.primaryBlue : Colors.grey.shade600,
            ),
          ),
          if (badge != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primaryBlue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStep0Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 1: Student Details',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter basic information about the student including personal and contact details',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildDetailCard(
          'Student Name',
          admissionForm.studentDetails?.studentFullName ?? 'Not filled',
          Icons.person,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          'Mobile Number',
          admissionForm.studentDetails?.mobileNumber ?? 'Not filled',
          Icons.phone,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          'Gender',
          admissionForm.studentDetails?.gender ?? 'Not filled',
          Icons.wc,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          'Date of Birth',
          admissionForm.studentDetails?.dateOfBirth?.toString().split(' ')[0] ??
              'Not filled',
          Icons.calendar_today,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _navigateToStudentDetails,
            icon: const Icon(Icons.edit),
            label: admissionForm.studentDetails?.studentFullName == null
                ? const Text('Fill Student Details')
                : const Text('Edit Student Details'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 2: Course & Fee Details',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select course and enter fee information with agent/consultancy details',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildDetailCard(
          'University',
          admissionForm.courseSelection?.universityName ?? 'Not selected',
          Icons.school,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          'Course',
          admissionForm.courseSelection?.courseName ?? 'Not selected',
          Icons.book,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          'Admission Source',
          admissionForm.feeDetails?.admissionBy ?? 'Not selected',
          Icons.source,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.currency_rupee, color: Colors.green),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Actual Profit',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '₹${admissionForm.feeDetails?.actualProfit?.toStringAsFixed(0) ?? '0'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _navigateToCourseAndFee,
            icon: const Icon(Icons.edit),
            label: admissionForm.courseSelection?.courseName == null
                ? const Text('Fill Course & Fee Details')
                : const Text('Edit Course & Fee Details'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 3: Summary & Declaration',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Review complete admission details and submit with declarations',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            border: Border.all(color: AppTheme.primaryBlue),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Financial Summary',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Fee Collected:'),
                  Text(
                    '₹${admissionForm.feeDetails?.actualFee?.toStringAsFixed(0) ?? '0'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('University Fee:'),
                  Text(
                    '₹${admissionForm.feeDetails?.universityFee?.toStringAsFixed(0) ?? '0'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Actual Profit:'),
                  Text(
                    '₹${admissionForm.feeDetails?.actualProfit?.toStringAsFixed(0) ?? '0'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            border: Border.all(color: Colors.amber),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.amber.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Declaration: Check all statements in summary before submitting',
                  style: TextStyle(fontSize: 13, color: Colors.amber.shade900),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _navigateToSummary,
            icon: const Icon(Icons.check_circle),
            label: const Text('Review & Submit Admission'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
