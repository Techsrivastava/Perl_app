import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/models/course_model.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/custom_text_field.dart';
import 'package:university_app_2/widgets/custom_button.dart';
import 'package:university_app_2/data/indian_courses_data.dart';

class ComprehensiveAddCourseScreen extends StatefulWidget {
  const ComprehensiveAddCourseScreen({super.key});

  @override
  State<ComprehensiveAddCourseScreen> createState() =>
      _ComprehensiveAddCourseScreenState();
}

class _ComprehensiveAddCourseScreenState
    extends State<ComprehensiveAddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // SECTION A: Master Course Selection
  Course? _selectedMasterCourse;
  List<Course> _masterCoursesList = [];

  // SECTION B: University Panel
  // 1. Course Information
  final TextEditingController _customDescriptionController =
      TextEditingController();
  String _courseMode = 'Regular';
  final TextEditingController _customDurationController =
      TextEditingController();
  final TextEditingController _intakeCapacityController =
      TextEditingController();
  final TextEditingController _availableSeatsController =
      TextEditingController();
  final List<String> _admissionTypes = [
    'Merit',
    'Entrance',
    'Direct',
    'Management Quota',
  ];
  final List<String> _selectedAdmissionTypes = [];
  final TextEditingController _entranceTestNameController =
      TextEditingController();
  File? _entranceTestPdfFile;

  // 2. Simple Fee Structure (MD File Based)
  final TextEditingController _totalCourseFeeController =
      TextEditingController();
  final TextEditingController _courseDurationController = TextEditingController(
    text: '3',
  );
  String _feeType = 'YEARWISE'; // YEARWISE or SEMESTERWISE
  double _perUnitFee = 0.0;
  List<Map<String, dynamic>> _selectedMandatoryFees = [];
  List<Map<String, dynamic>> _selectedOptionalFees = [];
  bool _scholarshipAvailable = false;
  File? _scholarshipPolicyFile;

  // Mock Other Fees List (would come from university_fees table)
  final List<Map<String, dynamic>> _availableOtherFees = [
    {'id': 1, 'name': 'Registration Fee', 'amount': 2000, 'mandatory': true},
    {'id': 2, 'name': 'Exam Fee', 'amount': 5000, 'mandatory': true},
    {'id': 3, 'name': 'Library Fee', 'amount': 3000, 'mandatory': true},
    {'id': 4, 'name': 'Hostel Fee', 'amount': 50000, 'mandatory': false},
    {'id': 5, 'name': 'Transport Fee', 'amount': 15000, 'mandatory': false},
    {'id': 6, 'name': 'Sports Fee', 'amount': 1000, 'mandatory': false},
    {'id': 7, 'name': 'Lab Fee', 'amount': 8000, 'mandatory': false},
  ];

  // 3. Documents
  File? _prospectusFile;
  File? _feeStructurePdfFile;
  File? _syllabusPdfFile;
  File? _certificateFormatFile;

  // 3.1 Documents & Requirements Module
  String _documentTemplateName = 'Default UG Admission Docs';
  final List<Map<String, dynamic>> _documentRequirements = [];

  // Default Master Document List
  final List<Map<String, dynamic>> _defaultDocuments = [
    {
      'doc_id': 1,
      'name': '10th Marksheet',
      'type': 'File',
      'mandatory': true,
      'status': 'Active',
      'description': 'Class 10 board marksheet',
    },
    {
      'doc_id': 2,
      'name': '12th Marksheet',
      'type': 'File',
      'mandatory': true,
      'status': 'Active',
      'description': 'Class 12 board marksheet',
    },
    {
      'doc_id': 3,
      'name': 'Transfer Certificate (TC)',
      'type': 'File',
      'mandatory': true,
      'status': 'Active',
      'description': 'Original TC from previous institution',
    },
    {
      'doc_id': 4,
      'name': 'Migration Certificate',
      'type': 'File',
      'mandatory': false,
      'status': 'Active',
      'description': 'For students from other boards',
    },
    {
      'doc_id': 5,
      'name': 'Aadhar Card',
      'type': 'File',
      'mandatory': true,
      'status': 'Active',
      'description': 'Government ID proof',
    },
    {
      'doc_id': 6,
      'name': 'Passport Size Photo',
      'type': 'Image',
      'mandatory': true,
      'status': 'Active',
      'description': 'Recent passport size photograph',
    },
    {
      'doc_id': 7,
      'name': 'Caste Certificate',
      'type': 'File',
      'mandatory': false,
      'status': 'Active',
      'description': 'For reserved category students',
    },
    {
      'doc_id': 8,
      'name': 'Domicile Certificate',
      'type': 'File',
      'mandatory': false,
      'status': 'Active',
      'description': 'State domicile certificate',
    },
    {
      'doc_id': 9,
      'name': 'Medical Fitness Certificate',
      'type': 'File',
      'mandatory': false,
      'status': 'Active',
      'description': 'From registered medical practitioner',
    },
    {
      'doc_id': 10,
      'name': 'Entrance Exam Score Card',
      'type': 'File',
      'mandatory': false,
      'status': 'Active',
      'description': 'If applicable for the course',
    },
  ];

  // 4. Facilities
  final TextEditingController _attachedHospitalController =
      TextEditingController();
  bool _internshipAvailable = false;
  final TextEditingController _internshipDurationController =
      TextEditingController();
  bool _placementSupport = false;
  final TextEditingController _placementPartnersController =
      TextEditingController();
  final TextEditingController _specialInfrastructureController =
      TextEditingController();

  // 5. Timeline
  DateTime? _admissionStartDate;
  DateTime? _admissionEndDate;
  DateTime? _entranceExamDate;
  DateTime? _counsellingDate;

  // 6. Notes
  final TextEditingController _remarksController = TextEditingController();

  // 7. Visibility
  bool _showOnApp = true;
  String _courseStatus = 'Draft';

  @override
  void initState() {
    super.initState();
    _loadMasterCourses();
  }

  void _loadMasterCourses() {
    setState(() {
      _masterCoursesList = IndianCoursesData.getIndianCourses();
    });
  }

  @override
  void dispose() {
    _customDescriptionController.dispose();
    _customDurationController.dispose();
    _intakeCapacityController.dispose();
    _availableSeatsController.dispose();
    _entranceTestNameController.dispose();
    _courseDurationController.dispose();
    _totalCourseFeeController.dispose();
    _attachedHospitalController.dispose();
    _internshipDurationController.dispose();
    _placementPartnersController.dispose();
    _specialInfrastructureController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(
    Function(File?) onFilePicked, {
    List<String>? allowedExtensions,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        // Check file size (max 5MB)
        if (file.lengthSync() > 5 * 1024 * 1024) {
          _showSnackBar('File size must be less than 5MB', Colors.red);
          return;
        }
        onFilePicked(file);
      }
    } catch (e) {
      _showSnackBar('Error picking file: $e', Colors.red);
    }
  }

  Future<void> _pickDate(
    DateTime? initialDate,
    Function(DateTime?) onDatePicked,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      onDatePicked(picked);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<void> _handleSaveDraft() async {
    if (_selectedMasterCourse == null) {
      _showSnackBar('Please select a master course', Colors.orange);
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showSnackBar('Course saved as draft', AppTheme.primaryBlue);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _handlePublish() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fill all required fields', Colors.orange);
      return;
    }
    if (_selectedMasterCourse == null) {
      _showSnackBar('Please select a master course', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showSnackBar('✅ Course published successfully!', Colors.green);
    if (mounted) Navigator.pop(context);
  }

  void _calculatePerUnitFee() {
    final totalFee = double.tryParse(_totalCourseFeeController.text) ?? 0;
    final duration = double.tryParse(_courseDurationController.text) ?? 1;

    if (totalFee > 0 && duration > 0) {
      if (_feeType == 'YEARWISE') {
        setState(() => _perUnitFee = totalFee / duration);
      } else {
        // Semester-wise: duration * 2 semesters
        setState(() => _perUnitFee = totalFee / (duration * 2));
      }
    }
  }

  double _calculateMandatoryTotal() {
    return _selectedMandatoryFees.fold(
      0.0,
      (sum, fee) => sum + (fee['amount'] as num),
    );
  }

  double _calculateOptionalTotal() {
    return _selectedOptionalFees.fold(
      0.0,
      (sum, fee) => sum + (fee['amount'] as num),
    );
  }

  Future<void> _showOtherFeesDialog() async {
    // Track selected fee IDs
    Set<int> selectedIds = {
      ..._selectedMandatoryFees.map((f) => f['id'] as int),
      ..._selectedOptionalFees.map((f) => f['id'] as int),
    };

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryBlue,
                      AppTheme.primaryBlue.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add_circle, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Other Fees',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Choose mandatory and optional fees',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: StatefulBuilder(
                  builder: (context, setDialogState) => SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mandatory Fees Section
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Mandatory Fees',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._availableOtherFees
                            .where((f) => f['mandatory'] == true)
                            .map((fee) {
                              final isSelected = selectedIds.contains(
                                fee['id'],
                              );
                              return CheckboxListTile(
                                dense: true,
                                title: Text(
                                  fee['name'] as String,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                subtitle: Text(
                                  '₹${fee['amount']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                value: isSelected,
                                onChanged: (value) {
                                  setDialogState(() {
                                    if (value == true) {
                                      selectedIds.add(fee['id'] as int);
                                    } else {
                                      selectedIds.remove(fee['id']);
                                    }
                                  });
                                },
                                activeColor: Colors.red,
                              );
                            }),

                        const SizedBox(height: 16),

                        // Optional Fees Section
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange[200]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add_circle_outline,
                                color: Colors.orange,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Optional Fees',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._availableOtherFees
                            .where((f) => f['mandatory'] == false)
                            .map((fee) {
                              final isSelected = selectedIds.contains(
                                fee['id'],
                              );
                              return CheckboxListTile(
                                dense: true,
                                title: Text(
                                  fee['name'] as String,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                subtitle: Text(
                                  '₹${fee['amount']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                value: isSelected,
                                onChanged: (value) {
                                  setDialogState(() {
                                    if (value == true) {
                                      selectedIds.add(fee['id'] as int);
                                    } else {
                                      selectedIds.remove(fee['id']);
                                    }
                                  });
                                },
                                activeColor: Colors.orange,
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer Buttons
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Update selections
                          setState(() {
                            _selectedMandatoryFees = _availableOtherFees
                                .where(
                                  (f) =>
                                      f['mandatory'] == true &&
                                      selectedIds.contains(f['id']),
                                )
                                .toList();
                            _selectedOptionalFees = _availableOtherFees
                                .where(
                                  (f) =>
                                      f['mandatory'] == false &&
                                      selectedIds.contains(f['id']),
                                )
                                .toList();
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppHeader(
        title: 'Add New Course',
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECTION A: Master Panel
              _buildSectionCard(
                title: '🏛 MASTER PANEL',
                subtitle: 'Select Course from Master Database',
                children: [
                  _buildMasterCourseDropdown(),
                  if (_selectedMasterCourse != null) ...[
                    const SizedBox(height: 16),
                    _buildReadOnlyMasterFields(),
                  ],
                ],
              ),

              if (_selectedMasterCourse != null) ...[
                const SizedBox(height: 16),
                const Divider(thickness: 2),
                const SizedBox(height: 16),

                // SECTION B: University Panel
                _buildSectionCard(
                  title: '🎓 1. COURSE INFORMATION',
                  children: [_buildCourseInformationFields()],
                ),

                const SizedBox(height: 16),
                _buildSectionCard(
                  title: '💰 2. FEE STRUCTURE',
                  children: [_buildFeeStructureFields()],
                ),

                const SizedBox(height: 16),
                _buildSectionCard(
                  title: '🧾 3. DOCUMENTS & REFERENCES',
                  children: [_buildDocumentsFields()],
                ),

                const SizedBox(height: 16),
                _buildSectionCard(
                  title: '🏠 4. FACILITIES',
                  children: [_buildFacilitiesFields()],
                ),

                const SizedBox(height: 16),
                _buildSectionCard(
                  title: '📅 5. ADMISSION TIMELINE',
                  children: [_buildTimelineFields()],
                ),

                const SizedBox(height: 16),
                _buildSectionCard(
                  title: '💬 6. NOTES / ADDITIONAL INFO',
                  children: [_buildNotesFields()],
                ),

                const SizedBox(height: 16),
                _buildSectionCard(
                  title: '🟢 7. VISIBILITY & STATUS',
                  children: [_buildVisibilityFields()],
                ),

                const SizedBox(height: 24),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _handleSaveDraft,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Save as Draft'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        label: 'Publish Course',
                        onPressed: _handlePublish,
                        isLoading: _isLoading,
                        icon: Icons.publish,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.charcoal,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildMasterCourseDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedMasterCourse != null
          ? _selectedMasterCourse!.id
          : null,
      decoration: InputDecoration(
        labelText: 'Select Course from Master List *',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      isExpanded: true,
      items: _masterCoursesList.map((course) {
        return DropdownMenuItem(
          value: course.id,
          child: Text(
            '${course.abbreviation ?? course.name} - ${course.level ?? ''}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
      }).toList(),
      onChanged: (value) => setState(
        () => _selectedMasterCourse = _masterCoursesList.firstWhere(
          (course) => course.id == value,
        ),
      ),
      validator: (value) => value == null ? 'Please select a course' : null,
    );
  }

  Widget _buildReadOnlyMasterFields() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📘 Master Course Details (Read-Only)',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade900,
            ),
          ),
          const SizedBox(height: 12),
          _buildReadOnlyField(
            'Course Full Name',
            _selectedMasterCourse?.name ?? 'N/A',
          ),
          _buildReadOnlyField(
            'Stream / Discipline',
            _selectedMasterCourse?.department ?? 'N/A',
          ),
          _buildReadOnlyField(
            'Duration',
            _selectedMasterCourse?.duration ?? 'N/A',
          ),
          _buildReadOnlyField('Level', _selectedMasterCourse?.level ?? 'N/A'),
          _buildReadOnlyField(
            'Eligibility',
            (_selectedMasterCourse?.eligibility ?? []).join(', '),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInformationFields() {
    return Column(
      children: [
        CustomTextField(
          label: 'Custom Course Description',
          hint: 'Add specific highlights of your program',
          controller: _customDescriptionController,
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _courseMode,
          decoration: InputDecoration(
            labelText: 'Course Mode *',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: ['Regular', 'Distance', 'Online', 'Part-Time'].map((mode) {
            return DropdownMenuItem(value: mode, child: Text(mode));
          }).toList(),
          onChanged: (value) => setState(() => _courseMode = value!),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Intake Capacity *',
                hint: 'Total seats',
                controller: _intakeCapacityController,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'Available Seats *',
                hint: 'Vacant seats',
                controller: _availableSeatsController,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _admissionTypes.map((type) {
            return FilterChip(
              label: Text(type),
              selected: _selectedAdmissionTypes.contains(type),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAdmissionTypes.add(type);
                  } else {
                    _selectedAdmissionTypes.remove(type);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Entrance Test Name',
          hint: 'e.g., NEET, CET',
          controller: _entranceTestNameController,
        ),
        const SizedBox(height: 16),
        _buildFileUploadButton(
          label: 'Upload Entrance Test PDF',
          file: _entranceTestPdfFile,
          onTap: () => _pickFile(
            (file) => setState(() => _entranceTestPdfFile = file),
            allowedExtensions: ['pdf'],
          ),
        ),
      ],
    );
  }

  Widget _buildFeeStructureFields() {
    final totalFee = double.tryParse(_totalCourseFeeController.text) ?? 0;
    final duration = double.tryParse(_courseDurationController.text) ?? 1;
    final mandatoryTotal = _calculateMandatoryTotal();
    final optionalTotal = _calculateOptionalTotal();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Total Course Fee Input
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Total Course Fee *',
                hint: '₹ Enter total fee',
                controller: _totalCourseFeeController,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onChanged: (_) => _calculatePerUnitFee(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                label: 'Duration (years) *',
                hint: '3, 4',
                controller: _courseDurationController,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onChanged: (_) => _calculatePerUnitFee(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 2. Fee Type Selector (Compact - No Overflow)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.settings, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text(
                    'Fee Type:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text(
                        'Year-wise',
                        style: TextStyle(fontSize: 12),
                      ),
                      selected: _feeType == 'YEARWISE',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _feeType = 'YEARWISE';
                            _calculatePerUnitFee();
                          });
                        }
                      },
                      selectedColor: AppTheme.primaryBlue,
                      labelStyle: TextStyle(
                        color: _feeType == 'YEARWISE'
                            ? Colors.white
                            : Colors.black87,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text(
                        'Semester-wise',
                        style: TextStyle(fontSize: 12),
                      ),
                      selected: _feeType == 'SEMESTERWISE',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _feeType = 'SEMESTERWISE';
                            _calculatePerUnitFee();
                          });
                        }
                      },
                      selectedColor: AppTheme.primaryBlue,
                      labelStyle: TextStyle(
                        color: _feeType == 'SEMESTERWISE'
                            ? Colors.white
                            : Colors.black87,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 3. Auto Fee Split Preview
        if (totalFee > 0 && _perUnitFee > 0) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!, width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calculate,
                      color: AppTheme.primaryBlue,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Auto Fee Split',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹${_perUnitFee.toStringAsFixed(0)}/${_feeType == "YEARWISE" ? "year" : "sem"}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '₹$totalFee ÷ ${_feeType == "YEARWISE" ? duration.toInt() : (duration * 2).toInt()} = ₹${_perUnitFee.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],

        // 4. Other Fees Button
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: totalFee > 0 ? _showOtherFeesDialog : null,
            icon: const Icon(Icons.add_circle, color: Colors.white, size: 20),
            label: Text(
              _selectedMandatoryFees.isEmpty && _selectedOptionalFees.isEmpty
                  ? 'Select Other Fees'
                  : 'Other Fees (${_selectedMandatoryFees.length + _selectedOptionalFees.length} selected)',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // 5. Fee Summary (Compact)
        if (_selectedMandatoryFees.isNotEmpty ||
            _selectedOptionalFees.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!, width: 1.5),
            ),
            child: Column(
              children: [
                _buildFeeRow('Base Fee', totalFee, Colors.black87),
                if (mandatoryTotal > 0) ...[
                  const SizedBox(height: 6),
                  _buildFeeRow(
                    'Mandatory (${_selectedMandatoryFees.length})',
                    mandatoryTotal,
                    Colors.red,
                  ),
                ],
                if (optionalTotal > 0) ...[
                  const SizedBox(height: 6),
                  _buildFeeRow(
                    'Optional (${_selectedOptionalFees.length})',
                    optionalTotal,
                    Colors.orange,
                  ),
                ],
                const Divider(height: 16),
                _buildFeeRow(
                  'Total Payable',
                  totalFee + mandatoryTotal,
                  Colors.green[700]!,
                  bold: true,
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // Scholarship
        SwitchListTile(
          dense: true,
          title: const Text(
            'Scholarship Available?',
            style: TextStyle(fontSize: 14),
          ),
          value: _scholarshipAvailable,
          onChanged: (value) => setState(() => _scholarshipAvailable = value),
          activeTrackColor: AppTheme.primaryBlue,
        ),
        if (_scholarshipAvailable) ...[
          const SizedBox(height: 12),
          _buildFileUploadButton(
            label: 'Upload Scholarship Policy PDF',
            file: _scholarshipPolicyFile,
            onTap: () => _pickFile(
              (file) => setState(() => _scholarshipPolicyFile = file),
              allowedExtensions: ['pdf'],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFeeRow(
    String label,
    double amount,
    Color color, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: bold ? 14 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: bold ? 15 : 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsFields() {
    final mandatoryCount = _documentRequirements
        .where((d) => d['mandatory'] == true)
        .length;
    final optionalCount = _documentRequirements
        .where((d) => d['mandatory'] == false)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // University Reference Documents - Compact Grid
        const Row(
          children: [
            Icon(Icons.folder_special, color: AppTheme.primaryBlue, size: 18),
            SizedBox(width: 6),
            Text(
              '📁 University Documents',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Compact 2x2 Grid for university documents
        Row(
          children: [
            Expanded(
              child: _buildCompactFileButton(
                'Prospectus',
                _prospectusFile,
                () => _pickFile(
                  (file) => setState(() => _prospectusFile = file),
                  allowedExtensions: ['pdf'],
                ),
                Icons.description,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCompactFileButton(
                'Fee Structure',
                _feeStructurePdfFile,
                () => _pickFile(
                  (file) => setState(() => _feeStructurePdfFile = file),
                  allowedExtensions: ['pdf'],
                ),
                Icons.attach_money,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildCompactFileButton(
                'Syllabus',
                _syllabusPdfFile,
                () => _pickFile(
                  (file) => setState(() => _syllabusPdfFile = file),
                  allowedExtensions: ['pdf'],
                ),
                Icons.book,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCompactFileButton(
                'Certificate',
                _certificateFormatFile,
                () => _pickFile(
                  (file) => setState(() => _certificateFormatFile = file),
                  allowedExtensions: ['pdf', 'jpg', 'png'],
                ),
                Icons.workspace_premium,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),

        // Student Requirements Header with inline stats
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryBlue.withValues(alpha: 0.1),
                AppTheme.primaryBlue.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.checklist_rtl,
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Document Checklist',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        Text(
                          'Required documents',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Stats row - separate to prevent overflow
              Row(
                children: [
                  Expanded(
                    child: _buildInlineStatFull(
                      '${_documentRequirements.length}',
                      'Total',
                      AppTheme.primaryBlue,
                    ),
                  ),
                  Expanded(
                    child: _buildInlineStatFull(
                      '$mandatoryCount',
                      'Required',
                      Colors.red,
                    ),
                  ),
                  Expanded(
                    child: _buildInlineStatFull(
                      '$optionalCount',
                      'Optional',
                      Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Compact Action Buttons Row
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: _showSelectDocumentsDialog,
              icon: const Icon(Icons.library_add, size: 16),
              label: const Text('Template', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                minimumSize: const Size(0, 0),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showAddCustomDocumentDialog,
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('Custom', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                minimumSize: const Size(0, 0),
              ),
            ),
            if (_documentRequirements.isNotEmpty)
              OutlinedButton.icon(
                onPressed: _showDocumentPreviewDialog,
                icon: const Icon(Icons.visibility, size: 16),
                label: const Text('Preview', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  minimumSize: const Size(0, 0),
                  side: BorderSide(color: Colors.grey[400]!),
                ),
              ),
          ],
        ),

        const SizedBox(height: 12),

        // Document List - More compact
        if (_documentRequirements.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[200]!,
                style: BorderStyle.solid,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.folder_open, size: 32, color: Colors.grey[400]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No documents added',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Add from template or create custom documents',
                        style: TextStyle(color: Colors.grey[500], fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          ..._documentRequirements.asMap().entries.map((entry) {
            final index = entry.key;
            final doc = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _buildCompactDocumentCard(doc, index),
            );
          }),
      ],
    );
  }

  Widget _buildCompactFileButton(
    String label,
    File? file,
    VoidCallback onTap,
    IconData icon,
  ) {
    final hasFile = file != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: hasFile
              ? AppTheme.success.withValues(alpha: 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasFile ? AppTheme.success : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasFile ? Icons.check_circle : icon,
              color: hasFile ? AppTheme.success : Colors.grey[600],
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: hasFile ? AppTheme.success : Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hasFile)
                    Text(
                      '✓ Uploaded',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppTheme.success.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              hasFile ? Icons.edit : Icons.upload,
              size: 14,
              color: hasFile ? AppTheme.primaryBlue : Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineStatFull(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(fontSize: 9, color: Colors.grey[600], height: 1),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDocumentCard(Map<String, dynamic> doc, int index) {
    final isMandatory = doc['mandatory'] as bool;
    final hasDescription =
        doc['description'] != null && (doc['description'] as String).isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isMandatory ? Colors.red[300]! : Colors.orange[300]!,
          width: 1.5,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isMandatory ? Colors.red[50] : Colors.orange[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                doc['type'] == 'Image' ? Icons.image : Icons.description,
                color: isMandatory ? Colors.red[700] : Colors.orange[700],
                size: 16,
              ),
            ),
            const SizedBox(width: 10),

            // Content - Flexible
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    doc['name'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hasDescription) ...[
                    const SizedBox(height: 2),
                    Text(
                      doc['description'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 6),

            // Badges and actions - Fixed width
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isMandatory ? Colors.red[600] : Colors.orange[600],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    isMandatory ? 'REQ' : 'OPT',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    doc['type'] as String,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                InkWell(
                  onTap: () => _removeDocument(index),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red[400],
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesFields() {
    return Column(
      children: [
        CustomTextField(
          label: 'Attached Hospital / Training Center',
          controller: _attachedHospitalController,
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Internship Available'),
          value: _internshipAvailable,
          onChanged: (value) => setState(() => _internshipAvailable = value),
        ),
        if (_internshipAvailable) ...[
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Duration of Internship',
            hint: 'e.g., 6 months',
            controller: _internshipDurationController,
          ),
        ],
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Placement Support Available'),
          value: _placementSupport,
          onChanged: (value) => setState(() => _placementSupport = value),
        ),
        if (_placementSupport) ...[
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Placement Partner Names',
            controller: _placementPartnersController,
            maxLines: 2,
          ),
        ],
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Special Infrastructure',
          controller: _specialInfrastructureController,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTimelineFields() {
    return Column(
      children: [
        _buildDateButton(
          'Admission Start Date',
          _admissionStartDate,
          (date) => setState(() => _admissionStartDate = date),
        ),
        const SizedBox(height: 16),
        _buildDateButton(
          'Admission Last Date',
          _admissionEndDate,
          (date) => setState(() => _admissionEndDate = date),
        ),
        const SizedBox(height: 16),
        _buildDateButton(
          'Entrance Exam Date',
          _entranceExamDate,
          (date) => setState(() => _entranceExamDate = date),
        ),
        const SizedBox(height: 16),
        _buildDateButton(
          'Counselling Start Date',
          _counsellingDate,
          (date) => setState(() => _counsellingDate = date),
        ),
      ],
    );
  }

  Widget _buildNotesFields() {
    return CustomTextField(
      label: 'Remarks / Important Instructions',
      hint: 'Add any important notes for consultants',
      controller: _remarksController,
      maxLines: 4,
    );
  }

  Widget _buildVisibilityFields() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Show on App'),
          subtitle: const Text('Make this course visible to users'),
          value: _showOnApp,
          onChanged: (value) => setState(() => _showOnApp = value),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _courseStatus,
          decoration: InputDecoration(
            labelText: 'Course Status',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: ['Draft', 'Active', 'Inactive', 'Archived']
              .map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              )
              .toList(),
          onChanged: (value) => setState(() => _courseStatus = value!),
        ),
      ],
    );
  }

  Widget _buildFileUploadButton({
    required String label,
    required File? file,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: file != null ? Colors.green.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: file != null ? Colors.green : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              file != null ? Icons.check_circle : Icons.upload_file,
              color: file != null ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                file != null ? file.path.split('/').last : label,
                style: TextStyle(
                  color: file != null
                      ? Colors.green.shade900
                      : Colors.grey.shade700,
                ),
              ),
            ),
            if (file != null)
              const Icon(Icons.edit, size: 18, color: AppTheme.primaryBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(
    String label,
    DateTime? date,
    Function(DateTime?) onDatePicked,
  ) {
    return InkWell(
      onTap: () => _pickDate(date, onDatePicked),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppTheme.primaryBlue),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                date != null ? '${date.day}/${date.month}/${date.year}' : label,
                style: TextStyle(
                  color: date != null ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== DOCUMENTS & REQUIREMENTS MODULE METHODS ====================

  void _showSelectDocumentsDialog() {
    // Track selected document IDs
    Set<int> selectedIds = _documentRequirements
        .map((d) => d['doc_id'] as int)
        .toSet();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryBlue,
                        AppTheme.primaryBlue.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.checklist,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select from Document Template',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Choose documents required for admission',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mandatory Documents
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.red,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Mandatory Documents',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._defaultDocuments
                            .where((d) => d['mandatory'] == true)
                            .map((doc) {
                              final isSelected = selectedIds.contains(
                                doc['doc_id'],
                              );
                              return CheckboxListTile(
                                dense: true,
                                title: Text(
                                  doc['name'] as String,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                subtitle: Text(
                                  doc['description'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                value: isSelected,
                                onChanged: (value) {
                                  setDialogState(() {
                                    if (value == true) {
                                      selectedIds.add(doc['doc_id'] as int);
                                    } else {
                                      selectedIds.remove(doc['doc_id']);
                                    }
                                  });
                                },
                              );
                            }),

                        const SizedBox(height: 16),

                        // Optional Documents
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange[200]!),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info, color: Colors.orange, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Optional Documents',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._defaultDocuments
                            .where((d) => d['mandatory'] == false)
                            .map((doc) {
                              final isSelected = selectedIds.contains(
                                doc['doc_id'],
                              );
                              return CheckboxListTile(
                                dense: true,
                                title: Text(
                                  doc['name'] as String,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                subtitle: Text(
                                  doc['description'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                value: isSelected,
                                onChanged: (value) {
                                  setDialogState(() {
                                    if (value == true) {
                                      selectedIds.add(doc['doc_id'] as int);
                                    } else {
                                      selectedIds.remove(doc['doc_id']);
                                    }
                                  });
                                },
                              );
                            }),
                      ],
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              // Add selected documents that aren't already added
                              for (var doc in _defaultDocuments) {
                                if (selectedIds.contains(doc['doc_id']) &&
                                    !_documentRequirements.any(
                                      (d) => d['doc_id'] == doc['doc_id'],
                                    )) {
                                  _documentRequirements.add(
                                    Map<String, dynamic>.from(doc),
                                  );
                                }
                              }
                              // Remove deselected documents
                              _documentRequirements.removeWhere(
                                (d) => !selectedIds.contains(d['doc_id']),
                              );
                            });
                            Navigator.pop(context);
                            _showSnackBar(
                              '✅ Documents added successfully!',
                              AppTheme.success,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.success,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: Text(
                            'Add ${selectedIds.length} Documents',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCustomDocumentDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedType = 'File';
    bool isMandatory = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 550),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.success,
                        AppTheme.success.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Custom Document',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Create a new document requirement',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Document Name *',
                              hintText:
                                  'e.g., Gap Certificate, Experience Letter',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(
                                Icons.document_scanner,
                                size: 20,
                              ),
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: selectedType,
                            decoration: InputDecoration(
                              labelText: 'Document Type *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.category, size: 20),
                            ),
                            items: ['File', 'Image', 'PDF'].map((t) {
                              return DropdownMenuItem(value: t, child: Text(t));
                            }).toList(),
                            onChanged: (v) =>
                                setDialogState(() => selectedType = v!),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              hintText: 'Purpose or note about this document',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile(
                            dense: true,
                            title: const Text(
                              'Mandatory Document',
                              style: TextStyle(fontSize: 13),
                            ),
                            subtitle: const Text(
                              'Required for admission',
                              style: TextStyle(fontSize: 11),
                            ),
                            value: isMandatory,
                            onChanged: (v) =>
                                setDialogState(() => isMandatory = v),
                            activeTrackColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                _documentRequirements.add({
                                  'doc_id':
                                      DateTime.now().millisecondsSinceEpoch,
                                  'name': nameController.text,
                                  'type': selectedType,
                                  'mandatory': isMandatory,
                                  'status': 'Active',
                                  'description': descriptionController.text,
                                });
                              });
                              Navigator.pop(context);
                              _showSnackBar(
                                '✅ Custom document added!',
                                AppTheme.success,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.success,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Add Document',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDocumentPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryBlue,
                      AppTheme.primaryBlue.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.preview, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Document Checklist Preview',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$_documentTemplateName - ${_documentRequirements.length} documents',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: DataTable(
                    columnSpacing: 16,
                    headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Document',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Type',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Mandatory',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Status',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    rows: _documentRequirements.map((doc) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  doc['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (doc['description'] != null &&
                                    (doc['description'] as String).isNotEmpty)
                                  Text(
                                    doc['description'] as String,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              doc['type'] as String,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: doc['mandatory']
                                    ? Colors.red
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                doc['mandatory'] ? 'YES' : 'NO',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.success,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                doc['status'] as String,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Close'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeDocument(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Document?'),
        content: Text(
          'Are you sure you want to remove "${_documentRequirements[index]['name']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _documentRequirements.removeAt(index));
              Navigator.pop(context);
              _showSnackBar('Document removed', Colors.orange);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
