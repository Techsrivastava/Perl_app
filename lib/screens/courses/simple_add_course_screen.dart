import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/models/course_model.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/fee_structure_widget.dart';

class SimpleAddCourseScreen extends StatefulWidget {
  const SimpleAddCourseScreen({Key? key}) : super(key: key);

  @override
  State<SimpleAddCourseScreen> createState() => _SimpleAddCourseScreenState();
}

class _SimpleAddCourseScreenState extends State<SimpleAddCourseScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late TabController _tabController;
  
  // Basic Course Info
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _courseDurationController = TextEditingController(text: '3');
  final TextEditingController _courseDescriptionController = TextEditingController();
  final TextEditingController _totalSeatsController = TextEditingController(text: '60');
  final TextEditingController _availableSeatsController = TextEditingController(text: '60');
  final TextEditingController _eligibilityController = TextEditingController();
  
  String _selectedCategory = 'B.Tech';
  String _selectedDepartment = 'Computer Science';
  bool _isActive = true;
  bool _scholarshipAvailable = false;
  
  // Fee Structure Data
  List<FeeItem> _feeStructure = [];
  Map<String, dynamic> _feeMeta = {
    'duration_years': 3.0,
    'semesters_per_year': 2,
    'months_per_year': 10,
  };
  
  final List<String> _categories = ['B.Tech', 'B.Sc', 'B.A', 'B.Com', 'M.Tech', 'MBA', 'BBA', 'MCA'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _courseDurationController.dispose();
    _courseDescriptionController.dispose();
    _totalSeatsController.dispose();
    _availableSeatsController.dispose();
    _eligibilityController.dispose();
    super.dispose();
  }
  
  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      // Simulate save
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Course saved successfully with detailed fee structure!'),
            backgroundColor: AppTheme.success,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Add New Course'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Basic Info'),
            Tab(icon: Icon(Icons.currency_rupee), text: 'Fee Structure'),
            Tab(icon: Icon(Icons.settings), text: 'Additional'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicInfoTab(),
                  _buildFeeStructureTab(),
                  _buildAdditionalTab(),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_tabController.index > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _tabController.animateTo(_tabController.index - 1);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppTheme.primaryBlue),
                  ),
                  child: const Text('Previous'),
                ),
              ),
            if (_tabController.index > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _tabController.index < 2
                    ? () => _tabController.animateTo(_tabController.index + 1)
                    : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.success,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 2,
                ),
                child: Text(
                  _tabController.index < 2 ? 'Next' : 'Save Course',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Category Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.category, color: AppTheme.primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text('Course Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Degree Type',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    decoration: const InputDecoration(
                      labelText: 'Department/Branch',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_tree),
                    ),
                    items: AppConstants.departments.map((dept) => DropdownMenuItem(value: dept, child: Text(dept))).toList(),
                    onChanged: (v) => setState(() => _selectedDepartment = v!),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Course Details Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.description, color: AppTheme.primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text('Course Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _courseNameController,
                    decoration: const InputDecoration(
                      labelText: 'Course Name *',
                      hintText: 'e.g., Computer Science Engineering',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.book),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _courseCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Course Code *',
                      hintText: 'e.g., CSE-01',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.code),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _courseDurationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Duration (years) *',
                      hintText: '3 or 4',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                    onChanged: (v) {
                      setState(() {
                        _feeMeta['duration_years'] = double.tryParse(v) ?? 3.0;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _courseDescriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter course description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.notes),
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Seats Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.event_seat, color: AppTheme.primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text('Seat Allocation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _totalSeatsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Total Seats',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.event_seat),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _availableSeatsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Available Seats',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.event_available),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _eligibilityController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Eligibility Criteria',
                      hintText: 'e.g., 12th Pass with 60%, JEE Mains',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.checklist),
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeeStructureTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Define comprehensive fee structure with mixed units (Per Year/Semester/Month/One-time). Totals auto-calculate.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          FeeStructureWidget(
            durationYears: double.tryParse(_courseDurationController.text) ?? 3.0,
            onFeeStructureChanged: (feeItems, durationYears, semPerYear, monthsPerYear) {
              setState(() {
                _feeStructure = feeItems;
                _feeMeta = {
                  'duration_years': durationYears,
                  'semesters_per_year': semPerYear,
                  'months_per_year': monthsPerYear,
                };
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildAdditionalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.toggle_on, color: AppTheme.primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text('Course Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Active Status'),
                    subtitle: const Text('Course will be visible to students'),
                    value: _isActive,
                    onChanged: (v) => setState(() => _isActive = v),
                    activeColor: AppTheme.success,
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Scholarship Available'),
                    subtitle: const Text('Students can apply for scholarships'),
                    value: _scholarshipAvailable,
                    onChanged: (v) => setState(() => _scholarshipAvailable = v),
                    activeColor: AppTheme.success,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.summarize, color: AppTheme.primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text('Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow('Course Name', _courseNameController.text.isEmpty ? 'Not set' : _courseNameController.text),
                  _buildSummaryRow('Category', '$_selectedCategory - $_selectedDepartment'),
                  _buildSummaryRow('Duration', '${_courseDurationController.text} years'),
                  _buildSummaryRow('Total Seats', _totalSeatsController.text.isEmpty ? '0' : _totalSeatsController.text),
                  _buildSummaryRow('Fee Items', _feeStructure.isEmpty ? 'Not configured' : '${_feeStructure.length} items'),
                  _buildSummaryRow('Status', _isActive ? '✅ Active' : '❌ Inactive'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
