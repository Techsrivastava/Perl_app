import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class AdmissionApplicationScreen extends StatefulWidget {
  final Map<String, dynamic> course;

  const AdmissionApplicationScreen({super.key, required this.course});

  @override
  State<AdmissionApplicationScreen> createState() =>
      _AdmissionApplicationScreenState();
}

class _AdmissionApplicationScreenState
    extends State<AdmissionApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  
  // Fee Module State Variables
  final _actualFeeController = TextEditingController();
  final _agentCodeController = TextEditingController();
  final _expenseTitleController = TextEditingController();
  final _expenseAmountController = TextEditingController();
  
  String _admissionBy = 'Consultancy'; // Consultancy | Agent
  String _universityPaymentMode = 'Share Deduct'; // Share Deduct | Full Fee
  
  // Mock data - Replace with actual API data
  double _universityFee = 80000;
  double _displayFee = 120000;
  String _consultancyShareType = 'percent';
  double _consultancyShareValue = 15;
  
  // Agent data (populated when agent code is entered)
  String? _agentName;
  String? _agentShareType; // percent / flat
  double? _agentShareValue;
  
  // Calculated values
  double _actualProfit = 0;
  double _agentCommission = 0;
  double _agentExpensesTotal = 0;
  double _consultancyExpensesTotal = 0;
  double _agentTotalPayout = 0;
  double _finalProfit = 0;
  double _amountToUniversity = 0;
  
  // Expenses lists
  final List<Map<String, dynamic>> _agentExpenses = [];
  final List<Map<String, dynamic>> _consultancyExpenses = [];

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
    'Select State',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Delhi',
    'Jammu & Kashmir',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Apply for Admissions'),
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
                    if (_currentStep == 3) _buildFeeDetails(),
                    if (_currentStep == 4) _buildFinancialSummary(),
                    if (_currentStep == 5) _buildReviewSubmit(),
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
          _buildStepIndicator(3, 'Fee', Icons.payment),
          _buildStepLine(3),
          _buildStepIndicator(4, 'Financial', Icons.summarize),
          _buildStepLine(4),
          _buildStepIndicator(5, 'Review', Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
    int step,
    String label,
    IconData icon, {
    String? badge,
  }) {
    bool isActive = step == _currentStep;
    bool isCompleted = step < _currentStep;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green
                  : (isActive ? AppTheme.primaryBlue : Colors.grey[300]),
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
          if (badge != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primaryBlue : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 10,
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
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

        _buildTextField(
          'Full Name',
          _nameController,
          'Enter full name',
          Icons.person,
          required: true,
        ),
        _buildTextField(
          'Email Address',
          _emailController,
          'Enter email',
          Icons.email,
          keyboardType: TextInputType.emailAddress,
          required: true,
        ),
        _buildTextField(
          'Mobile Number',
          _mobileController,
          'Enter 10-digit mobile',
          Icons.phone,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          required: true,
        ),

        Row(
          children: [
            Expanded(
              child: _buildDropdown('Gender', _gender, [
                'Male',
                'Female',
                'Other',
              ], (val) => setState(() => _gender = val!)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                'Date of Birth',
                _dobController,
                'DD/MM/YYYY',
                Icons.calendar_today,
                required: true,
              ),
            ),
          ],
        ),

        _buildTextField(
          'Father\'s Name',
          _fatherNameController,
          'Enter father\'s name',
          Icons.person_outline,
          required: true,
        ),
        _buildTextField(
          'Mother\'s Name',
          _motherNameController,
          'Enter mother\'s name',
          Icons.person_outline,
          required: true,
        ),

        _buildDropdown('Category', _category, [
          'General',
          'OBC',
          'SC',
          'ST',
          'EWS',
        ], (val) => setState(() => _category = val!)),

        _buildTextField(
          'Address',
          _addressController,
          'Enter full address',
          Icons.home,
          maxLines: 3,
          required: true,
        ),

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'City',
                _cityController,
                'Enter city',
                Icons.location_city,
                required: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                'Pincode',
                _pincodeController,
                'Enter pincode',
                Icons.pin_drop,
                keyboardType: TextInputType.number,
                maxLength: 6,
                required: true,
              ),
            ),
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
        _buildTextField(
          'Board/University',
          _tenth_board,
          'E.g., CBSE, State Board',
          Icons.school,
          required: true,
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'Marks/Percentage',
                _tenth_marks,
                'E.g., 85%',
                Icons.grade,
                required: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                'Passing Year',
                _tenth_year,
                'E.g., 2020',
                Icons.calendar_today,
                keyboardType: TextInputType.number,
                maxLength: 4,
                required: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        _buildSectionTitle('12th Standard Details'),
        const SizedBox(height: 12),
        _buildTextField(
          'Board/University',
          _twelfth_board,
          'E.g., CBSE, State Board',
          Icons.school,
          required: true,
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'Marks/Percentage',
                _twelfth_marks,
                'E.g., 78%',
                Icons.grade,
                required: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                'Passing Year',
                _twelfth_year,
                'E.g., 2022',
                Icons.calendar_today,
                keyboardType: TextInputType.number,
                maxLength: 4,
                required: true,
              ),
            ),
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

  void _calculateFinancials() {
    double actualFee = double.tryParse(_actualFeeController.text) ?? 0;
    _actualProfit = actualFee - _universityFee;

    if (_admissionBy == 'Agent' && _agentShareType != null && _agentShareValue != null) {
      if (_agentShareType == 'percent') {
        _agentCommission = _actualProfit * (_agentShareValue! / 100);
      } else if (_agentShareType == 'flat') {
        _agentCommission = _agentShareValue!;
      }
    } else {
      _agentCommission = 0;
    }

    _agentExpensesTotal = _agentExpenses.fold<double>(0, (sum, e) => sum + (e['amount'] ?? 0));
    _consultancyExpensesTotal = _consultancyExpenses.fold<double>(0, (sum, e) => sum + (e['amount'] ?? 0));
    _agentTotalPayout = _agentCommission + _agentExpensesTotal;
    _finalProfit = _actualProfit - _agentCommission - _agentExpensesTotal - _consultancyExpensesTotal;

    if (_universityPaymentMode == 'Share Deduct') {
      _amountToUniversity = _universityFee;
    } else {
      _amountToUniversity = actualFee;
    }
  }

  void _fetchAgentDetails(String agentCode) {
    if (agentCode.isNotEmpty) {
      setState(() {
        _agentName = 'Agent Name for $agentCode';
        _agentShareType = 'percent';
        _agentShareValue = 25.0;
        _calculateFinancials();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Agent found: $_agentName'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildFeeDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Fee Details'),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Auto-Filled from Course Setup',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildReadOnlyRow('University Fee (Fixed)', '₹${_universityFee.toStringAsFixed(0)}'),
                _buildReadOnlyRow('Display Fee (Shown to Students)', '₹${_displayFee.toStringAsFixed(0)}'),
                _buildReadOnlyRow('Consultancy Share', '$_consultancyShareType - $_consultancyShareValue${_consultancyShareType == "percent" ? "%" : ""}'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Actual Fee Collected *',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _actualFeeController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() => _calculateFinancials()),
            decoration: InputDecoration(
              hintText: 'Enter amount collected from student',
              prefixIcon: const Icon(Icons.currency_rupee),
              suffixText: '₹',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              double? val = double.tryParse(v);
              if (val == null) return 'Enter valid amount';
              if (val < _universityFee) return 'Must be ≥ university fee (₹${_universityFee.toStringAsFixed(0)})';
              return null;
            },
          ),
          const SizedBox(height: 20),

          const Text(
            'Admission Source *',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'Consultancy',
                label: Text('Consultancy'),
                icon: Icon(Icons.business),
              ),
              ButtonSegment(
                value: 'Agent',
                label: Text('Agent'),
                icon: Icon(Icons.person),
              ),
            ],
            selected: {_admissionBy},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _admissionBy = newSelection.first;
                if (_admissionBy == 'Consultancy') {
                  _agentCodeController.clear();
                  _agentName = null;
                  _agentShareType = null;
                  _agentShareValue = null;
                }
                _calculateFinancials();
              });
            },
          ),
          const SizedBox(height: 20),

          if (_admissionBy == 'Agent') ..._buildAgentModule(),

          const Divider(height: 32),
          ..._buildExpensesModule(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildReadOnlyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 1,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAgentModule() {
    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Agent Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _agentCodeController,
              decoration: InputDecoration(
                labelText: 'Agent Code *',
                hintText: 'Enter agent code and click search',
                helperText: '👉 Click search button to fetch agent details',
                helperStyle: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: const Icon(Icons.badge),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      if (_agentCodeController.text.isNotEmpty) {
                        _fetchAgentDetails(_agentCodeController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter agent code first')),
                        );
                      }
                    },
                    tooltip: 'Search Agent',
                  ),
                ),
              ),
            ),
            
            if (_agentName == null && _agentCodeController.text.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Click the search button (🔍) to fetch agent details and view profit',
                        style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              ),
            
            if (_agentName != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReadOnlyRow('Agent Name', _agentName!),
                    _buildReadOnlyRow('Share Type', _agentShareType ?? ''),
                    _buildReadOnlyRow(
                      'Share Value',
                      _agentShareType == 'percent'
                          ? '${_agentShareValue}%'
                          : '₹${_agentShareValue?.toStringAsFixed(0)}',
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '💰 Agent Profit',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Commission Earned',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            flex: 1,
                            child: Text(
                              '₹${_agentCommission.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.green,
                              ),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      const SizedBox(height: 20),
      
      const Text(
        'Agent Expenses',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      _buildExpenseInput(isAgent: true),
      if (_agentExpenses.isNotEmpty) ..._buildExpenseList(_agentExpenses, true),
      
      if (_agentCommission > 0)
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.orange, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📦 Total Payable to Agent',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Profit + Expenses',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 1,
                child: Text(
                  '₹${_agentTotalPayout.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      const SizedBox(height: 20),
    ];
  }

  List<Widget> _buildExpensesModule() {
    return [
      const Text(
        'Consultancy Expenses',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      _buildExpenseInput(isAgent: false),
      if (_consultancyExpenses.isNotEmpty) ..._buildExpenseList(_consultancyExpenses, false),
    ];
  }

  Widget _buildExpenseInput({required bool isAgent}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: _expenseTitleController,
            decoration: InputDecoration(
              hintText: 'Title (e.g., Travel)',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _expenseAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Amount',
              prefixText: '₹',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            if (_expenseTitleController.text.isNotEmpty &&
                _expenseAmountController.text.isNotEmpty) {
              setState(() {
                final expense = {
                  'title': _expenseTitleController.text,
                  'amount': double.tryParse(_expenseAmountController.text) ?? 0,
                };
                if (isAgent) {
                  _agentExpenses.add(expense);
                } else {
                  _consultancyExpenses.add(expense);
                }
                _expenseTitleController.clear();
                _expenseAmountController.clear();
                _calculateFinancials();
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Icon(Icons.add, size: 20),
        ),
      ],
    );
  }

  List<Widget> _buildExpenseList(List<Map<String, dynamic>> expenses, bool isAgent) {
    return [
      const SizedBox(height: 8),
      ...expenses.asMap().entries.map((entry) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isAgent
                ? Colors.orange.withValues(alpha: 0.05)
                : Colors.purple.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isAgent
                  ? Colors.orange.withValues(alpha: 0.3)
                  : Colors.purple.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  entry.value['title'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '₹${entry.value['amount'].toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isAgent ? Colors.orange : Colors.purple,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                onPressed: () {
                  setState(() {
                    if (isAgent) {
                      _agentExpenses.removeAt(entry.key);
                    } else {
                      _consultancyExpenses.removeAt(entry.key);
                    }
                    _calculateFinancials();
                  });
                },
              ),
            ],
          ),
        );
      }),
      if (expenses.isNotEmpty)
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isAgent
                ? Colors.orange.withValues(alpha: 0.1)
                : Colors.purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  'Total ${isAgent ? "Agent" : "Consultancy"} Expenses:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 1,
                child: Text(
                  '₹${(isAgent ? _agentExpensesTotal : _consultancyExpensesTotal).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isAgent ? Colors.orange : Colors.purple,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
    ];
  }

  Widget _buildDocumentCard(String docName) {
    bool isUploaded = _uploadedDocs[docName]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUploaded ? Colors.green : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUploaded
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.grey[100],
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
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  isUploaded ? 'Uploaded successfully' : 'Not uploaded yet',
                  style: TextStyle(
                    fontSize: 11,
                    color: isUploaded ? Colors.green : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() => _uploadedDocs[docName] = true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$docName uploaded'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              side: BorderSide(
                color: isUploaded ? Colors.green : AppTheme.primaryBlue,
              ),
              foregroundColor: isUploaded ? Colors.green : AppTheme.primaryBlue,
            ),
            child: Text(
              isUploaded ? 'Change' : 'Upload',
              style: const TextStyle(fontSize: 12),
            ),
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
          ..._uploadedDocs.entries.map(
            (e) => '${e.key}: ${e.value ? "✓ Uploaded" : "✗ Not uploaded"}',
          ),
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                item,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ),
          ),
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
                backgroundColor: _currentStep == 5
                    ? Colors.green
                    : AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(_currentStep == 5 ? 'Apply For Admission' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Financial Summary'),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admission Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 12),
                _singleRow('Admission By', _admissionBy),
                _singleRow('Actual Fee Collected', '₹${_actualProfit + _universityFee}'),
                _singleRow('University Fee', '₹${_universityFee.toStringAsFixed(0)}'),
                const Divider(height: 16),
                _singleRow(
                  'Actual Profit',
                  '₹${_actualProfit.toStringAsFixed(0)}',
                  valueStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_admissionBy == 'Agent' && _agentName != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Agent Summary',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _singleRow('Agent Code', _agentCodeController.text),
                  _singleRow('Agent Name', _agentName ?? ''),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Agent Profit/Commission',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${_agentCommission.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _singleRow('Agent Expenses', '₹${_agentExpensesTotal.toStringAsFixed(0)}'),
                  const Divider(height: 16),
                  _singleRow(
                    'Total Payable to Agent',
                    '₹${_agentTotalPayout.toStringAsFixed(0)}',
                    valueStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '(Commission + Expenses)',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expenses Summary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 12),
                if (_admissionBy == 'Agent')
                  _singleRow('Agent Expenses Total', '₹${_agentExpensesTotal.toStringAsFixed(0)}'),
                _singleRow('Consultancy Expenses Total', '₹${_consultancyExpensesTotal.toStringAsFixed(0)}'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withValues(alpha: 0.1),
                  Colors.green.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Final Consultancy Net Profit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'After all deductions',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 1,
                  child: Text(
                    '₹${_finalProfit.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'University Payment Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 12),
                _singleRow('Payment Mode', _universityPaymentMode),
                _singleRow(
                  'Amount to University',
                  '₹${_amountToUniversity.toStringAsFixed(0)}',
                  valueStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _universityPaymentMode == 'Share Deduct'
                        ? 'You pay university fee only. Keep the profit.'
                        : 'You pay full amount. University returns share later.',
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.receipt_long, color: Colors.grey[700], size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Ledger Creation',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'On submission, following ledgers will be created:',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                _buildLedgerInfo('Consultancy Ledger', 'Profit tracking', Icons.business),
                _buildLedgerInfo('University Ledger', 'Payment tracking', Icons.school),
                if (_admissionBy == 'Agent')
                  _buildLedgerInfo('Agent Ledger', 'Commission & payout', Icons.person),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLedgerInfo(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _singleRow(String label, String value, {TextStyle? valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 1,
          child: Text(
            value,
            style: valueStyle ?? const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _handleNext() {
    if (_currentStep < 5) {
      if (_validateCurrentStep()) {
        setState(() => _currentStep++);
      }
    } else {
      _submitApplication();
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _mobileController.text.isEmpty) {
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
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
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
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
    IconData icon, {
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
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              isDense: true,
              counterText: '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
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
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 13)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
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
              Text(
                'State',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              Text(' *', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedState,
            items: _indianStates
                .map(
                  (state) => DropdownMenuItem(
                    value: state,
                    child: Text(state, style: const TextStyle(fontSize: 13)),
                  ),
                )
                .toList(),
            onChanged: (val) => setState(() => _selectedState = val!),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_on, size: 20),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
