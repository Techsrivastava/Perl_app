import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/models/university_model.dart';
import 'package:university_app_2/screens/university/edit_university_screen.dart';

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
    _loadUniversityData();
  }

  @override
  void didUpdateWidget(UniversityProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('[didUpdateWidget] Widget updated, reloading data');
    if (_university == null && !_isLoading) {
      _loadUniversityData();
    }
  }

  @override
  void dispose() {
    _isLoading = false;
    super.dispose();
  }

  Future<void> _loadUniversityData() async {
    debugPrint('[_loadUniversityData] Starting to load data...');
    final stopwatch = Stopwatch()..start();

    if (!mounted) return;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

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

      if (!mounted) return;

      setState(() {
        _university = university;
        _isLoading = false;
        _errorMessage = null;
      });
      debugPrint('[_loadUniversityData] Data loaded successfully! (${stopwatch.elapsedMilliseconds}ms)');
    } catch (e, stackTrace) {
      debugPrint('[_loadUniversityData] Error: $e\n$stackTrace');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load data: ${e.toString()}';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().length > 100 ? '${e.toString().substring(0, 100)}...' : e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _loadUniversityData(),
            ),
          ),
        );
      }
    }
  }

  Future<void> _refreshData() async => await _loadUniversityData();

  void _navigateToEditScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditUniversityScreen(university: _university!)),
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

  // Helper Methods Added Below
  Widget _buildQuickInfoCard({required IconData icon, required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSocialMediaButton(IconData icon, String platform, String action, Color color) {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Open respective link
        debugPrint('Opening $platform');
      },
      icon: Icon(icon, size: 20),
      label: Text(action),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDocumentButton(String title, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {
        // TODO: View certificate
      },
      icon: Icon(icon, size: 18),
      label: Text(title),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.primaryBlue,
        side: const BorderSide(color: AppTheme.primaryBlue),
        minimumSize: const Size(double.infinity, 44),
      ),
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
            Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadUniversityData,
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
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
            const Text('No university data available', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadUniversityData,
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
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
        // Header with Logo
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.darkBlue]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(child: Icon(Icons.image, size: 60, color: Colors.white24)),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.white, width: 3),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: const Icon(Icons.school, color: AppTheme.primaryBlue, size: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            university.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (university.abbreviation != null) ...[
                            const SizedBox(height: 4),
                            Text(university.abbreviation!, style: TextStyle(fontSize: 14, color: AppTheme.white.withOpacity(0.95))),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Quick Info Row
        Row(
          children: [
            Expanded(
              child: _buildQuickInfoCard(
                icon: Icons.calendar_today,
                label: 'Established',
                value: university.establishedYear?.toString() ?? 'N/A',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickInfoCard(
                icon: Icons.category,
                label: 'Type',
                value: university.type ?? 'N/A',
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Social Media Links
        _buildInfoCard(
          title: 'Social Media & Links',
          children: [
            _buildSocialMediaButton(Icons.location_on, 'Google Maps', 'View Location', Colors.red),
            const SizedBox(height: 8),
            _buildSocialMediaButton(Icons.facebook, 'Facebook', 'Visit Page', const Color(0xFF1877F2)),
            const SizedBox(height: 8),
            _buildSocialMediaButton(Icons.tag, 'Twitter/X', 'Follow Us', const Color(0xFF1DA1F2)),
            const SizedBox(height: 8),
            _buildSocialMediaButton(Icons.work, 'LinkedIn', 'Connect', const Color(0xFF0A66C2)),
            const SizedBox(height: 8),
            _buildSocialMediaButton(Icons.camera_alt, 'Instagram', 'Follow', const Color(0xFFE4405F)),
          ],
        ),

        // Entrance Test Info
        _buildInfoCard(
          title: 'Entrance Test Information',
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.assignment, color: Colors.amber.shade700, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('University Entrance Test', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.charcoal)),
                        SizedBox(height: 4),
                        Text('Custom entrance examination required for admission', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Accreditations
        _buildInfoCard(
          title: 'Accreditations & Certificates',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip('NAAC A+', color: Colors.green.shade700),
                _buildChip('UGC Approved', color: Colors.blue.shade700),
                _buildChip('ISO Certified', color: Colors.purple.shade700),
              ],
            ),
            const SizedBox(height: 12),
            _buildDocumentButton('Accreditation Certificate', Icons.verified),
          ],
        ),

        // Authorized Person
        _buildInfoCard(
          title: 'Authorized Person',
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.person, size: 30, color: Colors.grey.shade400),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dr. John Doe', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.charcoal)),
                      SizedBox(height: 4),
                      Text('Registrar', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // University Details
        _buildInfoCard(
          title: 'University Details',
          trailing: IconButton(
            icon: const Icon(Icons.edit, size: 20, color: AppTheme.primaryBlue),
            onPressed: _navigateToEditScreen,
          ),
          children: [
            _buildInfoRow(Icons.account_balance, 'University Name', university.name),
            if (university.abbreviation != null) _buildInfoRow(Icons.short_text, 'Abbreviation', university.abbreviation!),
            if (university.establishedYear != null) _buildInfoRow(Icons.calendar_today, 'Established Year', university.establishedYear.toString()),
            if (university.type != null) _buildInfoRow(Icons.category, 'Type', university.type!),
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
            if (university.contactEmail != null) _buildInfoRow(Icons.email, 'Email', university.contactEmail!),
            if (university.contactPhone != null) _buildInfoRow(Icons.phone, 'Phone', university.contactPhone!),
            if (university.address.isNotEmpty) _buildInfoRow(Icons.location_on, 'Address', university.address),
          ],
        ),

        _buildInfoCard(
          title: 'Bank Details',
          children: [
            if (university.bankName != null) _buildInfoRow(Icons.account_balance, 'Bank Name', university.bankName!),
            if (university.accountNumber != null) _buildInfoRow(Icons.credit_card, 'Account Number', university.accountNumber!),
            if (university.ifscCode != null) _buildInfoRow(Icons.qr_code, 'IFSC Code', university.ifscCode!),
            if (university.branch != null) _buildInfoRow(Icons.business, 'Branch', university.branch!),
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
              Wrap(spacing: 8, runSpacing: 8, children: university.facilities.map(_buildChip).toList()),
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

  Widget _buildInfoCard({required String title, required List<Widget> children, Widget? trailing}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
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
                Text(documentName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.charcoal), maxLines: 1, overflow: TextOverflow.ellipsis),
                const Text('PDF Document', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download, size: 20),
            onPressed: () {}, // TODO: Implement download
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