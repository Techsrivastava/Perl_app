import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/models/course_model.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/services/mock_data_service.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final mockData = MockDataService();

  // Step tracking
  int _currentStep = 1; // 1: Category, 2: Branches, 3: Courses

  // Step 1: Category Selection
  String? _selectedCategory;
  final List<String> _categories = [
    'B.Tech',
    'B.Sc',
    'B.A',
    'B.Com',
    'M.Tech',
    'MBA',
  ];

  // Step 2: Branch Selection
  List<String> _selectedBranches = [];

  // Step 3: Courses from Database
  List<Course> _selectedCourses = [];
  bool _isLoading = false;

  Map<int, TextEditingController> _courseNameControllers = {};
  Map<int, TextEditingController> _courseCodeControllers = {};
  Map<int, TextEditingController> _courseDurationControllers = {};
  Map<int, TextEditingController> _courseDescriptionControllers = {};
  Map<int, TextEditingController> _courseFeesControllers = {};
  Map<int, TextEditingController> _courseTotalSeatsControllers = {};
  Map<int, TextEditingController> _courseAvailableSeatsControllers = {};
  Map<int, TextEditingController> _courseEligibilityControllers = {};

  @override
  void dispose() {
    for (var controller in _courseNameControllers.values) {
      controller.dispose();
    }
    for (var controller in _courseCodeControllers.values) {
      controller.dispose();
    }
    for (var controller in _courseDurationControllers.values) {
      controller.dispose();
    }
    for (var controller in _courseDescriptionControllers.values) {
      controller.dispose();
    }
    for (var controller in _courseFeesControllers.values) {
      controller.dispose();
    }
    for (var controller in _courseTotalSeatsControllers.values) {
      controller.dispose();
    }
    for (var controller in _courseAvailableSeatsControllers.values) {
      controller.dispose();
    }
    for (var controller in _courseEligibilityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _proceedFromCategory() {
    if (_selectedCategory == null) {
      _showSnackBar('Please select a category', Colors.orange);
      return;
    }
    setState(() => _currentStep = 2);
  }

  void _proceedFromBranches() {
    if (_selectedBranches.isEmpty) {
      _showSnackBar('Please select at least one branch', Colors.orange);
      return;
    }
    _loadCoursesFromDatabase();
  }

  void _loadCoursesFromDatabase() {
    setState(() => _isLoading = true);

    // Simulate loading from database
    Future.delayed(const Duration(milliseconds: 800), () {
      final allCourses = mockData.courses;

      // Filter courses by selected category and branches
      final filteredCourses = allCourses
          .where(
            (course) =>
                course.degreeType == _selectedCategory &&
                _selectedBranches.contains(course.department),
          )
          .toList();

      setState(() {
        _selectedCourses = filteredCourses;
        _isLoading = false;
        _currentStep = 3;

        // Initialize text controllers for each course
        for (int i = 0; i < _selectedCourses.length; i++) {
          _courseNameControllers[i] = TextEditingController(
            text: _selectedCourses[i].name ?? '',
          );
          _courseCodeControllers[i] = TextEditingController(
            text: _selectedCourses[i].code ?? '',
          );
          _courseDurationControllers[i] = TextEditingController(
            text: _selectedCourses[i].duration ?? '',
          );
          _courseDescriptionControllers[i] = TextEditingController(
            text: _selectedCourses[i].description ?? '',
          );
          _courseFeesControllers[i] = TextEditingController(
            text: (_selectedCourses[i].fees ?? 0).toString(),
          );
          _courseTotalSeatsControllers[i] = TextEditingController(
            text: (_selectedCourses[i].totalSeats ?? 0).toString(),
          );
          _courseAvailableSeatsControllers[i] = TextEditingController(
            text: (_selectedCourses[i].availableSeats ?? 0).toString(),
          );
          _courseEligibilityControllers[i] = TextEditingController(
            text: (_selectedCourses[i].eligibility ?? []).join(', '),
          );
        }
      });
    });
  }

  void _handleSaveDraft() async {
    setState(() => _isLoading = true);
    
    // Update courses with modified data
    _updateCoursesFromControllers();
    
    // Simulate saving to database
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      _showSnackBar('${_selectedCourses.length} courses saved as draft', const Color(0xFF3B82F6));
      Navigator.pop(context);
    }
  }

  void _handlePublish() async {
    if (_selectedCourses.isEmpty) {
      _showSnackBar('No courses to publish', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);
    
    // Update courses with modified data
    _updateCoursesFromControllers();
    
    // Simulate publishing to database
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      _showSnackBar('${_selectedCourses.length} courses published successfully', const Color(0xFF10B981));
      Navigator.pop(context);
    }
  }

  void _updateCoursesFromControllers() {
    for (int i = 0; i < _selectedCourses.length; i++) {
      _selectedCourses[i].name = _courseNameControllers[i]?.text;
      _selectedCourses[i].code = _courseCodeControllers[i]?.text;
      _selectedCourses[i].duration = _courseDurationControllers[i]?.text;
      _selectedCourses[i].description = _courseDescriptionControllers[i]?.text;
      _selectedCourses[i].fees = double.tryParse(_courseFeesControllers[i]?.text ?? '0') ?? 0;
      _selectedCourses[i].totalSeats = int.tryParse(_courseTotalSeatsControllers[i]?.text ?? '0') ?? 0;
      _selectedCourses[i].availableSeats = int.tryParse(_courseAvailableSeatsControllers[i]?.text ?? '0') ?? 0;
      
      // Parse eligibility from comma-separated string
      final eligibilityText = _courseEligibilityControllers[i]?.text ?? '';
      if (eligibilityText.isNotEmpty) {
        _selectedCourses[i].eligibility = eligibilityText
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      
      _selectedCourses[i].updatedAt = DateTime.now();
    }
  }

  void _showSnackBar(String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    if (_currentStep == 1) {
      return _buildCategoryStep(isSmallScreen);
    } else if (_currentStep == 2) {
      return _buildBranchStep(isSmallScreen);
    } else {
      return _buildCoursesStep(isSmallScreen);
    }
  }

  Widget _buildCategoryStep(bool isSmallScreen) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const AppHeader(title: 'Add Courses'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.category_rounded,
                      size: 64,
                      color: AppTheme.primaryBlue,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Course Category',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose the degree type you want to add courses for',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.2,
                          ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = category),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryBlue
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              color: isSelected
                                  ? AppTheme.primaryBlue.withOpacity(0.1)
                                  : Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.school_rounded,
                                  size: 40,
                                  color: isSelected
                                      ? AppTheme.primaryBlue
                                      : Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppTheme.primaryBlue
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _proceedFromCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Proceed to Branches',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchStep(bool isSmallScreen) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Select Branches'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_tree_rounded,
                      size: 64,
                      color: AppTheme.primaryBlue,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select Branches for $_selectedCategory',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose one or more branches',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: AppConstants.departments.length,
                      itemBuilder: (context, index) {
                        final branch = AppConstants.departments[index];
                        final isSelected = _selectedBranches.contains(branch);
                        return CheckboxListTile(
                          title: Text(
                            branch,
                            style: const TextStyle(fontSize: 16),
                          ),
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedBranches.add(branch);
                              } else {
                                _selectedBranches.remove(branch);
                              }
                            });
                          },
                          activeColor: AppTheme.primaryBlue,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentStep = 1),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _proceedFromBranches,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Load Courses',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesStep(bool isSmallScreen) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('${_selectedCourses.length} Courses'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Draft',
            onPressed: _isLoading ? null : _handleSaveDraft,
          ),
          IconButton(
            icon: const Icon(Icons.publish),
            tooltip: 'Publish',
            onPressed: _isLoading ? null : _handlePublish,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _selectedCourses.isEmpty
          ? Center(
              child: Text(
                'No courses found for selected category and branches',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.list_alt,
                            color: AppTheme.primaryBlue,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_selectedCourses.length} Courses from Database',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Modify details and save or publish',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _selectedCourses.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final course = _selectedCourses[index];
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryBlue.withOpacity(
                              0.1,
                            ),
                            child: Icon(
                              Icons.book,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          title: Text(
                            _courseNameControllers[index]?.text ??
                                course.name ??
                                'Untitled',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.department ?? 'NA',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _courseCodeControllers[index]?.text ??
                                    course.code ??
                                    'No Code',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _courseNameControllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Course Name',
                                      prefixIcon: const Icon(Icons.book),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _courseCodeControllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Course Code',
                                      prefixIcon: const Icon(Icons.code),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _courseDurationControllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Duration',
                                      prefixIcon: const Icon(Icons.access_time),
                                      hintText: 'e.g., 4 years',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _courseDescriptionControllers[index],
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      prefixIcon: const Icon(Icons.description),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _courseFeesControllers[index],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Annual Fees',
                                      prefixIcon: const Icon(Icons.attach_money),
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
                                          controller: _courseTotalSeatsControllers[index],
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Total Seats',
                                            prefixIcon: const Icon(Icons.event_seat),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: _courseAvailableSeatsControllers[index],
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Available Seats',
                                            prefixIcon: const Icon(Icons.event_available),
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
                                    controller: _courseEligibilityControllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Eligibility (comma-separated)',
                                      prefixIcon: const Icon(Icons.checklist),
                                      hintText: 'e.g., High School Diploma, SAT 1400+',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SwitchListTile(
                                          title: const Text('Active'),
                                          value: course.isActive ?? true,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedCourses[index].isActive = value;
                                            });
                                          },
                                          activeColor: AppTheme.primaryBlue,
                                        ),
                                      ),
                                      Expanded(
                                        child: SwitchListTile(
                                          title: const Text('Scholarship'),
                                          value: course.scholarshipAvailable ?? false,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedCourses[index].scholarshipAvailable = value;
                                            });
                                          },
                                          activeColor: AppTheme.primaryBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _currentStep = 2),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: AppTheme.primaryBlue),
                          ),
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleSaveDraft,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save Draft',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _handlePublish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Publish All Courses',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
