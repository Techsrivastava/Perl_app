import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class AdmissionApplicationScreen extends StatefulWidget {
  final Map<String, dynamic> course;
  
  const AdmissionApplicationScreen({super.key, required this.course});

  @override
  State<AdmissionApplicationScreen> createState() => _AdmissionApplicationScreenState();
}

class _AdmissionApplicationScreenState extends State<AdmissionApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  
  // Student Details
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _dobController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  
  String _gender = 'Male';
  String _selectedState = 'Select State';
  String _category = 'General';
  
  // Academic Details
  final _tenth_board = TextEditingController();
  final _tenth_marks = TextEditingController();
  final _tenth_year = TextEditingController();
  final _twelfth_board = TextEditingController();
  final _twelfth_marks = TextEditingController();
  final _twelfth_year = TextEditingController();
  
  // Documents
  final Map<String, bool> _uploadedDocs = {
    '10th Marksheet': false,
    '12th Marksheet': false,
    'Transfer Certificate': false,
    'Aadhar Card': false,
    'Passport Photo': false,
  };
  
  final List<String> _indianStates = [
    'Select State', 'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka', 'Kerala',
    'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha',
    'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura', 'Uttar Pradesh',
    'Uttarakhand', 'West Bengal', 'Delhi', 'Jammu & Kashmir'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Apply for Admission'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCourseInfo(),
                    const SizedBox(height: 20),
                    if (_currentStep == 0) _buildStudentDetails(),
                    if (_currentStep == 1) _buildAcademicDetails(),
                    if (_currentStep == 2) _buildDocumentUpload(),
                    if (_currentStep == 3) _buildReviewSubmit(),
                  ],
                ),
              ),
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStepIndicator(0, 'Student', Icons.person),
          _buildStepLine(0),
          _buildStepIndicator(1, 'Academic', Icons.school),
          _buildStepLine(1),
          _buildStepIndicator(2, 'Documents', Icons.upload_file),
          _buildStepLine(2),
          _buildStepIndicator(3, 'Review', Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, IconData icon) {
    bool isActive = step == _currentStep;
    bool isCompleted = step < _currentStep;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : (isActive ? AppTheme.primaryBlue : Colors.grey[300]),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppTheme.primaryBlue : Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int step) {
    bool isCompleted = step < _currentStep;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isCompleted ? Colors.green : Colors.grey[300],
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryBlue.withValues(alpha: 0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: AppTheme.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.course['course_name'],
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                widget.course['university_name'],
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              const Spacer(),
              Text(
                '₹${widget.course['total_fee']}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Student Details'),
        const SizedBox(height: 12),
        
        _buildTextField('Full Name', _nameController, 'Enter full name', Icons.person, required: true),
        _buildTextField('Email Address', _emailController, 'Enter email', Icons.email, keyboardType: TextInputType.emailAddress, required: true),
        _buildTextField('Mobile Number', _mobileController, 'Enter 10-digit mobile', Icons.phone, keyboardType: TextInputType.phone, maxLength: 10, required: true),
        
        Row(
          children: [
            Expanded(child: _buildDropdown('Gender', _gender, ['Male', 'Female', 'Other'], (val) => setState(() => _gender = val!))),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('Date of Birth', _dobController, 'DD/MM/YYYY', Icons.calendar_today, required: true)),
          ],
        ),
        
        _buildTextField('Father\'s Name', _fatherNameController, 'Enter father\'s name', Icons.person_outline, required: true),
        _buildTextField('Mother\'s Name', _motherNameController, 'Enter mother\'s name', Icons.person_outline, required: true),
        
        _buildDropdown('Category', _category, ['General', 'OBC', 'SC', 'ST', 'EWS'], (val) => setState(() => _category = val!)),
        
        _buildTextField('Address', _addressController, 'Enter full address', Icons.home, maxLines: 3, required: true),
        
        Row(
          children: [
            Expanded(child: _buildTextField('City', _cityController, 'Enter city', Icons.location_city, required: true)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('Pincode', _pincodeController, 'Enter pincode', Icons.pin_drop, keyboardType: TextInputType.number, maxLength: 6, required: true)),
          ],
        ),
        
        _buildStateDropdown(),
      ],
    );
  }

  Widget _buildAcademicDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('10th Standard Details'),
        const SizedBox(height: 12),
        _buildTextField('Board/University', _tenth_board, 'E.g., CBSE, State Board', Icons.school, required: true),
        Row(
          children: [
            Expanded(child: _buildTextField('Marks/Percentage', _tenth_marks, 'E.g., 85%', Icons.grade, required: true)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('Passing Year', _tenth_year, 'E.g., 2020', Icons.calendar_today, keyboardType: TextInputType.number, maxLength: 4, required: true)),
          ],
        ),
        
        const SizedBox(height: 20),
        _buildSectionTitle('12th Standard Details'),
        const SizedBox(height: 12),
        _buildTextField('Board/University', _twelfth_board, 'E.g., CBSE, State Board', Icons.school, required: true),
        Row(
          children: [
            Expanded(child: _buildTextField('Marks/Percentage', _twelfth_marks, 'E.g., 78%', Icons.grade, required: true)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('Passing Year', _twelfth_year, 'E.g., 2022', Icons.calendar_today, keyboardType: TextInputType.number, maxLength: 4, required: true)),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Upload Required Documents'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Upload clear scanned copies (PDF/JPG, max 2MB each)',
                  style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        ..._uploadedDocs.keys.map((doc) => _buildDocumentCard(doc)),
      ],
    );
  }

  Widget _buildDocumentCard(String docName) {
    bool isUploaded = _uploadedDocs[docName]!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isUploaded ? Colors.green : Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUploaded ? Colors.green.withValues(alpha: 0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isUploaded ? Icons.check_circle : Icons.upload_file,
              color: isUploaded ? Colors.green : Colors.grey[600],
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  docName,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                Text(
                  isUploaded ? 'Uploaded successfully' : 'Not uploaded yet',
                  style: TextStyle(fontSize: 11, color: isUploaded ? Colors.green : Colors.grey[600]),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() => _uploadedDocs[docName] = true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$docName uploaded'), duration: const Duration(seconds: 1)),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              side: BorderSide(color: isUploaded ? Colors.green : AppTheme.primaryBlue),
              foregroundColor: isUploaded ? Colors.green : AppTheme.primaryBlue,
            ),
            child: Text(isUploaded ? 'Change' : 'Upload', style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSubmit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Review Your Application'),
        const SizedBox(height: 16),
        
        _buildReviewCard('Student Details', [
          'Name: ${_nameController.text}',
          'Email: ${_emailController.text}',
          'Mobile: ${_mobileController.text}',
          'Gender: $_gender',
          'DOB: ${_dobController.text}',
          'Category: $_category',
        ]),
        
        _buildReviewCard('Academic Details', [
          '10th: ${_tenth_board.text} - ${_tenth_marks.text} (${_tenth_year.text})',
          '12th: ${_twelfth_board.text} - ${_twelfth_marks.text} (${_twelfth_year.text})',
        ]),
        
        _buildReviewCard('Documents', [
          ..._uploadedDocs.entries.map((e) => '${e.key}: ${e.value ? "✓ Uploaded" : "✗ Not uploaded"}'),
        ]),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Application Fee',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '₹${widget.course['total_fee']} (Pay after verification)',
                      style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(item, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          )),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey[400]!),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentStep == 3 ? Colors.green : AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(_currentStep == 3 ? 'Submit Application' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    if (_currentStep < 3) {
      if (_validateCurrentStep()) {
        setState(() => _currentStep++);
      }
    } else {
      _submitApplication();
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      if (_nameController.text.isEmpty || _emailController.text.isEmpty || _mobileController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
        return false;
      }
    }
    return true;
  }

  void _submitApplication() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'Application Submitted!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Application ID: APP${DateTime.now().millisecondsSinceEpoch}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your application has been submitted successfully. You will receive a confirmation email shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back to Courses'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.3),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, IconData icon, {
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              if (required)
                const Text(' *', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, size: 20),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.primaryBlue),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
              counterText: '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: value,
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('State', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text(' *', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedState,
            items: _indianStates.map((state) => DropdownMenuItem(value: state, child: Text(state, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: (val) => setState(() => _selectedState = val!),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_on, size: 20),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
