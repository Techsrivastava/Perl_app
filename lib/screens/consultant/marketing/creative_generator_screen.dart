import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config/theme.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/university_service.dart';
import '../../../../services/course_service.dart';
import '../../../../services/creative_service.dart';
import 'dart:convert';

class CreativeGeneratorScreen extends StatefulWidget {
  const CreativeGeneratorScreen({super.key});

  @override
  State<CreativeGeneratorScreen> createState() =>
      _CreativeGeneratorScreenState();
}

class _CreativeGeneratorScreenState extends State<CreativeGeneratorScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final TextEditingController _offerTextController = TextEditingController(
    text: 'Special Admission Offer! Enroll Now and Get Scholarship Benefits.',
  );

  String? _userName;
  String? _referralCode;
  List<dynamic> _universities = [];
  dynamic _selectedUniversity;
  List<dynamic> _courses = [];
  dynamic _selectedCourse;

  File? _bgImage;
  List<dynamic> _backendBanners = [];
  String? _qrCodeData;

  String _selectedPresetBg =
      'https://images.unsplash.com/photo-1541339907198-e08756ebafe3?w=800';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final user = await AuthService.getCurrentUser();
      final universities = await UniversityService.getUniversities();
      final banners = await CreativeService.getBannerTemplates();
      final assets = await CreativeService.generateAssets();

      if (mounted) {
        setState(() {
          _userName = user?['name'] ?? 'Consultant';
          _referralCode = user?['referralCode'] ?? 'EDU123';
          _universities = universities;
          _backendBanners = banners;
          _qrCodeData = assets['qrCode'];

          if (banners.isNotEmpty) {
            _selectedPresetBg = banners.first['templateUrl'];
          }

          if (universities.isNotEmpty) {
            _selectedUniversity = universities.first;
            _loadCourses(
              _selectedUniversity['_id'] ?? _selectedUniversity['id'],
            );
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadCourses(String universityId) async {
    try {
      final courses = await CourseService.getCourses(
        universityId: universityId,
      );
      if (mounted) {
        setState(() {
          _courses = courses;
          if (courses.isNotEmpty) {
            _selectedCourse = courses.first;
          } else {
            _selectedCourse = null;
          }
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _bgImage = File(pickedFile.path);
        _selectedPresetBg = '';
      });
    }
  }

  Future<void> _generateAndShare() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/creative.png').create();
      await imagePath.writeAsBytes(image);

      await Share.share(
        'Check out this opportunity at ${_selectedUniversity?['name']}!',
        subject: 'Educational Opportunity',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Creative Banner Generator'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Section
            const Text(
              'Preview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Center(
              child: Screenshot(
                controller: _screenshotController,
                child: _buildBannerPreview(),
              ),
            ),

            const SizedBox(height: 24),

            // Customization Section
            _buildCustomizationCard(),

            const SizedBox(height: 24),

            // Share Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _generateAndShare,
                icon: const Icon(Icons.share),
                label: const Text('Generate & Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerPreview() {
    return Container(
      width: 350,
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background
          Positioned.fill(
            child: _bgImage != null
                ? Image.file(_bgImage!, fit: BoxFit.cover)
                : Image.network(_selectedPresetBg, fit: BoxFit.cover),
          ),

          // Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_selectedUniversity != null) ...[
                  Text(
                    _selectedUniversity['name'].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (_selectedCourse != null) ...[
                  Text(
                    _selectedCourse['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  _offerTextController.text,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 24),

                // Branding Row
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 14,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$_userName • $_referralCode',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // QR Code Overlay
          if (_qrCodeData != null)
            Positioned(
              bottom: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.memory(
                  base64Decode(_qrCodeData!.split(',').last),
                  width: 60,
                  height: 60,
                ),
              ),
            ),

          // App Logo
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'EduConnect',
                style: TextStyle(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizationCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customize Banner',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // University Dropdown
            DropdownButtonFormField<dynamic>(
              initialValue: _selectedUniversity,
              decoration: const InputDecoration(
                labelText: 'Select University',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              items: _universities.map((uni) {
                return DropdownMenuItem(value: uni, child: Text(uni['name']));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedUniversity = val;
                  _loadCourses(val['_id'] ?? val['id']);
                });
              },
            ),

            const SizedBox(height: 12),

            // Course Dropdown
            DropdownButtonFormField<dynamic>(
              initialValue: _selectedCourse,
              decoration: const InputDecoration(
                labelText: 'Select Course',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              items: _courses.map((course) {
                return DropdownMenuItem(
                  value: course,
                  child: Text(course['name']),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedCourse = val),
            ),

            const SizedBox(height: 12),

            // Offer Text
            TextField(
              controller: _offerTextController,
              decoration: const InputDecoration(
                labelText: 'Offer Text',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
              maxLines: 2,
              onChanged: (v) => setState(() {}),
            ),

            const SizedBox(height: 20),

            // Background Selection
            const Text(
              'Background',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _bgImage != null
                              ? AppTheme.primaryBlue
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.add_a_photo, color: Colors.grey),
                    ),
                  ),
                  ..._backendBanners.map((banner) {
                    final url = banner['templateUrl'];
                    return GestureDetector(
                      onTap: () => setState(() {
                        _selectedPresetBg = url;
                        _bgImage = null;
                      }),
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedPresetBg == url
                                ? AppTheme.primaryBlue
                                : Colors.transparent,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
