import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/custom_button.dart';
import 'package:university_app_2/widgets/custom_text_field.dart';
import 'package:university_app_2/models/university_model.dart';

class EditUniversityScreen extends StatefulWidget {
  final University university;

  const EditUniversityScreen({super.key, required this.university});

  @override
  State<EditUniversityScreen> createState() => _EditUniversityScreenState();
}

class _EditUniversityScreenState extends State<EditUniversityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _abbreviationController = TextEditingController();
  final _establishedYearController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _branchController = TextEditingController();
  final _upiIdController = TextEditingController();

  // Authorize Person Controllers
  final _authorizePersonNameController = TextEditingController();
  final _firmNameController = TextEditingController();
  final _authorizePersonDetailsController = TextEditingController();
  final _authorizePersonPhoneController = TextEditingController();
  final _authorizePersonEmailController = TextEditingController();
  final _alternateEmailController = TextEditingController();
  final _alternateContactController = TextEditingController();
  final _departmentNameController = TextEditingController();
  final _officeLandlineController = TextEditingController();
  final _remarksController = TextEditingController();

  // ID Proof & Documents
  String _idProofType = 'University ID';
  File? _idProofFile;
  File? _authorizationLetterFile;
  File? _digitalSignatureFile;

  // Authorization Validity
  DateTime? _validityFromDate;
  DateTime? _validityToDate;

  // Agency Linkage
  bool _authorizedViaAgency = false;
  String? _selectedAgency;

  // Social Media & Maps
  final _googleMapsLinkController = TextEditingController();
  final _facebookLinkController = TextEditingController();
  final _twitterLinkController = TextEditingController();
  final _linkedinLinkController = TextEditingController();
  final _instagramLinkController = TextEditingController();

  // Custom Test
  final _customTestNameController = TextEditingController();
  final _customTestDescriptionController = TextEditingController();
  bool _hasCustomTest = false;

  // Files
  File? _logoFile;
  File? _backgroundImageFile;
  File? _accreditationCertFile;
  File? _authorizedPersonPhotoFile;
  File? _qrCodeFile;

  String _selectedType = 'Private';
  List<String> _selectedFacilities = [];
  List<String> _selectedAccreditations = [];
  bool _isLoading = false;

  // Authorization Type: 'individual' or 'firm'
  String _authorizationType = 'individual';

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _nameController.text = widget.university.name;
    _abbreviationController.text = widget.university.abbreviation;
    _establishedYearController.text = widget.university.establishedYear
        .toString();
    _descriptionController.text = widget.university.description;
    _contactEmailController.text = widget.university.contactEmail;
    _contactPhoneController.text = widget.university.contactPhone;
    _addressController.text = widget.university.address;
    _bankNameController.text = widget.university.bankName ?? '';
    _accountNumberController.text = widget.university.accountNumber ?? '';
    _ifscCodeController.text = widget.university.ifscCode ?? '';
    _branchController.text = widget.university.branch ?? '';

    // Initialize authorize person fields (add these fields to university model if not present)
    _authorizePersonNameController.text = '';
    _firmNameController.text = '';
    _authorizePersonDetailsController.text = '';
    _authorizePersonPhoneController.text = '';
    _authorizePersonEmailController.text = '';

    _selectedType = widget.university.type;
    _selectedFacilities = List.from(widget.university.facilities);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _abbreviationController.dispose();
    _establishedYearController.dispose();
    _descriptionController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _addressController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _branchController.dispose();
    _authorizePersonNameController.dispose();
    _firmNameController.dispose();
    _authorizePersonDetailsController.dispose();
    _authorizePersonPhoneController.dispose();
    _authorizePersonEmailController.dispose();
    _alternateEmailController.dispose();
    _alternateContactController.dispose();
    _departmentNameController.dispose();
    _officeLandlineController.dispose();
    _remarksController.dispose();
    _accountHolderNameController.dispose();
    _upiIdController.dispose();
    _googleMapsLinkController.dispose();
    _facebookLinkController.dispose();
    _twitterLinkController.dispose();
    _linkedinLinkController.dispose();
    _instagramLinkController.dispose();
    _customTestNameController.dispose();
    _customTestDescriptionController.dispose();
    super.dispose();
  }

  // File Pickers
  Future<void> _pickLogo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'svg'],
      );
      if (result != null) {
        setState(() => _logoFile = File(result.files.single.path!));
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
        setState(() => _backgroundImageFile = File(result.files.single.path!));
      }
    } catch (e) {
      debugPrint('Error picking background: $e');
    }
  }

  Future<void> _pickAccreditationCert() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(
          () => _accreditationCertFile = File(result.files.single.path!),
        );
      }
    } catch (e) {
      debugPrint('Error picking certificate: $e');
    }
  }

  Future<void> _pickAuthorizedPersonPhoto() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(
          () => _authorizedPersonPhotoFile = File(result.files.single.path!),
        );
      }
    } catch (e) {
      debugPrint('Error picking photo: $e');
    }
  }

  Future<void> _pickQRCode() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(() => _qrCodeFile = File(result.files.single.path!));
      }
    } catch (e) {
      debugPrint('Error picking QR code: $e');
    }
  }

  Future<void> _pickIDProof() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();
        if (fileSize > 2 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File size must be less than 2MB')),
            );
          }
          return;
        }
        setState(() => _idProofFile = file);
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
        final file = File(result.files.single.path!);
        final fileSize = await file.length();
        if (fileSize > 2 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File size must be less than 2MB')),
            );
          }
          return;
        }
        setState(() => _authorizationLetterFile = file);
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
        final file = File(result.files.single.path!);
        final fileSize = await file.length();
        if (fileSize > 2 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File size must be less than 2MB')),
            );
          }
          return;
        }
        setState(() => _digitalSignatureFile = file);
      }
    } catch (e) {
      debugPrint('Error picking digital signature: $e');
    }
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('University profile updated successfully'),
            backgroundColor: AppTheme.success,
          ),
        );

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: const AppHeader(title: 'Edit University Profile'),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Basic Information Section
                  _buildSection(
                    title: 'Basic Information',
                    children: [
                      CustomTextField(
                        label: 'University Name',
                        hint: 'Enter university name',
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
                        label: 'Short Name/Abbreviation',
                        hint: 'Enter abbreviation',
                        controller: _abbreviationController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Abbreviation is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Established Year',
                        hint: 'Enter established year',
                        controller: _establishedYearController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Established year is required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid year';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        label: 'University Type',
                        value: _selectedType,
                        items: [
                          'Private',
                          'Public',
                          'Government',
                          'Autonomous',
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                    ],
                  ),

                  // Accounts Detail Section
                  _buildSection(
                    title: 'Accounts Detail',
                    children: [
                      CustomTextField(
                        label: 'Bank Name',
                        hint: 'Enter bank name',
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
                        label: 'Account Number',
                        hint: 'Enter account number',
                        controller: _accountNumberController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Account number is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'IFSC Code',
                        hint: 'Enter IFSC code',
                        controller: _ifscCodeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'IFSC code is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Branch',
                        hint: 'Enter branch name',
                        controller: _branchController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Branch is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  // Contact Information Section
                  _buildSection(
                    title: 'Contact Information',
                    children: [
                      CustomTextField(
                        label: 'Contact Email',
                        hint: 'Enter contact email',
                        controller: _contactEmailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact email is required';
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
                        label: 'Contact Phone',
                        hint: 'Enter contact phone',
                        controller: _contactPhoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact phone is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Address',
                        hint: 'Enter university address',
                        controller: _addressController,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Address is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  // Authorize Person Section - Comprehensive Form
                  _buildSection(
                    title: 'Authorized Person Information',
                    children: [
                      // Agency Toggle
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Authorized via Agency / Direct University',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Switch(
                              value: _authorizedViaAgency,
                              onChanged: (value) =>
                                  setState(() => _authorizedViaAgency = value),
                              activeColor: AppTheme.primaryBlue,
                            ),
                          ],
                        ),
                      ),

                      // Agency Selection (conditional)
                      if (_authorizedViaAgency) ...[
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'Select Agency Name *',
                          value: _selectedAgency ?? 'Agency A',
                          items: ['Agency A', 'Agency B', 'Agency C'],
                          onChanged: (value) =>
                              setState(() => _selectedAgency = value),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Authorization Type Selector
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
                              color: Colors.orange.shade700,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Choose authorization type',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tab Selector
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(
                                () => _authorizationType = 'individual',
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _authorizationType == 'individual'
                                      ? AppTheme.primaryBlue
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
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
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 16,
                                      color: _authorizationType == 'individual'
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Individual',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            _authorizationType == 'individual'
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _authorizationType = 'firm'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _authorizationType == 'firm'
                                      ? AppTheme.primaryBlue
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
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
                                  children: [
                                    Icon(
                                      Icons.business,
                                      size: 16,
                                      color: _authorizationType == 'firm'
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Firm/Organization',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _authorizationType == 'firm'
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Firm Name (for firm type)
                      if (_authorizationType == 'firm') ...[
                        CustomTextField(
                          label: 'Firm/Organization Name *',
                          hint: 'e.g., University Trust, Management Board',
                          controller: _firmNameController,
                          validator: (value) {
                            if (_authorizationType == 'firm' &&
                                (value == null || value.isEmpty)) {
                              return 'Firm name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Full Name
                      CustomTextField(
                        label: 'Full Name *',
                        hint: 'Enter full name of the authorized person',
                        controller: _authorizePersonNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Designation
                      CustomTextField(
                        label: 'Designation *',
                        hint: 'e.g., Admission Incharge, Director, Registrar',
                        controller: _authorizePersonDetailsController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Designation is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Department/Office Name
                      CustomTextField(
                        label: 'Department / Office Name',
                        hint: 'e.g., Admission Cell',
                        controller: _departmentNameController,
                      ),
                      const SizedBox(height: 16),

                      // Official Email
                      CustomTextField(
                        label: 'Official Email *',
                        hint: 'preferably with university domain',
                        controller: _authorizePersonEmailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Official email is required';
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

                      // Alternate Email
                      CustomTextField(
                        label: 'Alternate Email',
                        hint: 'Optional secondary email',
                        controller: _alternateEmailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Mobile Number
                      CustomTextField(
                        label: 'Mobile Number *',
                        hint: '10-digit number (OTP verification required)',
                        controller: _authorizePersonPhoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mobile number is required';
                          }
                          if (value.length != 10) {
                            return 'Mobile number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Alternate Contact
                      CustomTextField(
                        label: 'Alternate Contact',
                        hint: 'Optional backup contact number',
                        controller: _alternateContactController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length != 10) {
                            return 'Contact number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Office Landline
                      CustomTextField(
                        label: 'Office Landline',
                        hint: 'Optional landline number',
                        controller: _officeLandlineController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),

                      // ID Proof Section
                      const Text(
                        'ID Proof & Verification',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.charcoal,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ID Proof Type Dropdown
                      _buildDropdownField(
                        label: 'ID Proof Type',
                        value: _idProofType,
                        items: ['University ID'],
                        onChanged: (value) =>
                            setState(() => _idProofType = value!),
                      ),
                      const SizedBox(height: 16),

                      // Upload ID Proof
                      _buildFileUploadButton(
                        label: 'Upload ID Proof *',
                        file: _idProofFile,
                        onTap: _pickIDProof,
                        icon: Icons.badge,
                      ),
                      const SizedBox(height: 20),

                      // Authorization Documents
                      const Text(
                        'Authorization Documents',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.charcoal,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Upload Authorization Letter
                      _buildFileUploadButton(
                        label: 'Upload Authorization Letter',
                        subtitle: 'Letter on university letterhead',
                        file: _authorizationLetterFile,
                        onTap: _pickAuthorizationLetter,
                        icon: Icons.description,
                      ),
                      const SizedBox(height: 16),

                      // Upload Digital Signature
                      _buildFileUploadButton(
                        label: 'Upload Digital Signature / Stamp',
                        subtitle: 'Official signature or institutional stamp',
                        file: _digitalSignatureFile,
                        onTap: _pickDigitalSignature,
                        icon: Icons.draw,
                      ),
                      const SizedBox(height: 20),

                      // Authorization Validity
                      const Text(
                        'Authorization Validity (Optional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.charcoal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField(
                              label: 'Valid From',
                              date: _validityFromDate,
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (date != null)
                                  setState(() => _validityFromDate = date);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDateField(
                              label: 'Valid To',
                              date: _validityToDate,
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      _validityFromDate ?? DateTime.now(),
                                  firstDate:
                                      _validityFromDate ?? DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (date != null)
                                  setState(() => _validityToDate = date);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Remarks
                      CustomTextField(
                        label: 'Remarks / Notes',
                        hint: 'Optional field for any additional comments',
                        controller: _remarksController,
                        maxLines: 3,
                      ),

                      // OTP Verification Notice
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified,
                              color: Colors.green.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'OTP verification required for Email & Mobile for authenticity',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Facilities Section
                  _buildSection(
                    title: 'Facilities & Services',
                    children: [
                      const Text(
                        'Select Available Facilities',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.charcoal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AppConstants.facilities.map((facility) {
                          final isSelected = _selectedFacilities.contains(
                            facility,
                          );
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
                            selectedColor: AppTheme.primaryBlue.withOpacity(
                              0.1,
                            ),
                            checkmarkColor: AppTheme.primaryBlue,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppTheme.primaryBlue
                                  : AppTheme.charcoal,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  // Description Section
                  _buildSection(
                    title: 'Description',
                    children: [
                      CustomTextField(
                        label: 'University Description',
                        hint: 'Enter university description',
                        controller: _descriptionController,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: 'Update Profile',
                      onPressed: _handleSubmit,
                      isLoading: _isLoading,
                      icon: Icons.save,
                    ),
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 24),
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
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.charcoal,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.mediumGray.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppTheme.primaryBlue,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          dropdownColor: AppTheme.white,
          style: const TextStyle(color: AppTheme.charcoal),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFileUploadButton({
    required String label,
    String? subtitle,
    required File? file,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: file != null ? Colors.green.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: file != null ? Colors.green.shade300 : Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: file != null
                    ? Colors.green.shade100
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                file != null ? Icons.check_circle : icon,
                color: file != null
                    ? Colors.green.shade700
                    : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: file != null
                          ? Colors.green.shade900
                          : AppTheme.charcoal,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                  if (file != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      file.path.split('/').last,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              file != null ? Icons.edit : Icons.upload_file,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppTheme.primaryBlue, size: 20),
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
                    date != null
                        ? '${date.day}/${date.month}/${date.year}'
                        : 'Select date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: date != null
                          ? AppTheme.charcoal
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
