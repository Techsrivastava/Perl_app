import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:educonnect/config/theme.dart';
import 'package:educonnect/widgets/custom_button.dart';
import 'package:educonnect/widgets/custom_text_field.dart';
import '../../services/university_service.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _universityNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController(text: 'www.stanford.edu');

  bool _isEditing = false;
  bool _isLoading = false;
  bool _isInitLoading = true;
  File? _profileImage;
  File? _backgroundImage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await AuthService.getUser();
      if (user != null && mounted) {
        setState(() {
          _universityNameController.text = user['name'] ?? '';
          _emailController.text = user['email'] ?? '';
          _phoneController.text = user['phone'] ?? '';
          _isInitLoading = false;
        });
      } else {
        setState(() => _isInitLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isInitLoading = false);
    }
  }

  @override
  void dispose() {
    _universityNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        setState(() {
          _profileImage = File(result.files.single.path!);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  Future<void> _pickBackgroundImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        setState(() {
          _backgroundImage = File(result.files.single.path!);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Prepare payload mapping to University model
        final payload = {
          'name': _universityNameController.text.trim(),
          'contactEmail': _emailController.text.trim(),
          'contactPhone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'website': _websiteController.text.trim(),
        };

        // Call the actual API via UniversityService
        await UniversityService.updateMyUniversity(payload);

        // Note: If you have actual file upload APIs for background/profile image,
        // call them here separately. Since they aren't fully defined yet in
        // university routes, we will leave the UI state as is for now.

        // _loadUserData(); // Optionally reload from server

        if (mounted) {
          setState(() {
            _isEditing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: AppTheme.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating profile: $e'),
              backgroundColor: AppTheme.error,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: _isInitLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // App Bar with Background Image
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: AppTheme.primaryBlue,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background Image
                        _backgroundImage != null
                            ? Image.file(_backgroundImage!, fit: BoxFit.cover)
                            : Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryBlue,
                                      AppTheme.darkBlue,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                        // Overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.3),
                                Colors.black.withValues(alpha: 0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        // Change Background Button
                        if (_isEditing)
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Material(
                              color: AppTheme.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                onTap: _pickBackgroundImage,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.camera_alt, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'Change Cover',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    if (!_isEditing)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => setState(() => _isEditing = true),
                      ),
                  ],
                ),

                // Profile Content
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Profile Picture
                      Transform.translate(
                        offset: const Offset(0, -50),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: AppTheme.white,
                                  child: CircleAvatar(
                                    radius: 57,
                                    backgroundColor: AppTheme.lightBlue,
                                    backgroundImage: _profileImage != null
                                        ? FileImage(_profileImage!)
                                        : null,
                                    child: _profileImage == null
                                        ? const Icon(
                                            Icons.school,
                                            size: 50,
                                            color: AppTheme.primaryBlue,
                                          )
                                        : null,
                                  ),
                                ),
                                if (_isEditing)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: _pickProfileImage,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryBlue,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppTheme.white,
                                            width: 3,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: AppTheme.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (!_isEditing)
                              Text(
                                _universityNameController.text,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.charcoal,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Form
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'University Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.charcoal,
                                ),
                              ),
                              const SizedBox(height: 16),

                              CustomTextField(
                                label: 'University Name *',
                                controller: _universityNameController,
                                enabled: _isEditing,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'University name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              CustomTextField(
                                label: 'Email *',
                                controller: _emailController,
                                enabled: _isEditing,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              CustomTextField(
                                label: 'Phone Number *',
                                controller: _phoneController,
                                enabled: _isEditing,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              CustomTextField(
                                label: 'Address *',
                                controller: _addressController,
                                enabled: _isEditing,
                                maxLines: 3,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Address is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              CustomTextField(
                                label: 'Website',
                                controller: _websiteController,
                                enabled: _isEditing,
                                keyboardType: TextInputType.url,
                              ),
                              const SizedBox(height: 24),

                              // Action Buttons
                              if (_isEditing)
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        label: 'Cancel',
                                        onPressed: () {
                                          setState(() => _isEditing = false);
                                        },
                                        variant: ButtonVariant.secondary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CustomButton(
                                        label: 'Save Changes',
                                        onPressed: _saveProfile,
                                        isLoading: _isLoading,
                                      ),
                                    ),
                                  ],
                                ),

                              // Statistics Cards
                              if (!_isEditing) ...[
                                const SizedBox(height: 24),
                                const Text(
                                  'Quick Stats',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.charcoal,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        'Total Courses',
                                        '45',
                                        Icons.book,
                                        Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildStatCard(
                                        'Applications',
                                        '1,234',
                                        Icons.people,
                                        Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        'Consultants',
                                        '23',
                                        Icons.business,
                                        Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildStatCard(
                                        'Revenue',
                                        '\$250K',
                                        Icons.attach_money,
                                        Colors.purple,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 24),
                            ],
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

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
