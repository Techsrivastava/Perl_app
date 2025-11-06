import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/custom_button.dart';
import 'package:university_app_2/models/university_model.dart';
import 'package:university_app_2/services/mock_data_service.dart';
import 'package:university_app_2/screens/university/edit_university_screen.dart';

class UniversityProfileScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const UniversityProfileScreen({super.key, this.scaffoldKey});

  @override
  State<UniversityProfileScreen> createState() =>
      _UniversityProfileScreenState();
}

class _UniversityProfileScreenState extends State<UniversityProfileScreen> {
  final mockData = MockDataService();
  late University university;

  @override
  void initState() {
    super.initState();
    university = mockData.university;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppHeader(
        title: 'University Profile',
        showBackButton: false,
        showDrawer: true,
        scaffoldKey: widget.scaffoldKey,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
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
                              university.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              university.abbreviation,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Hero(
                        tag: 'university_logo',
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppTheme.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(
                              color: AppTheme.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.school,
                            color: AppTheme.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildHeaderChip(
                        Icons.calendar_today,
                        'Est. ${university.establishedYear}',
                      ),
                      _buildHeaderChip(Icons.business, university.type),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Basic Information
                _buildInfoCard(
                  title: 'Basic Information',
                  children: [
                    _buildInfoListTile(
                      'Institution Type',
                      'University',
                      Icons.school,
                    ),
                    _buildInfoListTile(
                      'University Name',
                      university.name,
                      Icons.account_balance,
                    ),
                    _buildInfoListTile(
                      'Short Name/Abbreviation',
                      university.abbreviation,
                      Icons.label_outline,
                    ),
                    _buildInfoListTile(
                      'Established Year',
                      university.establishedYear.toString(),
                      Icons.calendar_today,
                    ),
                    _buildInfoListTile(
                      'University Type',
                      university.type,
                      Icons.business,
                    ),
                  ],
                ),

                // Accounts Detail
                _buildInfoCard(
                  title: 'Accounts Detail',
                  children: [
                    _buildInfoListTile(
                      'Bank Name',
                      university.bankName ?? 'N/A',
                      Icons.account_balance_wallet,
                    ),
                    _buildInfoListTile(
                      'Account Number',
                      university.accountNumber ?? 'N/A',
                      Icons.credit_card,
                    ),
                    _buildInfoListTile(
                      'IFSC Code',
                      university.ifscCode ?? 'N/A',
                      Icons.security,
                    ),
                    _buildInfoListTile(
                      'Branch',
                      university.branch ?? 'N/A',
                      Icons.location_city,
                    ),
                  ],
                ),

                // Recognition & Affiliations
                _buildInfoCard(
                  title: 'Recognition & Affiliations',
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Accreditation Badges',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.charcoal,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildBadge('UGC', AppTheme.success),
                        _buildBadge('AICTE', AppTheme.primaryBlue),
                        _buildBadge('NAAC', AppTheme.warning),
                      ],
                    ),
                  ],
                ),

                // Facilities & Services
                _buildInfoCard(
                  title: 'Facilities & Services',
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Available Facilities',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.charcoal,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: university.facilities
                          .map((facility) => _buildFacilityChip(facility))
                          .toList(),
                    ),
                  ],
                ),

                // Contact Information
                _buildInfoCard(
                  title: 'Contact Information',
                  children: [
                    _buildInfoListTile(
                      'Email',
                      university.contactEmail,
                      Icons.email,
                      isSelectable: true,
                    ),
                    _buildInfoListTile(
                      'Phone',
                      university.contactPhone,
                      Icons.phone,
                      isSelectable: true,
                    ),
                    _buildInfoListTile(
                      'Address',
                      university.address,
                      Icons.location_on,
                      isSelectable: true,
                    ),
                  ],
                ),

                // Documents & Certificates
                _buildInfoCard(
                  title: 'Documents & Certificates',
                  children: [
                    if (university.documents.isEmpty)
                      const ListTile(
                        leading: Icon(
                          Icons.folder_open,
                          color: AppTheme.mediumGray,
                        ),
                        title: Text(
                          'No documents uploaded',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.mediumGray,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    else
                      ...university.documents.map(
                        (doc) => _buildDocumentListTile(doc),
                      ),
                  ],
                ),

                // Description
                _buildInfoCard(
                  title: 'Description',
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        university.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.charcoal,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),

                // Admission Information (ExpansionTile)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      leading: const Icon(
                        Icons.school,
                        color: AppTheme.primaryBlue,
                      ),
                      title: const Text(
                        'Admission Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.charcoal,
                        ),
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        _buildInfoListTile(
                          'Eligibility Requirements',
                          'High School Diploma or equivalent',
                          Icons.check_circle_outline,
                        ),
                        _buildInfoListTile(
                          'Application Process',
                          'Online application with required documents',
                          Icons.web,
                        ),
                        _buildInfoListTile(
                          'Important Dates',
                          'Fall: Aug 15, Spring: Jan 15',
                          Icons.event,
                        ),
                        _buildInfoListTile(
                          'Contact for Admissions',
                          university.contactEmail,
                          Icons.email_outlined,
                        ),
                      ],
                    ),
                  ),
                ),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: 'Edit University Profile',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditUniversityScreen(university: university),
                        ),
                      );
                    },
                    icon: Icons.edit,
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
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
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoListTile(
    String title,
    String subtitle,
    IconData icon, {
    bool isSelectable = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue, size: 20),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.mediumGray,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.charcoal,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: isSelectable
          ? const Icon(Icons.chevron_right, color: AppTheme.mediumGray)
          : null,
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildFacilityChip(String facility) {
    return Chip(
      avatar: const Icon(Icons.check_circle, color: AppTheme.success, size: 16),
      label: Text(
        facility,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.charcoal,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: AppTheme.lightGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildDocumentListTile(String document) {
    return ListTile(
      leading: const Icon(
        Icons.description,
        color: AppTheme.primaryBlue,
        size: 20,
      ),
      title: Text(
        document,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.charcoal,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Downloading $document...'),
              backgroundColor: AppTheme.primaryBlue,
            ),
          );
        },
        icon: const Icon(Icons.download, color: AppTheme.primaryBlue),
      ),
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
