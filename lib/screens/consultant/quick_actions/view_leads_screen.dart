import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class ViewLeadsScreen extends StatefulWidget {
  const ViewLeadsScreen({super.key});

  @override
  State<ViewLeadsScreen> createState() => _ViewLeadsScreenState();
}

class _ViewLeadsScreenState extends State<ViewLeadsScreen> {
  String _statusFilter = 'All';
  String _sourceFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _leads = [
    {
      'id': 'L001',
      'name': 'Rahul Sharma',
      'course': 'MBA in Marketing',
      'university': 'Dehradun Business School',
      'source': 'App',
      'agent': 'Priya Gupta',
      'status': 'Pending',
      'date': '2025-01-05',
      'phone': '9876543210',
    },
    {
      'id': 'L002',
      'name': 'Priya Singh',
      'course': 'B.Tech CSE',
      'university': 'Tech University Dehradun',
      'source': 'Manual',
      'agent': 'Unassigned',
      'status': 'In Progress',
      'date': '2025-01-04',
      'phone': '9876543211',
    },
    {
      'id': 'L003',
      'name': 'Amit Kumar',
      'course': 'BBA',
      'university': 'Commerce College',
      'source': 'Admin',
      'agent': 'Raj Kumar',
      'status': 'Converted',
      'date': '2025-01-03',
      'phone': '9876543212',
    },
  ];

  List<Map<String, dynamic>> get _filteredLeads {
    return _leads.where((lead) {
      // Status filter
      if (_statusFilter != 'All' && lead['status'] != _statusFilter)
        return false;
      // Source filter
      if (_sourceFilter != 'All' && lead['source'] != _sourceFilter)
        return false;
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return lead['name'].toLowerCase().contains(query) ||
               lead['course'].toLowerCase().contains(query) ||
               lead['university'].toLowerCase().contains(query) ||
               lead['id'].toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: _showAddLeadDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Lead'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Modern Stats Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: _buildModernStatCard(
                    'Total',
                    '${_leads.length}',
                    AppTheme.primaryBlue,
                    Icons.list_alt,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModernStatCard(
                    'Pending',
                    '${_leads.where((l) => l['status'] == 'Pending').length}',
                    AppTheme.warning,
                    Icons.pending,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModernStatCard(
                    'Converted',
                    '${_leads.where((l) => l['status'] == 'Converted').length}',
                    AppTheme.success,
                    Icons.check_circle,
                  ),
                ),
              ],
            ),
          ),

