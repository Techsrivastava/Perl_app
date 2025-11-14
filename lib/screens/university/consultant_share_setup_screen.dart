import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class ConsultantShareSetupScreen extends StatefulWidget {
  const ConsultantShareSetupScreen({Key? key}) : super(key: key);

  @override
  State<ConsultantShareSetupScreen> createState() =>
      _ConsultantShareSetupScreenState();
}

class _ConsultantShareSetupScreenState
    extends State<ConsultantShareSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _shareValueController = TextEditingController();
  final _remarksController = TextEditingController();
  final _consultantSearchController = TextEditingController();
  final _courseSearchController = TextEditingController();

  // Search & Filter
  String _consultantSearchQuery = '';
  String _courseSearchQuery = '';
  String _courseCategoryFilter = 'All';
  double _minFeeFilter = 0;
  double _maxFeeFilter = 100000;

  // Share Type
  String _shareType = 'Percentage';
  final List<String> _shareTypes = ['Percentage', 'Flat', 'One-Time'];

  // Application Scope
  String _applyTo = 'All Courses';

  // Duration for One-Time
  String _duration = '1st Year Only';

  // Selected Consultants
  List<String> _selectedConsultants = [];
  final List<Map<String, String>> _consultants = [
    {'id': 'C001', 'name': 'Rajesh Kumar', 'region': 'North'},
    {'id': 'C002', 'name': 'Priya Sharma', 'region': 'South'},
    {'id': 'C003', 'name': 'Amit Patel', 'region': 'West'},
    {'id': 'C004', 'name': 'Neha Singh', 'region': 'East'},
    {'id': 'C005', 'name': 'Sanjay Gupta', 'region': 'Central'},
  ];

  // Selected Courses
  List<String> _selectedCourses = [];
  final List<Map<String, dynamic>> _courses = [
    {
      'id': 'CS001',
      'name': 'B.Tech Computer Science',
      'fee': 50000,
      'category': 'Engineering',
    },
    {'id': 'CS002', 'name': 'MBA', 'fee': 80000, 'category': 'Management'},
    {
      'id': 'CS003',
      'name': 'M.Tech AI/ML',
      'fee': 60000,
      'category': 'Engineering',
    },
    {'id': 'CS004', 'name': 'BBA', 'fee': 40000, 'category': 'Management'},
    {
      'id': 'CS005',
      'name': 'B.Sc Data Science',
      'fee': 45000,
      'category': 'Science',
    },
  ];

  // Document upload
  String? _uploadedDocumentName;

  // Calculation results
  double _courseFee = 0;
  double _consultantShare = 0;
  double _universityProfit = 0;

  // Apply same share to all courses
  bool _applySameShareToAll = true;

  // Loading state
  bool _isLoading = false;

  @override
  void dispose() {
    _shareValueController.dispose();
    _remarksController.dispose();
    _consultantSearchController.dispose();
    _courseSearchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredConsultants {
    return _consultants.where((consultant) {
      final matchesSearch =
          _consultantSearchQuery.isEmpty ||
          consultant['name']!.toLowerCase().contains(
            _consultantSearchQuery.toLowerCase(),
          ) ||
          consultant['id']!.toLowerCase().contains(
            _consultantSearchQuery.toLowerCase(),
          ) ||
          consultant['region']!.toLowerCase().contains(
            _consultantSearchQuery.toLowerCase(),
          );
      return matchesSearch;
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredCourses {
    return _courses.where((course) {
      final matchesSearch =
          _courseSearchQuery.isEmpty ||
          course['name'].toString().toLowerCase().contains(
            _courseSearchQuery.toLowerCase(),
          );
      final matchesCategory =
          _courseCategoryFilter == 'All' ||
          course['category'] == _courseCategoryFilter;
      final matchesFee =
          course['fee'] >= _minFeeFilter && course['fee'] <= _maxFeeFilter;
      return matchesSearch && matchesCategory && matchesFee;
    }).toList();
  }

  void _calculateShare() {
    if (_shareValueController.text.isEmpty || _selectedCourses.isEmpty) {
      setState(() {
        _courseFee = 0;
        _consultantShare = 0;
        _universityProfit = 0;
      });
      return;
    }

    // Get average fee if multiple courses selected
    double totalFee = 0;
    for (var courseId in _selectedCourses) {
      var course = _courses.firstWhere((c) => c['id'] == courseId);
      totalFee += course['fee'];
    }
    _courseFee = _selectedCourses.isNotEmpty
        ? totalFee / _selectedCourses.length
        : 0;

    double shareValue = double.tryParse(_shareValueController.text) ?? 0;

    if (_shareType == 'Percentage') {
      _consultantShare = (_courseFee * shareValue) / 100;
    } else if (_shareType == 'Flat') {
      _consultantShare = shareValue;
    } else if (_shareType == 'One-Time') {
      _consultantShare = shareValue;
    }

    _universityProfit = _courseFee - _consultantShare;

    setState(() {});
  }

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _uploadedDocumentName = result.files.single.name;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Document uploaded: ${result.files.single.name}'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading document: $e'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  void _showPreviewModal() {
    if (_formKey.currentState!.validate()) {
      if (_selectedConsultants.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one consultant'),
            backgroundColor: AppTheme.error,
          ),
        );
        return;
      }

      if (_applyTo == 'Specific Courses' && _selectedCourses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one course'),
            backgroundColor: AppTheme.error,
          ),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Preview Share Summary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPreviewRow('Share Type', _shareType),
                const Divider(),
                _buildPreviewRow(
                  'Share Value',
                  _shareType == 'Percentage'
                      ? '${_shareValueController.text}%'
                      : '₹${_shareValueController.text}',
                ),
                const Divider(),
                _buildPreviewRow('Apply To', _applyTo),
                const Divider(),
                _buildPreviewRow(
                  'Selected Consultants',
                  '${_selectedConsultants.length}',
                ),
                if (_applyTo == 'Specific Courses') ...[
                  const Divider(),
                  _buildPreviewRow(
                    'Selected Courses',
                    '${_selectedCourses.length}',
                  ),
                ],
                const Divider(),
                const SizedBox(height: 12),
                const Text(
                  'Calculation Summary (Avg)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                _buildPreviewRow(
                  'Course Fee',
                  '₹${NumberFormat('#,##,###').format(_courseFee)}',
                ),
                _buildPreviewRow(
                  'Consultant Share',
                  '₹${NumberFormat('#,##,###').format(_consultantShare)}',
                  valueColor: AppTheme.warning,
                ),
                _buildPreviewRow(
                  'University Profit',
                  '₹${NumberFormat('#,##,###').format(_universityProfit)}',
                  valueColor: AppTheme.success,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _saveShareSetup();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Confirm & Save',
                style: TextStyle(color: AppTheme.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPreviewRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.mediumGray),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppTheme.charcoal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveShareSetup() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '✅ Consultant share setup saved successfully!\n📤 Consultants have been notified.',
        ),
        backgroundColor: AppTheme.success,
        duration: Duration(seconds: 3),
      ),
    );

    // Reset form
    _formKey.currentState!.reset();
    setState(() {
      _selectedConsultants.clear();
      _selectedCourses.clear();
      _shareValueController.clear();
      _remarksController.clear();
      _uploadedDocumentName = null;
      _courseFee = 0;
      _consultantShare = 0;
      _universityProfit = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: const AppHeader(title: '🤝 Consultant Share Setup'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Module Description (Compact)
                    _buildInfoCard(),

                    const SizedBox(height: 10),

                    // 1. Share Type Section
                    _buildSectionCard(
                      title: '1️⃣ Share Type',
                      child: _buildShareTypeSection(),
                    ),

                    const SizedBox(height: 10),

                    // 2. Select Consultants Section
                    _buildSectionCard(
                      title: '2️⃣ Consultants',
                      child: _buildConsultantSelectionSection(),
                    ),

                    const SizedBox(height: 10),

                    // 3. Apply To Section
                    _buildSectionCard(
                      title: '3️⃣ Scope',
                      child: _buildApplicationScopeSection(),
                    ),

                    if (_applyTo == 'Specific Courses') ...[
                      const SizedBox(height: 10),
                      _buildSectionCard(
                        title: '4️⃣ Courses',
                        child: _buildCourseSelectionSection(),
                      ),
                    ],

                    const SizedBox(height: 10),

                    // 4. Enter Share Details
                    _buildSectionCard(
                      title:
                          '${_applyTo == 'Specific Courses' ? '5️⃣' : '4️⃣'} Share Value',
                      child: _buildShareDetailsSection(),
                    ),

                    const SizedBox(height: 10),

                    // 5. Auto Calculation Summary
                    _buildSectionCard(
                      title:
                          '${_applyTo == 'Specific Courses' ? '6️⃣' : '5️⃣'} Auto Calculation Summary',
                      child: _buildCalculationSummary(),
                    ),

                    const SizedBox(height: 16),

                    // 6. Upload Document
                    _buildSectionCard(
                      title:
                          '${_applyTo == 'Specific Courses' ? '7️⃣' : '6️⃣'} Upload Supporting Document (Optional)',
                      child: _buildDocumentUploadSection(),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    _buildActionButtons(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryBlue.withOpacity(0.1), AppTheme.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.info_outline,
              color: AppTheme.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Define and manage commission structure for consultants. Auto-calculate profit distribution for transparent revenue sharing.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.charcoal,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildShareTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share Type',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.mediumGray,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _shareType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: AppTheme.lightGray.withOpacity(0.3),
          ),
          items: _shareTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type, style: const TextStyle(fontSize: 13)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _shareType = value!;
              _calculateShare();
            });
          },
        ),
        const SizedBox(height: 8),
        Text(
          _shareType == 'Percentage'
              ? '📊 Share calculated as % of course fee'
              : _shareType == 'Flat'
              ? '💰 Fixed amount per student enrollment'
              : '🎯 One-time payment (1st year or full duration)',
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.mediumGray.withOpacity(0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildConsultantSelectionSection() {
    final filteredConsultants = _filteredConsultants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        TextField(
          controller: _consultantSearchController,
          decoration: InputDecoration(
            hintText: '🔍 Search consultants by name, ID, or region...',
            hintStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: AppTheme.lightGray.withOpacity(0.3),
            suffixIcon: _consultantSearchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _consultantSearchController.clear();
                      setState(() => _consultantSearchQuery = '');
                    },
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 12),
          onChanged: (value) => setState(() => _consultantSearchQuery = value),
        ),
        const SizedBox(height: 10),

        // Consultant List (Compact)
        Container(
          constraints: const BoxConstraints(maxHeight: 180),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.mediumGray.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: filteredConsultants.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No consultants found',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  children: filteredConsultants.map((consultant) {
                    bool isSelected = _selectedConsultants.contains(
                      consultant['id'],
                    );
                    return CheckboxListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              consultant['name']!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              consultant['id']!,
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        consultant['region']!,
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppTheme.mediumGray,
                        ),
                      ),
                      value: isSelected,
                      activeColor: AppTheme.primaryBlue,
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            _selectedConsultants.add(consultant['id']!);
                          } else {
                            _selectedConsultants.remove(consultant['id']);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '✅ Selected: ${_selectedConsultants.length}',
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.success,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_selectedConsultants.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => _selectedConsultants.clear()),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Clear All', style: TextStyle(fontSize: 10)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildApplicationScopeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Apply To',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.mediumGray,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'All Courses',
                  style: TextStyle(fontSize: 12),
                ),
                value: 'All Courses',
                groupValue: _applyTo,
                activeColor: AppTheme.primaryBlue,
                onChanged: (value) {
                  setState(() {
                    _applyTo = value!;
                    if (_applyTo == 'All Courses') {
                      _selectedCourses = _courses
                          .map((c) => c['id'] as String)
                          .toList();
                    } else {
                      _selectedCourses.clear();
                    }
                    _calculateShare();
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Specific Courses',
                  style: TextStyle(fontSize: 12),
                ),
                value: 'Specific Courses',
                groupValue: _applyTo,
                activeColor: AppTheme.primaryBlue,
                onChanged: (value) {
                  setState(() {
                    _applyTo = value!;
                    _selectedCourses.clear();
                    _calculateShare();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCourseSelectionSection() {
    final filteredCourses = _filteredCourses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        TextField(
          controller: _courseSearchController,
          decoration: InputDecoration(
            hintText: '🔍 Search courses...',
            hintStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: AppTheme.lightGray.withOpacity(0.3),
            suffixIcon: _courseSearchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _courseSearchController.clear();
                      setState(() => _courseSearchQuery = '');
                    },
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 12),
          onChanged: (value) => setState(() => _courseSearchQuery = value),
        ),
        const SizedBox(height: 8),

        // Filters Row (Compact)
        Row(
          children: [
            // Category Filter
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _courseCategoryFilter,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: const TextStyle(fontSize: 10),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 11, color: AppTheme.charcoal),
                items: ['All', 'Engineering', 'Management', 'Science'].map((
                  cat,
                ) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) =>
                    setState(() => _courseCategoryFilter = value!),
              ),
            ),
            const SizedBox(width: 8),
            // Quick Fee Filters
            Expanded(
              child: Wrap(
                spacing: 4,
                children: [
                  FilterChip(
                    label: const Text('< 50K', style: TextStyle(fontSize: 9)),
                    selected: _minFeeFilter == 0 && _maxFeeFilter == 50000,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _minFeeFilter = 0;
                          _maxFeeFilter = 50000;
                        } else {
                          _minFeeFilter = 0;
                          _maxFeeFilter = 100000;
                        }
                      });
                    },
                    selectedColor: AppTheme.primaryBlue.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  FilterChip(
                    label: const Text('> 50K', style: TextStyle(fontSize: 9)),
                    selected: _minFeeFilter == 50000,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _minFeeFilter = 50000;
                          _maxFeeFilter = 100000;
                        } else {
                          _minFeeFilter = 0;
                          _maxFeeFilter = 100000;
                        }
                      });
                    },
                    selectedColor: AppTheme.primaryBlue.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Course List (Compact)
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.mediumGray.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: filteredCourses.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No courses found',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  children: filteredCourses.map((course) {
                    bool isSelected = _selectedCourses.contains(course['id']);
                    return CheckboxListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              course['name'],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '₹${NumberFormat('#,##,###').format(course['fee'])}',
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppTheme.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course['category'],
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppTheme.mediumGray,
                            ),
                          ),
                        ],
                      ),
                      value: isSelected,
                      activeColor: AppTheme.primaryBlue,
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            _selectedCourses.add(course['id'] as String);
                          } else {
                            _selectedCourses.remove(course['id']);
                          }
                          _calculateShare();
                        });
                      },
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _applySameShareToAll,
                  activeColor: AppTheme.primaryBlue,
                  onChanged: (value) =>
                      setState(() => _applySameShareToAll = value!),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const Text('Same share', style: TextStyle(fontSize: 10)),
              ],
            ),
            Text(
              '✅ ${_selectedCourses.length} selected',
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.success,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_selectedCourses.isNotEmpty)
              TextButton(
                onPressed: () => setState(() {
                  _selectedCourses.clear();
                  _calculateShare();
                }),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Clear', style: TextStyle(fontSize: 10)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildShareDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Consultant Share Value',
          hint: _shareType == 'Percentage'
              ? 'Enter percentage (e.g., 10)'
              : 'Enter amount (e.g., 5000)',
          controller: _shareValueController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter share value';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter valid number';
            }
            if (_shareType == 'Percentage' && double.parse(value) > 100) {
              return 'Percentage cannot exceed 100%';
            }
            return null;
          },
          onChanged: (value) => _calculateShare(),
        ),

        if (_shareType == 'One-Time') ...[
          const SizedBox(height: 12),
          const Text(
            'Duration',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.mediumGray,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    '1st Year Only',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: '1st Year Only',
                  groupValue: _duration,
                  activeColor: AppTheme.primaryBlue,
                  onChanged: (value) => setState(() => _duration = value!),
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Full Duration',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: 'Full Duration',
                  groupValue: _duration,
                  activeColor: AppTheme.primaryBlue,
                  onChanged: (value) => setState(() => _duration = value!),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCalculationSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.success.withOpacity(0.05), AppTheme.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.success.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildCalculationRow(
            'Course Fee (Avg)',
            '₹${NumberFormat('#,##,###').format(_courseFee)}',
            Icons.school,
            AppTheme.primaryBlue,
          ),
          const Divider(height: 20),
          _buildCalculationRow(
            'Consultant Share',
            '₹${NumberFormat('#,##,###').format(_consultantShare)}',
            Icons.person,
            AppTheme.warning,
          ),
          const Divider(height: 20),
          _buildCalculationRow(
            'University Net Income',
            '₹${NumberFormat('#,##,###').format(_universityProfit)}',
            Icons.account_balance,
            AppTheme.success,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.mediumGray),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: _pickDocument,
          icon: const Icon(Icons.upload_file, size: 18),
          label: Text(_uploadedDocumentName ?? 'Upload MOU / Agreement'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        if (_uploadedDocumentName != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.check_circle, color: AppTheme.success, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _uploadedDocumentName!,
                  style: const TextStyle(fontSize: 11, color: AppTheme.success),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () => setState(() => _uploadedDocumentName = null),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Remarks / Notes (Optional)',
          hint: 'Enter any additional information or agreement terms',
          controller: _remarksController,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/consultant-share-report');
            },
            icon: const Icon(Icons.assessment, size: 18),
            label: const Text('View Reports'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _showPreviewModal,
            icon: const Icon(Icons.preview, size: 18, color: AppTheme.white),
            label: const Text(
              'Preview & Save',
              style: TextStyle(color: AppTheme.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
