import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/custom_button.dart';
import 'package:university_app_2/widgets/custom_text_field.dart';

// Initialize the image picker
final ImagePicker _imagePicker = ImagePicker();

class UniversitySignupScreen extends StatefulWidget {
  const UniversitySignupScreen({super.key});

  @override
  State<UniversitySignupScreen> createState() => _UniversitySignupScreenState();
}

class _UniversitySignupScreenState extends State<UniversitySignupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;
  bool _agreeTerms = false;
  
  // Form controllers
  final TextEditingController _universityNameController = TextEditingController();
  final TextEditingController _shortNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _authPersonNameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _personalEmailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _altContactNumberController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountHolderNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // File pickers
  File? _logoFile;
  File? _bannerFile;
  File? _brochureFile;
  File? _authLetterFile;
  File? _qrCodeFile;

  // Dropdown values
  String? _universityType;
  String? _affiliationType;
  String? _state;
  String? _yearOfEstablishment;
  bool _autoApproval = false;

  // List of Indian states for dropdown
  final List<String> _indianStates = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur',
    'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab',
    'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
    'Uttar Pradesh', 'Uttarakhand', 'West Bengal'
  ];

  // List of university types
  final List<String> _universityTypes = [
    'Government',
    'Private',
    'Deemed',
    'Open',
  ];

  // List of affiliation types
  final List<String> _affiliationTypes = [
    'UGC',
    'AICTE',
    'State Board',
    'Others',
  ];

  // Generate list of years (last 100 years)
  List<String> get _yearsList {
    final currentYear = DateTime.now().year;
    return List.generate(100, (index) => (currentYear - index).toString());
  }

  @override
  void dispose() {
    // Dispose all controllers
    _universityNameController.dispose();
    _shortNameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    _websiteController.dispose();
    _authPersonNameController.dispose();
    _designationController.dispose();
    _personalEmailController.dispose();
    _mobileNumberController.dispose();
    _altContactNumberController.dispose();
    _bankNameController.dispose();
    _accountHolderNameController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _branchNameController.dispose();
    _upiIdController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Pick image file
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
      );
      
      if (pickedFile != null) {
        setState(() {
          _logoFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick image')),
        );
      }
    }
  }

  // Pick banner image
  Future<void> _pickBannerImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1200,
      );
      
      if (pickedFile != null) {
        setState(() {
          _bannerFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking banner image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick banner image')),
        );
      }
    }
  }

  // Pick PDF file
  Future<void> _pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();
        const maxSize = 10 * 1024 * 1024; // 10MB
        
        if (fileSize > maxSize) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File size should be less than 10MB'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
        
        setState(() {
          _brochureFile = file;
        });
      }
    } catch (e) {
      debugPrint('Error picking PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick PDF file'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Pick authorization letter
  Future<void> _pickAuthLetter() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();
        const maxSize = 10 * 1024 * 1024; // 10MB
        
        if (fileSize > maxSize) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File size should be less than 10MB'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
        
        setState(() {
          _authLetterFile = file;
        });
      }
    } catch (e) {
      debugPrint('Error picking authorization letter: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick authorization letter'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Pick QR code image
  Future<void> _pickQRCode() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 500,
      );
      
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();
        const maxSize = 2 * 1024 * 1024; // 2MB
        
        if (fileSize > maxSize) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('QR code image should be less than 2MB'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
        
        setState(() {
          _qrCodeFile = file;
        });
      }
    } catch (e) {
      debugPrint('Error picking QR code: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick QR code image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Handle form submission
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      // If the form is not valid, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms and conditions')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement API call to submit the form data
      // This is where you would typically make an API call to your backend
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('University registration submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to success screen or dashboard
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Build form fields for each step
  List<Step> _buildSteps() {
    return [
      // Step 1: Basic Information
      Step(
        title: const Text('Basic Info'),
        content: Column(
          children: [
            _buildTextField('University Name*', 'Enter university name', _universityNameController, true),
            const SizedBox(height: 16),
            _buildTextField('Short Name*', 'e.g., LPU', _shortNameController, true),
            const SizedBox(height: 16),
            _buildDropdown('University Type*', _universityType, _universityTypes, (value) {
              setState(() {
                _universityType = value;
              });
            }),
            const SizedBox(height: 16),
            _buildDropdown('Affiliation Type*', _affiliationType, _affiliationTypes, (value) {
              setState(() {
                _affiliationType = value;
              });
            }),
            const SizedBox(height: 16),
            _buildDropdown('Year of Establishment*', _yearOfEstablishment, _yearsList, (value) {
              setState(() {
                _yearOfEstablishment = value;
              });
            }),
            const SizedBox(height: 16),
            _buildTextField('Description', 'Tell us about your university', _descriptionController, false, maxLines: 4),
          ],
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      // Step 2: Address & Contact
      Step(
        title: const Text('Contact'),
        content: Column(
          children: [
            _buildTextField('Address*', 'Enter full address', _addressController, true, maxLines: 3),
            const SizedBox(height: 16),
            _buildDropdown('State*', _state, _indianStates, (value) {
              setState(() {
                _state = value;
              });
            }),
            const SizedBox(height: 16),
            _buildTextField('City*', 'Enter city', _cityController, true),
            const SizedBox(height: 16),
            _buildTextField('Pin Code*', '6-digit PIN code', _pincodeController, true, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField('Official Email*', 'university@example.com', _emailController, true, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField('Contact Number*', '10-digit mobile number', _contactNumberController, true, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField('Website URL', 'https://example.com', _websiteController, false, keyboardType: TextInputType.url),
          ],
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      // Step 3: Authorized Person
      Step(
        title: const Text('Authorized Person'),
        content: Column(
          children: [
            _buildTextField('Full Name*', 'Enter full name', _authPersonNameController, true),
            const SizedBox(height: 16),
            _buildTextField('Designation*', 'e.g., Admission Incharge', _designationController, true),
            const SizedBox(height: 16),
            _buildTextField('Personal Email*', 'person@example.com', _personalEmailController, true, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField('Mobile Number*', '10-digit mobile number', _mobileNumberController, true, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField('Alternate Contact', '10-digit mobile number', _altContactNumberController, false, keyboardType: TextInputType.phone),
          ],
        ),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
      // Step 4: Bank Details
      Step(
        title: const Text('Bank Details'),
        content: Column(
          children: [
            _buildTextField('Bank Name*', 'e.g., State Bank of India', _bankNameController, true),
            const SizedBox(height: 16),
            _buildTextField('Account Holder Name*', 'As per bank records', _accountHolderNameController, true),
            const SizedBox(height: 16),
            _buildTextField('Account Number*', 'Enter account number', _accountNumberController, true, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField('IFSC Code*', '11-digit IFSC code', _ifscCodeController, true),
            const SizedBox(height: 16),
            _buildTextField('Branch Name', 'Enter branch name', _branchNameController, false),
            const SizedBox(height: 16),
            _buildTextField('UPI ID', 'yourname@upi', _upiIdController, false, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildFilePicker('Upload QR Code (Optional)', _qrCodeFile, _pickQRCode),
          ],
        ),
        isActive: _currentStep >= 3,
        state: _currentStep > 3 ? StepState.complete : StepState.indexed,
      ),
      // Step 5: Media Uploads
      Step(
        title: const Text('Media & Documents'),
        content: Column(
          children: [
            _buildImagePicker('University Logo*', _logoFile, _pickImage),
            const SizedBox(height: 16),
            _buildImagePicker('Banner Image*', _bannerFile, _pickBannerImage),
            const SizedBox(height: 16),
            _buildFilePicker('Brochure (PDF, Optional)', _brochureFile, _pickPdf),
            const SizedBox(height: 16),
            _buildFilePicker('Authorization Letter*', _authLetterFile, _pickAuthLetter, required: true),
            const SizedBox(height: 8),
            const Text(
              'Upload authorization/registration letter from UGC/AICTE/State Board',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        isActive: _currentStep >= 4,
        state: _currentStep > 4 ? StepState.complete : StepState.indexed,
      ),
      // Step 6: Account Setup
      Step(
        title: const Text('Account'),
        content: Column(
          children: [
            _buildTextField('Username*', 'Choose a username', _usernameController, true),
            const SizedBox(height: 16),
            _buildTextField('Password*', 'Create a strong password', _passwordController, true, isPassword: true),
            const SizedBox(height: 16),
            _buildTextField('Confirm Password*', 'Re-enter your password', _confirmPasswordController, true, isPassword: true),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _autoApproval,
                  onChanged: (value) {
                    setState(() {
                      _autoApproval = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'Enable auto-approval for consultant applications',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _agreeTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeTerms = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'I agree to the Terms of Service and Privacy Policy. I confirm that all information provided is accurate to the best of my knowledge.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
        isActive: _currentStep >= 5,
        state: _currentStep > 5 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  // Helper method to build text fields
  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    bool isRequired, {
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: isPassword
                ? IconButton(
                    icon: const Icon(Icons.visibility_off, size: 20),
                    onPressed: () {
                      // Toggle password visibility
                    },
                  )
                : null,
          ),
          keyboardType: keyboardType,
          obscureText: isPassword,
          maxLines: maxLines,
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            if (keyboardType == TextInputType.emailAddress && value!.isNotEmpty) {
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
            }
            if (keyboardType == TextInputType.phone && value!.isNotEmpty) {
              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                return 'Please enter a valid 10-digit number';
              }
            }
            if (isPassword && value!.length < 8) {
              return 'Password must be at least 8 characters';
            }
            if (controller == _confirmPasswordController && value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Helper method to build dropdown fields
  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged, {
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'Please select an option';
            }
            return null;
          },
          hint: const Text('Select an option'),
          isExpanded: true,
        ),
      ],
    );
  }

  // Helper method to build file picker
  Widget _buildFilePicker(String label, File? file, VoidCallback onTap, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            children: [
              if (required)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
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
                    file?.path.split('/').last ?? 'Tap to select file',
                    style: TextStyle(
                      color: file != null ? Colors.black : Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build image picker
  Widget _buildImagePicker(String label, File? imageFile, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade100,
            ),
            child: imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(imageFile, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('Tap to add $label', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Registration'),
        elevation: 0,
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  // Wrap Stepper in Expanded to prevent overflow
                  Expanded(
                    child: Stepper(
                      currentStep: _currentStep,
                      onStepContinue: () {
                        if (_currentStep < _buildSteps().length - 1) {
                          setState(() {
                            _currentStep++;
                          });
                        } else {
                          _submitForm();
                        }
                      },
                      onStepCancel: () {
                        if (_currentStep > 0) {
                          setState(() {
                            _currentStep--;
                          });
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      onStepTapped: (step) {
                        setState(() {
                          _currentStep = step;
                        });
                      },
                      steps: _buildSteps(),
                      controlsBuilder: (context, details) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_currentStep > 0)
                                OutlinedButton(
                                  onPressed: details.onStepCancel,
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    side: const BorderSide(color: AppTheme.primaryBlue),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(color: AppTheme.primaryBlue),
                                  ),
                                )
                              else
                                const SizedBox(width: 0),
                              
                              ElevatedButton(
                                onPressed: details.onStepContinue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  _currentStep == _buildSteps().length - 1 ? 'Submit' : 'Next',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// Custom TextField widget (you can replace this with your actual CustomTextField widget)
class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isRequired;
  final TextInputType keyboardType;
  final bool isPassword;
  final int maxLines;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.maxLines = 1,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: isPassword
                ? IconButton(
                    icon: const Icon(Icons.visibility_off, size: 20),
                    onPressed: () {
                      // Toggle password visibility
                    },
                  )
                : null,
          ),
          keyboardType: keyboardType,
          obscureText: isPassword,
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }
}
