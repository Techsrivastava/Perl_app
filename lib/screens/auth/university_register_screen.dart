import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/widgets/custom_button.dart';
import 'package:university_app_2/widgets/custom_text_field.dart';

class UniversityRegisterScreen extends StatefulWidget {
  const UniversityRegisterScreen({super.key});

  @override
  State<UniversityRegisterScreen> createState() =>
      _UniversityRegisterScreenState();
}

class _UniversityRegisterScreenState extends State<UniversityRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  // Basic Information Controllers
  final _nameController = TextEditingController();
  final _abbreviationController = TextEditingController();
  final _establishedYearController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Contact Information Controllers
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();
  final _pincodeController = TextEditingController();

  // Authorize Person Controllers
  final _authorizePersonNameController = TextEditingController();
  final _firmNameController = TextEditingController();
  final _authorizePersonDetailsController = TextEditingController();
  final _authorizePersonPhoneController = TextEditingController();
  final _authorizePersonEmailController = TextEditingController();

  // Bank Details Controllers
  final _bankNameController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  final _branchController = TextEditingController();
  final _upiIdController = TextEditingController();
  File? _qrCodeFile;
  File? _logoFile;
  File? _backgroundImageFile;
  File? _accreditationCertFile;
  File? _authorizedPersonPhotoFile;

  // Contact - Social Media & Maps
  final _googleMapsLinkController = TextEditingController();
  final _facebookLinkController = TextEditingController();
  final _twitterLinkController = TextEditingController();
  final _linkedinLinkController = TextEditingController();
  final _instagramLinkController = TextEditingController();

  // Custom Test Option
  bool _hasCustomTest = false;
  final _customTestNameController = TextEditingController();
  final _customTestDescriptionController = TextEditingController();

  // Declaration
  bool _acceptDeclaration = false;

  String _registrationType =
      'University'; // University, College, Institute, Consultancy, Consultant
  String _selectedType = 'Government';
  String _selectedState = 'Delhi';
  String _selectedCity = '';
  List<String> _selectedFacilities = [];
  List<String> _selectedAccreditations = [];

  final List<String> _registrationTypeOptions = [
    'University',
    'College',
    'Institute',
  ];

  // Company/Agency registration types
  final List<String> _companyRegistrationTypes = [
    'Pvt. Ltd.',
    'LLP',
    'Proprietorship',
    'NGO',
    'Trust',
  ];

  // Authorization Type: 'individual' or 'firm'
  String _authorizationType = 'individual';

  // Company/Agency Tie-Up Details
  bool _operatedViaAgency = false;
  final _companyNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _companyContactController = TextEditingController();
  final _authorizedCompanyPersonController = TextEditingController();
  final _authorizedPersonDesignationController = TextEditingController();
  final _authorizedPersonContactController = TextEditingController();
  final _remarksController = TextEditingController();
  String? _companyRegistrationType;
  DateTime? _agreementFromDate;
  DateTime? _agreementToDate;
  File? _companyRegistrationCertFile;
  File? _companyPanGstFile;
  File? _mouAgreementFile;
  File? _authPersonIdFile;

  // Additional Authorized Person fields
  final _alternateEmailController = TextEditingController();
  final _alternateContactController = TextEditingController();
  final _departmentNameController = TextEditingController();
  final _officeLandlineController = TextEditingController();
  final _authRemarksController = TextEditingController();
  String? _idProofType;
  DateTime? _authValidityFromDate;
  DateTime? _authValidityToDate;
  File? _idProofFile;
  File? _authorizationLetterFile;
  File? _digitalSignatureFile;

  // ID Proof types
  final List<String> _idProofTypes = [
    'Aadhaar',
    'PAN',
    'Passport',
    'University ID',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _abbreviationController.dispose();
    _establishedYearController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _pincodeController.dispose();
    _authorizePersonNameController.dispose();
    _firmNameController.dispose();
    _authorizePersonDetailsController.dispose();
    _authorizePersonPhoneController.dispose();
    _authorizePersonEmailController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _branchController.dispose();
    _upiIdController.dispose();
    _accountHolderNameController.dispose();
    _googleMapsLinkController.dispose();
    _facebookLinkController.dispose();
    _twitterLinkController.dispose();
    _linkedinLinkController.dispose();
    _instagramLinkController.dispose();
    _customTestNameController.dispose();
    _customTestDescriptionController.dispose();
    _companyNameController.dispose();
    _registrationNumberController.dispose();
    _companyAddressController.dispose();
    _companyEmailController.dispose();
    _companyContactController.dispose();
    _authorizedCompanyPersonController.dispose();
    _authorizedPersonDesignationController.dispose();
    _authorizedPersonContactController.dispose();
    _remarksController.dispose();
    _alternateEmailController.dispose();
    _alternateContactController.dispose();
    _departmentNameController.dispose();
    _officeLandlineController.dispose();
    _authRemarksController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      // 4 pages total (0-3)
      _pageController.nextPage(
        duration: AppConstants.mediumAnimation,
        curve: Curves.easeInOut,
      );
    }
  }

  // File picker methods
  Future<void> _pickCompanyRegistrationCert() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(() {
          _companyRegistrationCertFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  Future<void> _pickCompanyPanGst() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(() {
          _companyPanGstFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  Future<void> _pickMouAgreement() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        setState(() {
          _mouAgreementFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  Future<void> _pickAuthPersonId() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(() {
          _authPersonIdFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  Future<void> _pickIdProof() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(() {
          _idProofFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking ID proof: $e');
    }
  }

  Future<void> _pickAuthorizationLetter() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(() {
          _authorizationLetterFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking authorization letter: $e');
    }
  }

  Future<void> _pickDigitalSignature() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(() {
          _digitalSignatureFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking digital signature: $e');
    }
  }

  Future<void> _pickQRCode() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(() {
          _qrCodeFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking QR code: $e');
    }
  }

  Future<void> _pickLogo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'svg'],
      );
      if (result != null) {
        setState(() {
          _logoFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking logo: $e');
    }
  }

  Future<void> _pickBackgroundImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(() {
          _backgroundImageFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking background image: $e');
    }
  }

  Future<void> _pickAccreditationCert() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(() {
          _accreditationCertFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking accreditation certificate: $e');
    }
  }

  Future<void> _pickAuthorizedPersonPhoto() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(() {
          _authorizedPersonPhotoFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking authorized person photo: $e');
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: AppConstants.mediumAnimation,
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registration Successful'),
            content: const Text(
              'Your university registration has been submitted for approval.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text('University Registration EDit'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              color: AppTheme.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepIndicator(0, 'Basic'),
                  Expanded(child: _buildStepLine(0)),
                  _buildStepIndicator(1, 'Contact'),
                  Expanded(child: _buildStepLine(1)),
                  _buildStepIndicator(2, 'Auth'),
                  Expanded(child: _buildStepLine(2)),
                  _buildStepIndicator(3, 'Bank'),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildBasicInfoPage(),
                  _buildContactInfoPage(),
                  _buildAuthorizedPersonPage(),
                  _buildBankDetailsPage(),
                ],
              ),
            ),

            // Navigation Buttons
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: CustomButton(
                          label: 'Previous',
                          onPressed: _previousPage,
                          variant: ButtonVariant.secondary,
                          isFullWidth: true,
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        label: _currentPage == 3 ? 'Submit' : 'Next',
                        onPressed: _currentPage == 3
                            ? _handleSubmit
                            : _nextPage,
                        isLoading: _isLoading,
                        isFullWidth: true,
                        icon: _currentPage == 3
                            ? Icons.check
                            : Icons.arrow_forward,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentPage >= step;
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryBlue : AppTheme.lightGray,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? AppTheme.primaryBlue : AppTheme.mediumGray,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${step + 1}',
                style: TextStyle(
                  color: isActive ? AppTheme.white : AppTheme.mediumGray,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isActive ? AppTheme.primaryBlue : AppTheme.mediumGray,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int step) {
    final isActive = _currentPage > step;
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isActive ? AppTheme.primaryBlue : AppTheme.lightGray,
    );
  }

  // Helper method to get entity name based on registration type
  String _getEntityName() {
    switch (_registrationType) {
      case 'University':
        return 'University';
      case 'College':
        return 'College';
      case 'Institute':
        return 'Institute';
      default:
        return 'University';
    }
  }

  Widget _buildBasicInfoPage() {
    final entityName = _getEntityName();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Registration Type Selector
          const Text(
            'Registration Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Select the type of registration',
            style: TextStyle(color: AppTheme.mediumGray, fontSize: 13),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _registrationTypeOptions.map((type) {
              final isSelected = _registrationType == type;
              return GestureDetector(
                onTap: () => setState(() => _registrationType = type),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryBlue : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryBlue
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Logo and Background Image Section
          const Text(
            'Branding & Images',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Upload your institution\'s logo and cover image',
            style: TextStyle(color: AppTheme.mediumGray, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Logo Upload
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _logoFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_logoFile!, fit: BoxFit.cover),
                            )
                          : Icon(
                              Icons.business,
                              size: 40,
                              color: Colors.grey.shade400,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Institution Logo *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.charcoal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _logoFile != null
                                ? 'Logo uploaded'
                                : 'Upload square logo (JPG, PNG, SVG)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _pickLogo,
                            icon: Icon(
                              _logoFile != null
                                  ? Icons.check_circle
                                  : Icons.upload_file,
                              size: 18,
                            ),
                            label: Text(
                              _logoFile != null ? 'Change Logo' : 'Upload Logo',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: AppTheme.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Background Image Upload
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cover / Background Image',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.charcoal,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _backgroundImageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _backgroundImageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No background image uploaded',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Recommended: 1920x400px (JPG, PNG)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _pickBackgroundImage,
                      icon: Icon(
                        _backgroundImageFile != null
                            ? Icons.check_circle
                            : Icons.upload_file,
                        size: 18,
                      ),
                      label: Text(
                        _backgroundImageFile != null ? 'Change' : 'Upload',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade700,
                        foregroundColor: AppTheme.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Enter your $entityName\'s basic details',
            style: TextStyle(color: AppTheme.mediumGray, fontSize: 13),
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: '$entityName Name *',
            hint: 'e.g., Delhi $entityName',
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'University name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Abbreviation *',
            hint: 'e.g., DU',
            controller: _abbreviationController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Abbreviation is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Established Year *',
                  hint: 'e.g., 1922',
                  controller: _establishedYearController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Year is required';
                    }
                    final year = int.tryParse(value);
                    if (year == null ||
                        year < 1800 ||
                        year > DateTime.now().year) {
                      return 'Invalid year';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              if (_registrationType == 'University' ||
                  _registrationType == 'College')
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$entityName Type *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.charcoal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: AppConstants.universityTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedType = value!),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'State *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.charcoal,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedState,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                items: AppConstants.indianStates.map((state) {
                  return DropdownMenuItem(value: state, child: Text(state));
                }).toList(),
                onChanged: (value) => setState(() => _selectedState = value!),
              ),
            ],
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Description *',
            hint: 'Brief description of your university',
            controller: _descriptionController,
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Description is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          const Text(
            'Facilities',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.facilities.map((facility) {
              final isSelected = _selectedFacilities.contains(facility);
              return FilterChip(
                label: Text(facility),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFacilities.add(facility);
                    } else {
                      _selectedFacilities.remove(facility);
                    }
                  });
                },
                selectedColor: AppTheme.primaryBlue.withOpacity(0.3),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          const Text(
            'Accreditations',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.accreditations.map((accreditation) {
              final isSelected = _selectedAccreditations.contains(
                accreditation,
              );
              return FilterChip(
                label: Text(accreditation),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedAccreditations.add(accreditation);
                    } else {
                      _selectedAccreditations.remove(accreditation);
                    }
                  });
                },
                selectedColor: AppTheme.success.withOpacity(0.3),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Accreditation Certificate Upload
          _buildFileUploadButton(
            'Upload Accreditation Certificate',
            _accreditationCertFile,
            _pickAccreditationCert,
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload official accreditation certificate (PDF, JPG, PNG)',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Custom Test Option
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _hasCustomTest,
                      onChanged: (value) {
                        setState(() => _hasCustomTest = value ?? false);
                      },
                      activeColor: AppTheme.primaryBlue,
                    ),
                    const Expanded(
                      child: Text(
                        'We conduct custom entrance test',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.charcoal,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_hasCustomTest) ...[
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Test Name',
                    hint: 'e.g., University Entrance Test',
                    controller: _customTestNameController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Test Description',
                    hint: 'Brief description of the test',
                    controller: _customTestDescriptionController,
                    maxLines: 3,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Provide contact details for communication',
            style: TextStyle(color: AppTheme.mediumGray, fontSize: 13),
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Official Email *',
            hint: 'contact@university.edu.in',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Phone Number *',
            hint: '+91 XXXXXXXXXX',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              if (value.length != 10) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Website',
            hint: 'https://www.university.edu.in',
            controller: _websiteController,
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Complete Address *',
            hint: 'Street, Area, Landmark',
            controller: _addressController,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Address is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'City *',
                  hint: 'e.g., New Delhi',
                  controller: TextEditingController(text: _selectedCity),
                  onChanged: (value) => _selectedCity = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'City is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: 'Pincode *',
                  hint: 'e.g., 110001',
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pincode is required';
                    }
                    if (value.length != 6) {
                      return 'Invalid pincode';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Google Maps Link (Optional)
          const Divider(),
          const SizedBox(height: 24),
          const Text(
            'Location & Social Media (Optional)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Google Maps Link',
            hint: 'https://maps.google.com/...',
            controller: _googleMapsLinkController,
            keyboardType: TextInputType.url,
            prefixIcon: const Icon(Icons.location_on, color: Colors.red),
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Facebook Page',
            hint: 'https://facebook.com/...',
            controller: _facebookLinkController,
            keyboardType: TextInputType.url,
            prefixIcon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Twitter/X Profile',
            hint: 'https://twitter.com/...',
            controller: _twitterLinkController,
            keyboardType: TextInputType.url,
            prefixIcon: const Icon(Icons.tag, color: Color(0xFF1DA1F2)),
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'LinkedIn Page',
            hint: 'https://linkedin.com/...',
            controller: _linkedinLinkController,
            keyboardType: TextInputType.url,
            prefixIcon: const Icon(Icons.work, color: Color(0xFF0A66C2)),
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Instagram Profile',
            hint: 'https://instagram.com/...',
            controller: _instagramLinkController,
            keyboardType: TextInputType.url,
            prefixIcon: const Icon(Icons.camera_alt, color: Color(0xFFE4405F)),
          ),
        ],
      ),
    );
  }

  Widget _buildFileUploadButton(String label, File? file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.charcoal,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.attach_file, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    file != null
                        ? file.path.split('/').last.split('\\').last
                        : 'Tap to select file',
                    style: TextStyle(
                      color: file != null ? Colors.black : Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorizedPersonPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Authorized Person',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Select who will represent the university',
            style: TextStyle(color: AppTheme.mediumGray, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Tab Selector
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _authorizationType = 'individual'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _authorizationType == 'individual'
                          ? AppTheme.primaryBlue
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      border: Border.all(
                        color: _authorizationType == 'individual'
                            ? AppTheme.primaryBlue
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person,
                          size: 18,
                          color: _authorizationType == 'individual'
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Individual',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _authorizationType == 'individual'
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _authorizationType = 'firm'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _authorizationType == 'firm'
                          ? AppTheme.primaryBlue
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      border: Border.all(
                        color: _authorizationType == 'firm'
                            ? AppTheme.primaryBlue
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.business,
                          size: 18,
                          color: _authorizationType == 'firm'
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Firm/Organization',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _authorizationType == 'firm'
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Individual Form
          if (_authorizationType == 'individual') ...[
            CustomTextField(
              label: 'Full Name *',
              hint: 'Enter full name',
              controller: _authorizePersonNameController,
              validator: (value) {
                if (_authorizationType == 'individual' &&
                    (value == null || value.isEmpty)) {
                  return 'Full name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Designation *',
              hint: 'e.g., Admission Incharge',
              controller: _authorizePersonDetailsController,
              validator: (value) {
                if (_authorizationType == 'individual' &&
                    (value == null || value.isEmpty)) {
                  return 'Designation is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Authorized Person Photo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  if (_authorizedPersonPhotoFile != null)
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(_authorizedPersonPhotoFile!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _pickAuthorizedPersonPhoto,
                    icon: Icon(
                      _authorizedPersonPhotoFile != null
                          ? Icons.check_circle
                          : Icons.upload_file,
                      size: 18,
                    ),
                    label: Text(
                      _authorizedPersonPhotoFile != null
                          ? 'Change Photo'
                          : 'Upload Photo',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: AppTheme.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Upload authorized person photo (JPG, PNG)',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],

          // Firm/Organization Form
          if (_authorizationType == 'firm') ...[
            // Show Company/Agency section only for University, Institute, Consultancy
            // Hide for College
            if (_registrationType != 'College') ...[
              const Text(
                'Company / Agency Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Company / Agency Name *',
                hint: 'Enter company name',
                controller: _companyNameController,
                validator: (value) {
                  if (_authorizationType == 'firm' &&
                      _registrationType != 'College' &&
                      (value == null || value.isEmpty)) {
                    return 'Company name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Firm/Organization Name *',
                hint: 'e.g., University Trust, Management Board',
                controller: _firmNameController,
                validator: (value) {
                  if (_authorizationType == 'firm' &&
                      _registrationType != 'College' &&
                      (value == null || value.isEmpty)) {
                    return 'Firm name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildFileUploadButton(
                'Upload Company Registration Certificate *',
                _companyRegistrationCertFile,
                _pickCompanyRegistrationCert,
              ),
              const SizedBox(height: 16),
              _buildFileUploadButton(
                'Upload MOU / Agreement *',
                _mouAgreementFile,
                _pickMouAgreement,
              ),
              const SizedBox(height: 20),
              const Text(
                'Representative Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // For College, show only Organization Name
            if (_registrationType == 'College') ...[
              CustomTextField(
                label: 'Organization Name *',
                hint: 'e.g., College Trust, Management Board',
                controller: _firmNameController,
                validator: (value) {
                  if (_authorizationType == 'firm' &&
                      (value == null || value.isEmpty)) {
                    return 'Organization name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
            CustomTextField(
              label: 'Representative Name *',
              hint: 'Enter representative name',
              controller: _authorizePersonNameController,
              validator: (value) {
                if (_authorizationType == 'firm' &&
                    (value == null || value.isEmpty)) {
                  return 'Representative name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Representative Designation *',
              hint: 'e.g., Managing Director, CEO',
              controller: _authorizePersonDetailsController,
              validator: (value) {
                if (_authorizationType == 'firm' &&
                    (value == null || value.isEmpty)) {
                  return 'Designation is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildFileUploadButton(
              'Upload Organization ID / Authorization Letter *',
              _authPersonIdFile,
              _pickAuthPersonId,
            ),
          ],
          const SizedBox(height: 20),

          // Common fields for both Individual and Firm
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Official Email *',
            hint: 'official@university.edu',
            controller: _authorizePersonEmailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Official email is required';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Invalid email format';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Alternate Email',
            hint: 'alternate@example.com',
            controller: _alternateEmailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Mobile Number *',
            hint: '10-digit mobile number',
            controller: _authorizePersonPhoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mobile number is required';
              }
              if (value.length != 10) {
                return 'Enter valid 10-digit number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Alternate Contact',
            hint: '10-digit contact number',
            controller: _alternateContactController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Office Landline',
            hint: 'With STD code',
            controller: _officeLandlineController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),

          // ID Proof Section
          const Text(
            'Identity Verification',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ID Proof Type *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.charcoal,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _idProofType,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                hint: const Text('Select ID proof type'),
                items: _idProofTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _idProofType = value),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildFileUploadButton(
            'Upload ID Proof *',
            _idProofFile,
            _pickIdProof,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Department / Office Name',
            hint: 'e.g., Admission Cell, Admin Office',
            controller: _departmentNameController,
          ),
          const SizedBox(height: 20),

          // Authorization Documents Section
          const Text(
            'Authorization Documents',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),

          _buildFileUploadButton(
            'Upload Authorization Letter',
            _authorizationLetterFile,
            _pickAuthorizationLetter,
          ),
          const SizedBox(height: 8),
          const Text(
            'Letter on university letterhead confirming authorization',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          _buildFileUploadButton(
            'Upload Digital Signature / Stamp',
            _digitalSignatureFile,
            _pickDigitalSignature,
          ),
          const SizedBox(height: 16),

          // Authorization Validity
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _authValidityFromDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => _authValidityFromDate = picked);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Authorization Valid From',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _authValidityFromDate != null
                          ? '${_authValidityFromDate!.day}/${_authValidityFromDate!.month}/${_authValidityFromDate!.year}'
                          : 'Select date',
                      style: TextStyle(
                        color: _authValidityFromDate != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate:
                          _authValidityToDate ??
                          DateTime.now().add(const Duration(days: 365)),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => _authValidityToDate = picked);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Valid To',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _authValidityToDate != null
                          ? '${_authValidityToDate!.day}/${_authValidityToDate!.month}/${_authValidityToDate!.year}'
                          : 'Select date',
                      style: TextStyle(
                        color: _authValidityToDate != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Remarks / Notes',
            hint: 'Any additional comments or information',
            controller: _authRemarksController,
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Info Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'OTP verification will be sent to email and mobile for authentication',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetailsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bank Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enter bank account details for transactions',
            style: TextStyle(color: AppTheme.mediumGray, fontSize: 13),
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Account Holder Name *',
            hint: 'Name as per bank account',
            controller: _accountHolderNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Account holder name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Bank Name *',
            hint: 'e.g., State Bank of India',
            controller: _bankNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bank name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Account Number *',
            hint: 'Enter account number',
            controller: _accountNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Account number is required';
              }
              if (value.length < 9 || value.length > 18) {
                return 'Invalid account number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'IFSC Code *',
            hint: 'e.g., SBIN0001234',
            controller: _ifscController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
              LengthLimitingTextInputFormatter(11),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'IFSC code is required';
              }
              if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value)) {
                return 'Invalid IFSC code';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Branch Name *',
            hint: 'e.g., Connaught Place',
            controller: _branchController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Branch name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          const Divider(),
          const SizedBox(height: 20),

          const Text(
            'UPI Payment Details (Optional)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'UPI ID',
            hint: 'yourname@upi',
            controller: _upiIdController,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16),

          _buildFileUploadButton(
            'Upload UPI QR Code',
            _qrCodeFile,
            _pickQRCode,
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload QR code for UPI payments (JPG, PNG)',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightBlue,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Bank details will be verified before approval. Ensure all information is accurate.',
                    style: TextStyle(fontSize: 13, color: AppTheme.darkBlue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Declaration Checkbox
          const Divider(),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade300, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Declaration',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.charcoal,
                  ),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: _acceptDeclaration,
                  onChanged: (value) {
                    setState(() => _acceptDeclaration = value ?? false);
                  },
                  activeColor: AppTheme.primaryBlue,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    'I hereby declare that all the information provided is accurate and complete to the best of my knowledge. I understand that any false information may lead to rejection of the registration.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.charcoal,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
