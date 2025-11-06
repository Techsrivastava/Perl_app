import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/widgets/custom_button.dart';
import 'package:university_app_2/widgets/custom_text_field.dart';

class UniversityRegisterScreen extends StatefulWidget {
  const UniversityRegisterScreen({super.key});

  @override
  State<UniversityRegisterScreen> createState() => _UniversityRegisterScreenState();
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
  
  // Bank Details Controllers
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  final _branchController = TextEditingController();

  String _selectedType = 'Government';
  String _selectedState = 'Delhi';
  String _selectedCity = '';
  List<String> _selectedFacilities = [];
  List<String> _selectedAccreditations = [];

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
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _branchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: AppConstants.mediumAnimation,
        curve: Curves.easeInOut,
      );
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
            content: const Text('Your university registration has been submitted for approval.'),
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
        title: const Text('University Registration'),
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
                  _buildStepIndicator(2, 'Bank'),
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
                  _buildBankDetailsPage(),
                ],
              ),
            ),
            
            // Navigation Buttons
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        label: _currentPage == 2 ? 'Submit' : 'Next',
                        onPressed: _currentPage == 2 ? _handleSubmit : _nextPage,
                        isLoading: _isLoading,
                        isFullWidth: true,
                        icon: _currentPage == 2 ? Icons.check : Icons.arrow_forward,
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

  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enter your university\'s basic details',
            style: TextStyle(color: AppTheme.mediumGray, fontSize: 13),
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            label: 'University Name *',
            hint: 'e.g., Delhi University',
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
                    if (year == null || year < 1800 || year > DateTime.now().year) {
                      return 'Invalid year';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'University Type *',
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      items: AppConstants.universityTypes.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedType = value!),
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              final isSelected = _selectedAccreditations.contains(accreditation);
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
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
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
        ],
      ),
    );
  }
}
