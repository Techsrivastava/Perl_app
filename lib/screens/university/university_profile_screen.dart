import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/models/university_model.dart';
import 'package:university_app_2/screens/university/university_signup_screen.dart';

class UniversityProfileScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const UniversityProfileScreen({super.key, this.scaffoldKey});

  @override
  State<UniversityProfileScreen> createState() => _UniversityProfileScreenState();
}

class _UniversityProfileScreenState extends State<UniversityProfileScreen> {
  University? _university;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    debugPrint('[initState] Initializing UniversityProfileScreen');
    // Load data immediately
    _loadUniversityData();
  }

  @override
  void didUpdateWidget(UniversityProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('[didUpdateWidget] Widget updated, reloading data');
    // Reload data when widget updates (useful for hot reload)
    if (_university == null && !_isLoading) {
      _loadUniversityData();
    }
  }

  @override
  void dispose() {
    // Cancel any pending operations
    _isLoading = false;
    super.dispose();
  }

  Future<void> _loadUniversityData() async {
    debugPrint('[_loadUniversityData] Starting to load data...');
    final stopwatch = Stopwatch()..start();
    
    if (!mounted) {
      debugPrint('[_loadUniversityData] Not mounted, returning early');
      return;
    }

    try {
      // Set loading state
      debugPrint('[_loadUniversityData] Setting loading state to true');
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      debugPrint('[_loadUniversityData] Starting data fetch');
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      debugPrint('[_loadUniversityData] Network delay complete (${stopwatch.elapsedMilliseconds}ms)');

      if (!mounted) return;

      debugPrint('[_loadUniversityData] Creating University object');
      // Create the University object directly
      final university = University(
        id: '1',
        name: 'Sample University',
        abbreviation: 'SU',
        establishedYear: 2000,
        type: 'Private',
        facilities: const ['Library', 'Sports', 'Cafeteria', 'Computer Lab', 'Auditorium'],
        documents: const ['Prospectus.pdf', 'Fee_Structure.pdf', 'Brochure.pdf'],
        description: 'A leading educational institution committed to excellence in education and research. We provide world-class facilities and experienced faculty to nurture future leaders.',
        contactEmail: 'info@sampleuniv.edu',
        contactPhone: '+1234567890',
        address: '123 University Ave, City, Country',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        bankName: 'Sample Bank',
        accountNumber: '1234567890',
        ifscCode: 'SBIN0001234',
        branch: 'Main Branch',
      );

      debugPrint('[_loadUniversityData] University object created successfully');

      if (!mounted) {
        debugPrint('[_loadUniversityData] Not mounted after data creation, returning');
        return;
      }

      debugPrint('[_loadUniversityData] Updating UI with new data (${stopwatch.elapsedMilliseconds}ms)');
      setState(() {
        _university = university;
        _isLoading = false;
        _errorMessage = null;
      });
      debugPrint('[_loadUniversityData] ✅ Data loaded successfully! (${stopwatch.elapsedMilliseconds}ms)');
    } catch (e, stackTrace) {
      debugPrint('[_loadUniversityData] ❌ Error loading university data (${stopwatch.elapsedMilliseconds}ms): $e');
      debugPrint('[_loadUniversityData] Stack trace: $stackTrace');
      
      if (!mounted) return;
      
      // Always ensure we're not stuck in loading state
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load university data. Error: ${e.toString()}';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().length > 100 ? e.toString().substring(0, 100) + '...' : e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                if (mounted) {
                  _loadUniversityData();
                }
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadUniversityData();
  }

  void _navigateToEditScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const UniversitySignupScreen()),
    );

    if (result == true && mounted) {
      await _refreshData();
    }
  }

  Widget _buildChip(String label, {Color? color}) {
    return Chip(
      label: Text(label, style: TextStyle(color: color ?? AppTheme.white, fontSize: 12)),
      backgroundColor: (color ?? AppTheme.primaryBlue).withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[build] Building UniversityProfileScreen - isLoading: $_isLoading, hasData: ${_university != null}');
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text('University Profile'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        actions: [
          if (!_isLoading && _university != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _navigateToEditScreen,
              tooltip: 'Edit Profile',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadUniversityData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_university == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No university data available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadUniversityData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Load Data'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final university = _university!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.darkBlue]),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          university.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (university.abbreviation case final abbr?) ...[
                          const SizedBox(height: 4),
                          Text(abbr, style: TextStyle(fontSize: 16, color: AppTheme.white.withOpacity(0.9))),
                        ],
                        if (university.type case final type?) ...[
                          const SizedBox(height: 8),
                          Text(type, style: TextStyle(fontSize: 14, color: AppTheme.white.withOpacity(0.85))),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Hero(
                    tag: 'university_logo',
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.white.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.school, color: AppTheme.white, size: 40),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (university.establishedYear case final year?) _buildChip('Est. $year'),
                  if (university.contactPhone case final phone?) _buildChip(phone),
                  if (university.contactEmail case final email?) _buildChip(email),
                ],
              ),
              if (university.address.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        university.address,
                        style: TextStyle(color: AppTheme.white.withOpacity(0.9), fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Info Cards
        _buildInfoCard(
          title: 'University Details',
          trailing: IconButton(
            icon: const Icon(Icons.edit, size: 20, color: AppTheme.primaryBlue),
            onPressed: _navigateToEditScreen,
          ),
          children: [
            _buildInfoRow(Icons.account_balance, 'University Name', university.name),
            if (university.abbreviation case final abbr?) _buildInfoRow(Icons.short_text, 'Abbreviation', abbr),
            if (university.establishedYear case final year?) _buildInfoRow(Icons.calendar_today, 'Established Year', year.toString()),
            if (university.type case final type?) _buildInfoRow(Icons.category, 'Type', type),
            if (university.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('About', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(university.description, style: const TextStyle(fontSize: 14, color: AppTheme.charcoal, height: 1.5)),
            ],
          ],
        ),

        _buildInfoCard(
          title: 'Contact Information',
          children: [
            if (university.contactEmail case final email?) _buildInfoRow(Icons.email, 'Email', email),
            if (university.contactPhone case final phone?) _buildInfoRow(Icons.phone, 'Phone', phone),
            if (university.address.isNotEmpty) _buildInfoRow(Icons.location_on, 'Address', university.address),
          ],
        ),

        _buildInfoCard(
          title: 'Bank Details',
          children: [
            if (university.bankName case final bank?) _buildInfoRow(Icons.account_balance, 'Bank Name', bank),
            if (university.accountNumber case final acc?) _buildInfoRow(Icons.credit_card, 'Account Number', acc),
            if (university.ifscCode case final ifsc?) _buildInfoRow(Icons.qr_code, 'IFSC Code', ifsc),
            if (university.branch case final branch?) _buildInfoRow(Icons.business, 'Branch', branch),
            if (university.bankName == null && university.accountNumber == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No bank details added yet', style: TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic)),
              ),
          ],
        ),

        if (university.facilities.isNotEmpty)
          _buildInfoCard(
            title: 'Facilities',
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: university.facilities.map(_buildChip).toList(),
              ),
            ],
          ),

        _buildInfoCard(
          title: 'Documents',
          children: university.documents.isEmpty
              ? [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('No documents uploaded yet', style: TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic)),
                  ),
                ]
              : university.documents.map(_buildDocumentItem).toList(),
        ),

        _buildInfoCard(
          title: 'Additional Information',
          children: [
            _buildInfoRow(Icons.date_range, 'Created', DateFormat('MMM dd, yyyy').format(university.createdAt)),
            _buildInfoRow(Icons.update, 'Last Updated', DateFormat('MMM dd, yyyy').format(university.updatedAt)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
    Widget? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.charcoal)),
                if (trailing != null) trailing,
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 14, color: AppTheme.charcoal)),
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String documentName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  documentName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.charcoal),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text('PDF Document', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download, size: 20),
            onPressed: () {}, // TODO: Download
            color: AppTheme.primaryBlue,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Download $documentName',
          ),
        ],
      ),
    );
  }
}