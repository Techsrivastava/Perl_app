import 'dart:io';
import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class ComprehensiveConsultantRegisterScreen extends StatefulWidget {
  const ComprehensiveConsultantRegisterScreen({super.key});

  @override
  State<ComprehensiveConsultantRegisterScreen> createState() => _ComprehensiveConsultantRegisterScreenState();
}

class _ComprehensiveConsultantRegisterScreenState extends State<ComprehensiveConsultantRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  
  // Step 1: Basic Information
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _altContactController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  String _selectedState = 'Uttarakhand';
  final _pincodeController = TextEditingController();
  File? _profilePhoto;
  bool _passwordVisible = false;
  
  // Step 2: Business Details
  final _businessNameController = TextEditingController();
  String _registrationType = 'Individual';
  final _registrationNoController = TextEditingController();
  File? _registrationProof;
  File? _consultancyLogo;
  String _consultancyType = 'Admission';
  final _establishedYearController = TextEditingController();
  final _officeAddressController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Step 3: Bank Details (Optional)
  final _accountHolderController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchController = TextEditingController();
  final _ifscController = TextEditingController();
  final _upiController = TextEditingController();
  File? _qrCode;
  final _panController = TextEditingController();
  File? _cancelledCheque;
  
  // Step 4: Documents (Optional)
  final _aadharNumberController = TextEditingController();
  File? _aadharFront;
  File? _aadharBack;
  final _panNumberController = TextEditingController();
  File? _panCard;
  File? _gstCertificate;
  
  final List<String> _indianStates = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka',
    'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram',
    'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu',
    'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
    'Delhi', 'Jammu and Kashmir', 'Ladakh'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _altContactController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _businessNameController.dispose();
    _registrationNoController.dispose();
    _establishedYearController.dispose();
    _officeAddressController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _branchController.dispose();
    _ifscController.dispose();
    _upiController.dispose();
    _panController.dispose();
    _aadharNumberController.dispose();
    _panNumberController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_validateCurrentStep()) {
      if (_currentStep < 3) {
        setState(() => _currentStep++);
      } else {
        _handleSubmit();
      }
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      // Basic Info validation
      if (_nameController.text.isEmpty ||
          _contactController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _cityController.text.isEmpty) {
        _showSnackBar('Please fill all required fields', isError: true);
        return false;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        _showSnackBar('Passwords do not match', isError: true);
        return false;
      }
      if (_contactController.text.length != 10) {
        _showSnackBar('Mobile number must be 10 digits', isError: true);
        return false;
      }
      return true;
    } else if (_currentStep == 1) {
      // Business Details validation
      if (_businessNameController.text.isEmpty) {
        _showSnackBar('Business name is required', isError: true);
        return false;
      }
      return true;
    }
    return true; // Steps 2 and 3 are optional
  }

  void _handleSubmit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Registration Successful!'),
        content: const Text('Your consultant account has been created. You will be redirected to complete your profile.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/consultant-profile-setup');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
            child: const Text('Continue', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Register as Consultant'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress Indicator with Radio Buttons
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: List.generate(4, (index) {
                  final isCompleted = index < _currentStep;
                  final isCurrent = index == _currentStep;
                  final isUpcoming = index > _currentStep;
                  
                  return Expanded(
                    child: Row(
                      children: [
                        // Radio Button Style Indicator
                        Expanded(
                          child: Column(
                            children: [
                              // Circle with number or check
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCompleted 
                                      ? AppTheme.success 
                                      : isCurrent 
                                          ? AppTheme.primaryBlue 
                                          : Colors.grey[300],
                                  boxShadow: isCurrent ? [
                                    BoxShadow(
                                      color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ] : [],
                                ),
                                child: Center(
                                  child: isCompleted
                                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                                      : Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: isUpcoming ? Colors.grey[600] : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Step label
                              Text(
                                _getStepLabel(index),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                                  color: isCompleted || isCurrent ? AppTheme.primaryBlue : Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                        // Connecting line (except for last item)
                        if (index < 3)
                          Expanded(
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.only(bottom: 32),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isCompleted
                                      ? [AppTheme.success, AppTheme.success]
                                      : [Colors.grey[300]!, Colors.grey[300]!],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            
            // Step Title
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Text(
                    'Step ${_currentStep + 1} of 4',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStepTitle(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (_currentStep > 1)
                    const Spacer(),
                  if (_currentStep > 1)
                    Text(
                      '(Optional)',
                      style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                    ),
                ],
              ),
            ),
            
            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildStepContent(),
              ),
            ),
            
            // Navigation Buttons
            Container(
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
                        backgroundColor: _currentStep == 3 ? AppTheme.success : AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(_currentStep == 3 ? 'Complete Registration' : 'Next'),
                    ),
                  ),
                  if (_currentStep > 1)
                    const SizedBox(width: 12),
                  if (_currentStep > 1)
                    TextButton(
                      onPressed: () => setState(() => _currentStep++),
                      child: const Text('Skip'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Basic Information';
      case 1:
        return 'Business Details';
      case 2:
        return 'Bank & Payment';
      case 3:
        return 'Documents & KYC';
      default:
        return '';
    }
  }

  String _getStepLabel(int index) {
    switch (index) {
      case 0:
        return 'Basic Info';
      case 1:
        return 'Business';
      case 2:
        return 'Bank';
      case 3:
        return 'Documents';
      default:
        return '';
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildBusinessStep();
      case 2:
        return _buildBankStep();
      case 3:
        return _buildDocumentsStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Personal & Contact Details', 'Fill your basic information'),
        const SizedBox(height: 16),
        
        _buildTextField('Full Name *', _nameController, Icons.person),
        const SizedBox(height: 16),
        _buildTextField('Email Address *', _emailController, Icons.email, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        _buildTextField('Mobile Number *', _contactController, Icons.phone, keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField('Alternate Contact', _altContactController, Icons.phone_android, keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField('WhatsApp Number', _whatsappController, Icons.chat, keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField('Password *', _passwordController, Icons.lock, isPassword: true),
        const SizedBox(height: 16),
        _buildTextField('Confirm Password *', _confirmPasswordController, Icons.lock_clock, isPassword: true),
        const SizedBox(height: 16),
        _buildTextField('Address', _addressController, Icons.location_on, maxLines: 2),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('City *', _cityController, Icons.location_city)),
            const SizedBox(width: 12),
            Expanded(child: _buildDropdown('State *', _selectedState, _indianStates, (v) => setState(() => _selectedState = v!))),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Pincode', _pincodeController, Icons.pin_drop, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildFileUpload('Profile Photo', _profilePhoto, (file) => setState(() => _profilePhoto = file)),
      ],
    );
  }

  Widget _buildBusinessStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Business / Consultancy Information', 'Provide your business details'),
        const SizedBox(height: 16),
        
        _buildTextField('Business / Consultancy Name *', _businessNameController, Icons.business),
        const SizedBox(height: 16),
        _buildDropdown(
          'Registration Type *',
          _registrationType,
          ['Individual', 'Proprietorship', 'LLP', 'Pvt. Ltd.', 'NGO', 'Trust'],
          (v) => setState(() => _registrationType = v!),
        ),
        const SizedBox(height: 16),
        _buildTextField('Registration / GST / CIN Number', _registrationNoController, Icons.confirmation_number),
        const SizedBox(height: 16),
        _buildFileUpload('Registration Proof', _registrationProof, (file) => setState(() => _registrationProof = file)),
        const SizedBox(height: 16),
        _buildFileUpload('Consultancy Logo', _consultancyLogo, (file) => setState(() => _consultancyLogo = file)),
        const SizedBox(height: 16),
        _buildDropdown(
          'Consultancy Type *',
          _consultancyType,
          ['Admission', 'Education', 'Training', 'Abroad Study', 'Mixed'],
          (v) => setState(() => _consultancyType = v!),
        ),
        const SizedBox(height: 16),
        _buildTextField('Establishment Year', _establishedYearController, Icons.calendar_today, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField('Office Address', _officeAddressController, Icons.location_on, maxLines: 2),
        const SizedBox(height: 16),
        _buildTextField('Website / Social Links', _websiteController, Icons.link),
        const SizedBox(height: 16),
        _buildTextField('Consultancy Description', _descriptionController, Icons.description, maxLines: 4, hint: 'Max 250 words'),
      ],
    );
  }

  Widget _buildBankStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Bank & Payment Details', 'For commission transfer (can be added later)'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bank details can be added later from your profile',
                  style: TextStyle(fontSize: 12, color: Colors.orange[900]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        _buildTextField('Account Holder Name', _accountHolderController, Icons.person),
        const SizedBox(height: 16),
        _buildTextField('Account Number', _accountNumberController, Icons.account_balance_wallet, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField('Bank Name', _bankNameController, Icons.account_balance),
        const SizedBox(height: 16),
        _buildTextField('Branch Name', _branchController, Icons.location_city),
        const SizedBox(height: 16),
        _buildTextField('IFSC Code', _ifscController, Icons.code),
        const SizedBox(height: 16),
        _buildTextField('UPI ID', _upiController, Icons.payment),
        const SizedBox(height: 16),
        _buildFileUpload('QR Code (UPI/Paytm)', _qrCode, (file) => setState(() => _qrCode = file)),
        const SizedBox(height: 16),
        _buildTextField('PAN Number', _panController, Icons.credit_card),
        const SizedBox(height: 16),
        _buildFileUpload('Cancelled Cheque', _cancelledCheque, (file) => setState(() => _cancelledCheque = file)),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Documents & KYC Verification', 'Upload verification documents (can be added later)'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.verified_user, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Documents can be uploaded later from your profile',
                  style: TextStyle(fontSize: 12, color: Colors.blue[900]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        _buildTextField('Aadhar Card Number', _aadharNumberController, Icons.credit_card, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildFileUpload('Aadhar Front', _aadharFront, (file) => setState(() => _aadharFront = file))),
            const SizedBox(width: 12),
            Expanded(child: _buildFileUpload('Aadhar Back', _aadharBack, (file) => setState(() => _aadharBack = file))),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('PAN Card Number', _panNumberController, Icons.credit_card),
        const SizedBox(height: 16),
        _buildFileUpload('PAN Card', _panCard, (file) => setState(() => _panCard = file)),
        const SizedBox(height: 16),
        _buildFileUpload('GST Certificate', _gstCertificate, (file) => setState(() => _gstCertificate = file)),
      ],
    );
  }

  Widget _buildInfoCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryBlue.withValues(alpha: 0.1), AppTheme.primaryBlue.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {
    bool isPassword = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_passwordVisible,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildFileUpload(String label, File? file, Function(File?) onFilePicked) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File picker for $label')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: file != null ? AppTheme.success.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: file != null ? AppTheme.success : Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(
              file != null ? Icons.check_circle : Icons.upload_file,
              color: file != null ? AppTheme.success : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                file != null ? '✓ Uploaded' : label,
                style: TextStyle(
                  fontSize: 13,
                  color: file != null ? AppTheme.success : Colors.grey[700],
                  fontWeight: file != null ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }
}
