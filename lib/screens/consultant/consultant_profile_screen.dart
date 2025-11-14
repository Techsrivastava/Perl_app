import 'dart:io';
import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class ConsultantProfileScreen extends StatefulWidget {
  const ConsultantProfileScreen({super.key});

  @override
  State<ConsultantProfileScreen> createState() =>
      _ConsultantProfileScreenState();
}

class _ConsultantProfileScreenState extends State<ConsultantProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Basic Information
  final _consultantId = 'CONS2001';
  final _nameController = TextEditingController(text: 'Rajesh Kumar');
  final _contactController = TextEditingController(text: '9876543210');
  final _altContactController = TextEditingController();
  final _emailController = TextEditingController(
    text: 'rajesh@consultancy.com',
  );
  final _whatsappController = TextEditingController(text: '9876543210');
  final _addressController = TextEditingController();
  final _cityController = TextEditingController(text: 'Dehradun');
  String _selectedState = 'Uttarakhand';
  final _pincodeController = TextEditingController();
  File? _profilePhoto;

  // Business Details
  final _businessNameController = TextEditingController(
    text: 'Rajesh Consultancy',
  );
  String _registrationType = 'Individual';
  final _registrationNoController = TextEditingController();
  File? _registrationProof;
  File? _consultancyLogo;
  String _consultancyType = 'Admission';
  final _establishedYearController = TextEditingController();
  final _officeAddressController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Bank Details
  final _accountHolderController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchController = TextEditingController();
  final _ifscController = TextEditingController();
  final _upiController = TextEditingController();
  File? _qrCode;
  final _panController = TextEditingController();
  File? _cancelledCheque;

  // Documents
  final _aadharNumberController = TextEditingController();
  File? _aadharFront;
  File? _aadharBack;
  final _panNumberController = TextEditingController();
  File? _panCard;
  File? _gstCertificate;
  File? _consultantAgreement;
  String _verificationStatus = 'Pending';

  // Settings
  bool _twoFactorAuth = false;
  bool _appNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  String _language = 'English';
  bool _darkMode = false;

  final List<String> _indianStates = [
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
    'Jammu and Kashmir',
    'Ladakh',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _altContactController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
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

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Profile updated successfully!'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  void _handleSubmitForVerification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit for Verification'),
        content: const Text(
          'Are you sure you want to submit your profile for admin verification?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Profile submitted for verification!'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
            ),
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/consultant-dashboard');
            },
            icon: const Icon(Icons.skip_next, color: Colors.white, size: 20),
            label: const Text(
              'Skip for now',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _handleSave,
            tooltip: 'Save Profile',
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
              // Verification Status Banner
              _buildStatusBanner(),
              const SizedBox(height: 16),

              // Section 1: Basic Information
              _buildSectionCard(
                title: '1️⃣ Basic Information',
                icon: Icons.person,
                children: [
                  _buildReadOnlyField('Consultant ID', _consultantId),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Consultant / Owner Name *',
                    _nameController,
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Contact Number *',
                    _contactController,
                    Icons.phone,
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Alternate Contact No.',
                    _altContactController,
                    Icons.phone_android,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Email Address *',
                    _emailController,
                    Icons.email,
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'WhatsApp Number',
                    _whatsappController,
                    Icons.chat,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Address',
                    _addressController,
                    Icons.location_on,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          'City *',
                          _cityController,
                          Icons.location_city,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          'State *',
                          _selectedState,
                          _indianStates,
                          (v) => setState(() => _selectedState = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Pincode',
                    _pincodeController,
                    Icons.pin_drop,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildFileUpload(
                    'Profile Photo',
                    _profilePhoto,
                    (file) => setState(() => _profilePhoto = file),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Section 2: Business Details
              _buildSectionCard(
                title: '2️⃣ Business / Consultancy Details',
                icon: Icons.business,
                children: [
                  _buildTextField(
                    'Business / Consultancy Name *',
                    _businessNameController,
                    Icons.business_center,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    'Registration Type *',
                    _registrationType,
                    [
                      'Individual',
                      'Proprietorship',
                      'LLP',
                      'Pvt. Ltd.',
                      'NGO',
                      'Trust',
                    ],
                    (v) => setState(() => _registrationType = v!),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Registration / GST / CIN Number',
                    _registrationNoController,
                    Icons.confirmation_number,
                  ),
                  const SizedBox(height: 16),
                  _buildFileUpload(
                    'Upload Registration Proof',
                    _registrationProof,
                    (file) => setState(() => _registrationProof = file),
                  ),
                  const SizedBox(height: 16),
                  _buildFileUpload(
                    'Consultancy Logo',
                    _consultancyLogo,
                    (file) => setState(() => _consultancyLogo = file),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    'Consultancy Type *',
                    _consultancyType,
                    [
                      'Admission',
                      'Education',
                      'Training',
                      'Abroad Study',
                      'Mixed',
                    ],
                    (v) => setState(() => _consultancyType = v!),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Establishment Year',
                    _establishedYearController,
                    Icons.calendar_today,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Office Address',
                    _officeAddressController,
                    Icons.location_on,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Website / Social Links',
                    _websiteController,
                    Icons.link,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Consultancy Description',
                    _descriptionController,
                    Icons.description,
                    maxLines: 4,
                    hint: 'Max 250 words',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Section 3: Bank & Payment Details
              _buildSectionCard(
                title: '3️⃣ Bank & Payment Details',
                icon: Icons.account_balance,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Bank details must be verified by Admin before commission transfer',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Account Holder Name *',
                    _accountHolderController,
                    Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Account Number *',
                    _accountNumberController,
                    Icons.account_balance_wallet,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Bank Name *',
                    _bankNameController,
                    Icons.account_balance,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Branch Name',
                    _branchController,
                    Icons.location_city,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('IFSC Code *', _ifscController, Icons.code),
                  const SizedBox(height: 16),
                  _buildTextField('UPI ID', _upiController, Icons.payment),
                  const SizedBox(height: 16),
                  _buildFileUpload(
                    'Upload QR Code (UPI/Paytm/GPay)',
                    _qrCode,
                    (file) => setState(() => _qrCode = file),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'PAN Number',
                    _panController,
                    Icons.credit_card,
                  ),
                  const SizedBox(height: 16),
                  _buildFileUpload(
                    'Upload Cancelled Cheque',
                    _cancelledCheque,
                    (file) => setState(() => _cancelledCheque = file),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Section 4: Documents & Verification
              _buildSectionCard(
                title: '4️⃣ Documents & Verification',
                icon: Icons.verified_user,
                children: [
                  _buildTextField(
                    'Aadhar Card Number',
                    _aadharNumberController,
                    Icons.credit_card,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFileUpload(
                          'Aadhar Front',
                          _aadharFront,
                          (file) => setState(() => _aadharFront = file),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFileUpload(
                          'Aadhar Back',
                          _aadharBack,
                          (file) => setState(() => _aadharBack = file),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'PAN Card Number',
                    _panNumberController,
                    Icons.credit_card,
                  ),
                  const SizedBox(height: 16),
                  _buildFileUpload(
                    'Upload PAN Card',
                    _panCard,
                    (file) => setState(() => _panCard = file),
                  ),
                  const SizedBox(height: 16),
                  _buildFileUpload(
                    'Business Registration Proof',
                    _registrationProof,
                    (file) => setState(() => _registrationProof = file),
                  ),
                  const SizedBox(height: 16),
                  _buildFileUpload(
                    'Upload GST Certificate (if applicable)',
                    _gstCertificate,
                    (file) => setState(() => _gstCertificate = file),
                  ),
                  const SizedBox(height: 16),
                  _buildFileUpload(
                    'Consultant Agreement (MOU)',
                    _consultantAgreement,
                    (file) => setState(() => _consultantAgreement = file),
                  ),
                  const SizedBox(height: 16),
                  _buildReadOnlyField(
                    'Verification Status',
                    _verificationStatus,
                    color: _verificationStatus == 'Verified'
                        ? Colors.green
                        : Colors.orange,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Section 5: Account Settings
              _buildSectionCard(
                title: '5️⃣ Account Settings',
                icon: Icons.settings,
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Enable Two-Factor Authentication',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Adds login security',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: _twoFactorAuth,
                    onChanged: (v) => setState(() => _twoFactorAuth = v),
                    activeColor: AppTheme.primaryBlue,
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Notification Preferences',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text(
                      'App Notifications',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: _appNotifications,
                    onChanged: (v) => setState(() => _appNotifications = v!),
                    activeColor: AppTheme.primaryBlue,
                  ),
                  CheckboxListTile(
                    title: const Text(
                      'Email Notifications',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: _emailNotifications,
                    onChanged: (v) => setState(() => _emailNotifications = v!),
                    activeColor: AppTheme.primaryBlue,
                  ),
                  CheckboxListTile(
                    title: const Text(
                      'SMS Notifications',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: _smsNotifications,
                    onChanged: (v) => setState(() => _smsNotifications = v!),
                    activeColor: AppTheme.primaryBlue,
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Language Preference',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: DropdownButton<String>(
                      value: _language,
                      items: ['English', 'Hindi'].map((lang) {
                        return DropdownMenuItem(value: lang, child: Text(lang));
                      }).toList(),
                      onChanged: (v) => setState(() => _language = v!),
                    ),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text(
                      'Dark Mode',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: _darkMode,
                    onChanged: (v) => setState(() => _darkMode = v),
                    activeColor: AppTheme.primaryBlue,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.download,
                      color: AppTheme.primaryBlue,
                    ),
                    title: const Text(
                      'Export Profile Data',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Downloading profile data as PDF...'),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.lock,
                      color: AppTheme.primaryBlue,
                    ),
                    title: const Text(
                      'Change Password',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to change password screen
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.block, color: Colors.red),
                    title: const Text(
                      'Deactivate Account',
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Deactivate Account'),
                          content: const Text(
                            'Are you sure you want to request account deactivation?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Deactivation request sent to admin',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Request Deactivation',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _handleSave,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Changes'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppTheme.primaryBlue),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleSubmitForVerification,
                      icon: const Icon(Icons.send),
                      label: const Text('Submit for Verification'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    Color bgColor;
    Color textColor;
    IconData icon;
    String message;

    switch (_verificationStatus) {
      case 'Verified':
        bgColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        icon = Icons.verified;
        message = 'Your profile is verified and active';
        break;
      case 'Rejected':
        bgColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        icon = Icons.cancel;
        message =
            'Your profile verification was rejected. Please update and resubmit';
        break;
      default:
        bgColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        icon = Icons.pending;
        message = 'Your profile is pending verification';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verification Status: $_verificationStatus',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(message, style: TextStyle(fontSize: 12, color: textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool readOnly = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: readOnly,
        fillColor: readOnly ? Colors.grey[100] : null,
      ),
      validator: label.contains('*')
          ? (v) => v!.isEmpty ? 'Required' : null
          : null,
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildFileUpload(
    String label,
    File? file,
    Function(File?) onFilePicked,
  ) {
    return InkWell(
      onTap: () {
        // Simulate file picker
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('File picker for $label')));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: file != null
              ? AppTheme.success.withValues(alpha: 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: file != null ? AppTheme.success : Colors.grey[300]!,
          ),
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
                  fontWeight: file != null
                      ? FontWeight.w600
                      : FontWeight.normal,
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
