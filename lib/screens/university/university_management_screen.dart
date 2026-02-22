import 'package:flutter/material.dart';
import 'package:educonnect/config/theme.dart';
import 'package:educonnect/config/constants.dart';
import 'package:educonnect/widgets/app_header.dart';
import 'package:educonnect/widgets/status_badge.dart';
import 'package:educonnect/models/university_model.dart';
import 'package:educonnect/services/university_service.dart';
import 'package:educonnect/screens/university/edit_university_screen.dart';

class UniversityManagementScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const UniversityManagementScreen({super.key, this.scaffoldKey});

  @override
  State<UniversityManagementScreen> createState() =>
      _UniversityManagementScreenState();
}

class _UniversityManagementScreenState
    extends State<UniversityManagementScreen> {
  List<University> _universities = [];
  List<University> _filteredUniversities = [];
  bool _isLoading = true;
  String? _errorMessage;

  String _searchQuery = '';
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadUniversities();
  }

  Future<void> _loadUniversities() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await UniversityService.getUniversities();
      setState(() {
        _universities = data.map((json) => University.fromJson(json)).toList();
        _filterUniversities();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterUniversities() {
    setState(() {
      _filteredUniversities = _universities.where((uni) {
        final matchesSearch =
            uni.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            uni.abbreviation.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesStatus =
            _selectedStatus == 'All' ||
            (uni.isActive ? 'Active' : 'Inactive') == _selectedStatus;
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  Future<void> _toggleUniversityStatus(University university) async {
    try {
      await UniversityService.updateUniversity(university.id, {
        'isActive': !university.isActive,
      });
      _loadUniversities();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'University ${!university.isActive ? 'activated' : 'deactivated'} successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update status: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? _buildErrorState()
                  : _filteredUniversities.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadUniversities,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(
                          AppConstants.defaultPadding / 2,
                        ),
                        itemCount: _filteredUniversities.length,
                        itemBuilder: (context, index) {
                          return _buildUniversityCard(
                            _filteredUniversities[index],
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add university screen (can reuse EditUniversityScreen if modified or a new one)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add University feature coming soon')),
          );
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding / 2),
      color: AppTheme.white,
      child: Column(
        children: [
          AppHeader(
            title: 'University Management',
            showBackButton: false,
            showDrawer: true,
            scaffoldKey: widget.scaffoldKey,
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search universities...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppTheme.lightGray,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _filterUniversities();
              });
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Status: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _selectedStatus,
                items: ['All', 'Active', 'Inactive'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                    _filterUniversities();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUniversityCard(University uni) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        uni.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${uni.abbreviation} • Established ${uni.establishedYear}',
                        style: const TextStyle(
                          color: AppTheme.mediumGray,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: uni.isActive ? 'Active' : 'Inactive'),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 16,
                  color: AppTheme.mediumGray,
                ),
                const SizedBox(width: 8),
                Text(uni.contactEmail, style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  size: 16,
                  color: AppTheme.mediumGray,
                ),
                const SizedBox(width: 8),
                Text(uni.contactPhone, style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _toggleUniversityStatus(uni),
                  icon: Icon(
                    uni.isActive ? Icons.block : Icons.check_circle_outline,
                    size: 18,
                    color: uni.isActive ? AppTheme.error : AppTheme.success,
                  ),
                  label: Text(
                    uni.isActive ? 'Deactivate' : 'Activate',
                    style: TextStyle(
                      color: uni.isActive ? AppTheme.error : AppTheme.success,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditUniversityScreen(university: uni),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                  label: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: $_errorMessage',
            style: const TextStyle(color: AppTheme.error),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadUniversities,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No universities found',
        style: TextStyle(color: AppTheme.mediumGray),
      ),
    );
  }
}
