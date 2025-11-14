import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/models/admission_model.dart';

class StudentDetailsScreen extends StatefulWidget {
  final AdmissionForm admissionForm;

  const StudentDetailsScreen({super.key, required this.admissionForm});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController altMobileController;
  late TextEditingController emailController;
  late TextEditingController fatherNameController;
  late TextEditingController motherNameController;
  late TextEditingController parentMobileController;
  late TextEditingController streetController;
  late TextEditingController cityController;
  late TextEditingController districtController;
  late TextEditingController stateController;
  late TextEditingController pinCodeController;

  String? selectedGender;
  DateTime? selectedDateOfBirth;
  String? studentPhotoPath;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.admissionForm.studentDetails?.studentFullName ?? '',
    );
    mobileController = TextEditingController(
      text: widget.admissionForm.studentDetails?.mobileNumber ?? '',
    );
    altMobileController = TextEditingController(
      text: widget.admissionForm.studentDetails?.alternateMobileNumber ?? '',
    );
    emailController = TextEditingController(
      text: widget.admissionForm.studentDetails?.emailId ?? '',
    );
    fatherNameController = TextEditingController(
      text: widget.admissionForm.studentDetails?.fatherName ?? '',
    );
    motherNameController = TextEditingController(
      text: widget.admissionForm.studentDetails?.motherName ?? '',
    );
    parentMobileController = TextEditingController(
      text: widget.admissionForm.studentDetails?.parentContactNumber ?? '',
    );
    streetController = TextEditingController(
      text: widget.admissionForm.studentDetails?.streetAddress ?? '',
    );
    cityController = TextEditingController(
      text: widget.admissionForm.studentDetails?.city ?? '',
    );
    districtController = TextEditingController(
      text: widget.admissionForm.studentDetails?.district ?? '',
    );
    stateController = TextEditingController(
      text: widget.admissionForm.studentDetails?.state ?? '',
    );
    pinCodeController = TextEditingController(
      text: widget.admissionForm.studentDetails?.pinCode ?? '',
    );

    selectedGender = widget.admissionForm.studentDetails?.gender;
    selectedDateOfBirth = widget.admissionForm.studentDetails?.dateOfBirth;
    studentPhotoPath = widget.admissionForm.studentDetails?.studentPhotoPath;
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    altMobileController.dispose();
    emailController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    parentMobileController.dispose();
    streetController.dispose();
    cityController.dispose();
    districtController.dispose();
    stateController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        setState(() {
          studentPhotoPath = image.path;
          // persist immediately so parent/other views can read updated path
          widget.admissionForm.studentDetails!.studentPhotoPath =
              studentPhotoPath;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDateOfBirth) {
      setState(() {
        selectedDateOfBirth = picked;
      });
    }
  }

  void _saveDetails() {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        selectedGender == null ||
        selectedDateOfBirth == null ||
        fatherNameController.text.isEmpty ||
        motherNameController.text.isEmpty ||
        parentMobileController.text.isEmpty ||
        streetController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        pinCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    widget.admissionForm.studentDetails = StudentDetails(
      studentFullName: nameController.text,
      mobileNumber: mobileController.text,
      alternateMobileNumber: altMobileController.text,
      emailId: emailController.text,
      gender: selectedGender,
      dateOfBirth: selectedDateOfBirth,
      fatherName: fatherNameController.text,
      motherName: motherNameController.text,
      parentContactNumber: parentMobileController.text,
      streetAddress: streetController.text,
      city: cityController.text,
      district: districtController.text,
      state: stateController.text,
      pinCode: pinCodeController.text,
      studentPhotoPath: studentPhotoPath,
    );

    widget.admissionForm.updatedAt = DateTime.now();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Photo Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryBlue, width: 2),
                      image: studentPhotoPath != null
                          ? DecorationImage(
                              image: studentPhotoPath!.startsWith('http')
                                  ? NetworkImage(studentPhotoPath!)
                                        as ImageProvider
                                  : FileImage(File(studentPhotoPath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: studentPhotoPath == null
                        ? const Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: AppTheme.primaryBlue,
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: AppTheme.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Basic Information Section
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),

            // Student Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Student Full Name *',
                hintText: 'Enter student full name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Gender and DOB Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender *',
                      prefixIcon: const Icon(Icons.wc),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ['Male', 'Female', 'Other'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _selectDateOfBirth,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date of Birth *',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedDateOfBirth != null
                                ? DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(selectedDateOfBirth!)
                                : 'Select Date',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Mobile Numbers
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: 'Mobile Number *',
                hintText: '10 digits',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: altMobileController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: 'Alternate Mobile Number',
                hintText: '10 digits',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email ID',
                hintText: 'student@email.com',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Parent Information Section
            Text(
              'Parent Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: fatherNameController,
                    decoration: InputDecoration(
                      labelText: "Father's Name *",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: motherNameController,
                    decoration: InputDecoration(
                      labelText: "Mother's Name *",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: parentMobileController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: 'Parent Contact Number *',
                hintText: '10 digits',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Address Section
            Text(
              'Address',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: streetController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Street Address *',
                hintText: 'House / Street',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      labelText: 'City *',
                      prefixIcon: const Icon(Icons.location_city),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: districtController,
                    decoration: InputDecoration(
                      labelText: 'District *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: stateController,
                    decoration: InputDecoration(
                      labelText: 'State *',
                      prefixIcon: const Icon(Icons.map),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: pinCodeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'PIN Code *',
                      hintText: '6 digits',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: AppTheme.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Save & Continue'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
