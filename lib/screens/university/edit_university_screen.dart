import 'package:flutter/material.dart';
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
  final _ifscCodeController = TextEditingController();
  final _branchController = TextEditingController();

  String _selectedType = 'Private';
  List<String> _selectedFacilities = [];
  bool _isLoading = false;

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
    super.dispose();
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
}