          // Modern Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', _statusFilter == 'All', () {
                        setState(() => _statusFilter = 'All');
                      }),
                      _buildFilterChip('Pending', _statusFilter == 'Pending', () {
                        setState(() => _statusFilter = 'Pending');
                      }),
                      _buildFilterChip('In Progress', _statusFilter == 'In Progress', () {
                        setState(() => _statusFilter = 'In Progress');
                      }),
                      _buildFilterChip('Converted', _statusFilter == 'Converted', () {
                        setState(() => _statusFilter = 'Converted');
                      }),
                      _buildFilterChip('Dropped', _statusFilter == 'Dropped', () {
                        setState(() => _statusFilter = 'Dropped');
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Modern Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Search leads by name, course, university...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.mediumGray),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Results count
          if (_searchQuery.isNotEmpty || _statusFilter != 'All')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${_filteredLeads.length} ${_filteredLeads.length == 1 ? 'lead' : 'leads'} found',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.mediumGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(height: 8),

          // Modern Leads List
          Expanded(
            child: _filteredLeads.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.lightGray,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.inbox_outlined,
                            size: 48,
                            color: AppTheme.mediumGray,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No leads found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(
                            color: AppTheme.mediumGray,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredLeads.length,
                    itemBuilder: (context, index) =>
                        _buildModernLeadCard(_filteredLeads[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.charcoal,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkGray,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppTheme.primaryBlue : const Color(0xFFE5E7EB),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppTheme.darkGray,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernLeadCard(Map<String, dynamic> lead) {
    Color statusColor;
    switch (lead['status']) {
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'In Progress':
        statusColor = Colors.blue;
        break;
      case 'Converted':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: InkWell(
        onTap: () => _showLeadDetails(lead),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      lead['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.charcoal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      lead['status'],
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                lead['id'],
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.mediumGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              _buildModernInfoRow(Icons.school_outlined, lead['course']),
              const SizedBox(height: 10),
              _buildModernInfoRow(Icons.business_outlined, lead['university']),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildModernInfoRow(Icons.person_outline, lead['agent'])),
                  const SizedBox(width: 12),
                  Expanded(child: _buildModernInfoRow(Icons.source_outlined, lead['source'])),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFF3F4F6), width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 14, color: AppTheme.mediumGray),
                        const SizedBox(width: 6),
                        Text(
                          lead['date'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.mediumGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildModernActionButton(
                          Icons.edit_outlined,
                          AppTheme.primaryBlue,
                          () => _showEditDialog(lead),
                        ),
                        const SizedBox(width: 8),
                        _buildModernActionButton(
                          Icons.delete_outline,
                          AppTheme.error,
                          () => _showDeleteDialog(lead),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.darkGray),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.darkGray,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildModernActionButton(IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        color: color,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      ),
    );
  }

  void _showLeadDetails(Map<String, dynamic> lead) {
    Color statusColor;
    switch (lead['status']) {
      case 'Pending':
        statusColor = AppTheme.warning;
        break;
      case 'In Progress':
        statusColor = AppTheme.info;
        break;
      case 'Converted':
        statusColor = AppTheme.success;
        break;
      default:
        statusColor = AppTheme.error;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lead['id'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: statusColor),
                            ),
                            child: Text(
                              lead['status'],
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        lead['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Details
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.charcoal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildModernDetailRow(Icons.phone_outlined, 'Phone', lead['phone']),
                      const SizedBox(height: 12),
                      _buildModernDetailRow(Icons.email_outlined, 'Email', lead['email'] ?? 'Not provided'),
                      
                      const SizedBox(height: 24),
                      const Text(
                        'Academic Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.charcoal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildModernDetailRow(Icons.school_outlined, 'Course', lead['course']),
                      const SizedBox(height: 12),
                      _buildModernDetailRow(Icons.business_outlined, 'University', lead['university']),
                      
                      const SizedBox(height: 24),
                      const Text(
                        'Lead Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.charcoal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildModernDetailRow(Icons.person_outline, 'Agent', lead['agent']),
                      const SizedBox(height: 12),
                      _buildModernDetailRow(Icons.source_outlined, 'Source', lead['source']),
                      const SizedBox(height: 12),
                      _buildModernDetailRow(Icons.calendar_today_outlined, 'Date', lead['date']),
                      
                      const SizedBox(height: 24),
                      
                      // Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ),
                          if (lead['status'] == 'In Progress') ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    lead['status'] = 'Converted';
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Lead converted to admission!'),
                                      backgroundColor: AppTheme.success,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.check_circle_outline, size: 18),
                                label: const Text('Convert'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.success,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.lightGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppTheme.primaryBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.mediumGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  void _showAddLeadDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    String selectedCourse = 'MBA in Marketing';
    String selectedUniversity = 'Dehradun Business School';
    String selectedAgent = 'Unassigned';
    String selectedSource = 'App';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add New Lead',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.charcoal,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Student Name
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Student Name *',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      // Phone
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number *',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      // Email
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      
                      // Course Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedCourse,
                        decoration: const InputDecoration(
                          labelText: 'Course',
                          prefixIcon: Icon(Icons.school_outlined),
                        ),
                        isExpanded: true,
                        items: [
                          'MBA in Marketing',
                          'B.Tech CSE',
                          'BBA',
                          'M.Tech',
                          'B.Com',
                        ].map((course) => DropdownMenuItem(
                          value: course,
                          child: Text(
                            course,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )).toList(),
                        onChanged: (value) {
                          setDialogState(() => selectedCourse = value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // University Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedUniversity,
                        decoration: const InputDecoration(
                          labelText: 'University',
                          prefixIcon: Icon(Icons.business_outlined),
                        ),
                        isExpanded: true,
                        items: [
                          'Dehradun Business School',
                          'Tech University Dehradun',
                          'Commerce College',
                        ].map((uni) => DropdownMenuItem(
                          value: uni,
                          child: Text(
                            uni,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )).toList(),
                        onChanged: (value) {
                          setDialogState(() => selectedUniversity = value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Agent Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedAgent,
                        decoration: const InputDecoration(
                          labelText: 'Assign to Agent',
                          prefixIcon: Icon(Icons.person_add_outlined),
                        ),
                        isExpanded: true,
                        items: [
                          'Unassigned',
                          'Priya Gupta',
                          'Raj Kumar',
                          'Amit Verma',
                        ].map((agent) => DropdownMenuItem(
                          value: agent,
                          child: Text(
                            agent,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )).toList(),
                        onChanged: (value) {
                          setDialogState(() => selectedAgent = value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Source Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedSource,
                        decoration: const InputDecoration(
                          labelText: 'Lead Source',
                          prefixIcon: Icon(Icons.source_outlined),
                        ),
                        isExpanded: true,
                        items: ['App', 'Manual', 'Admin', 'Website']
                            .map((source) => DropdownMenuItem(
                              value: source,
                              child: Text(
                                source,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() => selectedSource = value!);
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    _leads.insert(0, {
                                      'id': 'L${_leads.length + 1}'.padLeft(4, '0'),
                                      'name': nameController.text,
                                      'course': selectedCourse,
                                      'university': selectedUniversity,
                                      'source': selectedSource,
                                      'agent': selectedAgent,
                                      'status': 'Pending',
                                      'date': DateTime.now().toString().split(' ')[0],
                                      'phone': phoneController.text,
                                      'email': emailController.text,
                                    });
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Lead added successfully!'),
                                      backgroundColor: AppTheme.success,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Add Lead'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> lead) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: lead['name']);
    final phoneController = TextEditingController(text: lead['phone']);
    String selectedStatus = lead['status'];
    String selectedAgent = lead['agent'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit Lead ${lead['id']}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.charcoal,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Student Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<String>(
                        value: selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          prefixIcon: Icon(Icons.flag_outlined),
                        ),
                        isExpanded: true,
                        items: ['Pending', 'In Progress', 'Converted', 'Dropped']
                            .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(
                                status,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() => selectedStatus = value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<String>(
                        value: selectedAgent,
                        decoration: const InputDecoration(
                          labelText: 'Agent',
                          prefixIcon: Icon(Icons.person_add_outlined),
                        ),
                        isExpanded: true,
                        items: ['Unassigned', 'Priya Gupta', 'Raj Kumar', 'Amit Verma']
                            .map((agent) => DropdownMenuItem(
                              value: agent,
                              child: Text(
                                agent,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() => selectedAgent = value!);
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    lead['name'] = nameController.text;
                                    lead['phone'] = phoneController.text;
                                    lead['status'] = selectedStatus;
                                    lead['agent'] = selectedAgent;
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Lead updated successfully!'),
                                      backgroundColor: AppTheme.success,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Save Changes'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> lead) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lead'),
        content: Text(
          'Are you sure you want to delete lead ${lead['id']} - ${lead['name']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _leads.remove(lead));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lead deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
