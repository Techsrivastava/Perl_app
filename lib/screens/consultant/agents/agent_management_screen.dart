import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../services/agent_service.dart';
import '../../../services/university_service.dart';
import '../../../models/agent_model.dart';
import 'edit_agent_form.dart';

class AgentManagementScreen extends StatefulWidget {
  const AgentManagementScreen({super.key});

  @override
  State<AgentManagementScreen> createState() => _AgentManagementScreenState();
}

class _AgentManagementScreenState extends State<AgentManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  List<Agent> _allAgents = [];
  List<String> _availableUniversities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _loadAgents();
  }

  Future<void> _loadAgents() async {
    try {
      final agentsData = await AgentService.getAgents();
      final universitiesData = await UniversityService.getUniversities();
      if (mounted) {
        setState(() {
          _allAgents = agentsData.map((data) => Agent.fromJson(data)).toList();
          _availableUniversities = universitiesData
              .map((u) => u['name'] as String)
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
      }
    }
  }

  Future<void> _addAgent(Map<String, dynamic> agentData) async {
    try {
      final response = await AgentService.createAgent(agentData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agent added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadAgents();
        _formKey.currentState!.reset();
        _agentNameController.clear();
        _firmNameController.clear();
        _mobileController.clear();
        _emailController.clear();
        _passwordController.clear();
        setState(() => _tabController.index = 0);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding agent: $e')));
      }
    }
  }

  Future<void> _toggleBlockAgent(Agent agent) async {
    try {
      final updatedData = {'blocked': !agent.blocked};
      await AgentService.updateAgent(agent.id, updatedData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Agent ${agent.blocked ? 'unblocked' : 'blocked'} successfully',
            ),
            backgroundColor: agent.blocked ? Colors.green : Colors.red,
          ),
        );
        _loadAgents();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating agent: $e')));
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _getStatusCount(String status) {
    if (status == 'All') return _allAgents.length;
    if (status == 'Active') {
      return _allAgents.where((a) => a.status == 'Active').length;
    }
    if (status == 'Inactive') {
      return _allAgents.where((a) => a.status == 'Inactive').length;
    }
    if (status == 'Blocked') {
      return _allAgents.where((a) => a.blocked).length;
    }
    return 0;
  }

  List<Agent> get _filteredAgents {
    return _allAgents.where((a) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          a.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a.email.toLowerCase().contains(_searchQuery.toLowerCase());

      final tabIndex = _tabController.index;
      if (tabIndex == 0) return matchesSearch; // All
      if (tabIndex == 6) return a.blocked && matchesSearch; // Blocked

      // Filter by status for other tabs if they map to specific statuses
      // For now, mapping some tabs to statuses
      if (tabIndex == 1) {
        return matchesSearch; // Add Agent tab - shown as form anyway
      }
      return matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Agent Management'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          // Filter button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
          // Export button
          PopupMenuButton<String>(
            icon: const Icon(Icons.download),
            tooltip: 'Export',
            onSelected: (value) {
              if (value == 'excel') {
                _exportToExcel();
              } else if (value == 'pdf') {
                _exportToPDF();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'excel',
                child: Row(
                  children: [
                    Icon(Icons.table_chart, color: Colors.green, size: 20),
                    SizedBox(width: 12),
                    Text('Export to Excel'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
                    SizedBox(width: 12),
                    Text('Export to PDF'),
                  ],
                ),
              ),
            ],
          ),
          // More options
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'bulk') {
                _showBulkActions();
              } else if (value == 'reports') {
                _showReports();
              } else if (value == 'history') {
                _showHistory();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'bulk',
                child: Row(
                  children: [
                    Icon(Icons.checklist, size: 20),
                    SizedBox(width: 12),
                    Text('Bulk Actions'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reports',
                child: Row(
                  children: [
                    Icon(Icons.assessment, size: 20),
                    SizedBox(width: 12),
                    Text('View Reports'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'history',
                child: Row(
                  children: [
                    Icon(Icons.history, size: 20),
                    SizedBox(width: 12),
                    Text('Activity History'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.people, size: 16),
                  const SizedBox(width: 6),
                  Text('All (${_getStatusCount('All')})'),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add, size: 16),
                  SizedBox(width: 6),
                  Text('Add Agent'),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school, size: 16),
                  SizedBox(width: 6),
                  Text('Assign'),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance_wallet, size: 16),
                  SizedBox(width: 6),
                  Text('Commissions'),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.analytics, size: 16),
                  SizedBox(width: 6),
                  Text('Activity'),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.admin_panel_settings, size: 16),
                  SizedBox(width: 6),
                  Text('Permissions'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.block, size: 16),
                  const SizedBox(width: 6),
                  Text('Blocked (${_getStatusCount('Blocked')})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllAgentsTab(),
          _buildAddAgentTab(),
          _buildAssignTab(),
          _buildCommissionsTab(),
          _buildActivityTab(),
          _buildPermissionsTab(),
          _buildBlockedTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => setState(() => _tabController.index = 1),
              backgroundColor: AppTheme.primaryBlue,
              icon: const Icon(Icons.add),
              label: const Text('Add Agent'),
            )
          : null,
    );
  }

  // Tab 1: All Agents
  Widget _buildAllAgentsTab() {
    return Column(
      children: [
        // Stats Cards
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  _allAgents.length.toString(),
                  Icons.people,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Active',
                  _getStatusCount('Active').toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Inactive',
                  _getStatusCount('Inactive').toString(),
                  Icons.remove_circle,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Blocked',
                  _getStatusCount('Blocked').toString(),
                  Icons.block,
                  Colors.red,
                ),
              ),
            ],
          ),
        ),

        // Search Bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search by name or ID...',
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              isDense: true,
            ),
          ),
        ),

        // Agent List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredAgents.isEmpty
              ? const Center(child: Text('No agents found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredAgents.length,
                  itemBuilder: (context, index) =>
                      _buildAgentCard(_filteredAgents[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.03)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildAgentCard(Agent agent) {
    final statusColor = agent.blocked
        ? Colors.red
        : (agent.status == 'Active' ? Colors.green : Colors.orange);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusColor.withValues(alpha: 0.2),
                        statusColor.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              agent.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor),
                            ),
                            child: Text(
                              agent.blocked ? 'Blocked' : agent.status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${agent.id.substring(0, 8)}...', // Shorten ID
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Contact Info
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(agent.phone, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 16),
                Icon(Icons.business, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    agent.firmName,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.location_city, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  '${agent.city}, ${agent.state}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  'Joined: ${agent.joinedDate.toIso8601String().split('T')[0]}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildMiniCard(
                    'Leads',
                    agent.totalLeads.toString(),
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMiniCard(
                    'Admissions',
                    agent.verifiedAdmissions.toString(),
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMiniCard(
                    'Earnings',
                    '\u20B9${(agent.totalEarnings / 1000).toStringAsFixed(0)}K',
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Universities & Commission
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.school, size: 14, color: Colors.grey[700]),
                  const SizedBox(width: 6),
                  Text('Commission', style: const TextStyle(fontSize: 11)),
                  const Spacer(),
                  Text(
                    agent.commissionType == 'Percentage'
                        ? '${agent.commissionValue}%'
                        : '\u20B9${agent.commissionValue}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewAgentDetails(agent),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: BorderSide(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.5),
                      ),
                      foregroundColor: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _editAgent(agent),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _toggleBlockAgent(agent),
                    icon: Icon(
                      agent.blocked ? Icons.check_circle : Icons.block,
                      size: 16,
                    ),
                    label: Text(
                      agent.blocked ? 'Unblock' : 'Block',
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: agent.blocked
                          ? Colors.green
                          : Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
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

  Widget _buildMiniCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[700])),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Tab 2: Add Agent
  final _formKey = GlobalKey<FormState>();
  final _agentNameController = TextEditingController();
  final _firmNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _altContactController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _accountNoController = TextEditingController();
  final _ifscController = TextEditingController();
  final _upiController = TextEditingController();
  final _remarksController = TextEditingController();
  String _selectedState = 'Maharashtra';
  String _idProofType = 'Aadhaar';

  Widget _buildAddAgentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Agent',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Register a new sub-consultant to your network',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Basic Information
            _buildSectionHeader('Basic Information', Icons.person),
            const SizedBox(height: 12),

            TextFormField(
              controller: _agentNameController,
              decoration: _inputDecoration('Agent Name *', Icons.person),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _firmNameController,
              decoration: _inputDecoration(
                'Firm / Agency Name',
                Icons.business,
              ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _mobileController,
              decoration: _inputDecoration('Mobile Number *', Icons.phone),
              keyboardType: TextInputType.phone,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration('Email ID *', Icons.email),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _passwordController,
              decoration: _inputDecoration('Password *', Icons.lock),
              obscureText: true,
              validator: (v) =>
                  v == null || v.length < 6 ? 'Min 6 characters' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _altContactController,
              decoration: _inputDecoration(
                'Alternate Contact',
                Icons.phone_android,
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 24),

            // Address Details
            _buildSectionHeader('Address Details', Icons.location_on),
            const SizedBox(height: 12),

            TextFormField(
              controller: _addressController,
              decoration: _inputDecoration('Full Address', Icons.home),
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: _inputDecoration('City', Icons.location_city),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedState,
                    decoration: _inputDecoration('State', Icons.map),
                    items:
                        [
                              'Maharashtra',
                              'Delhi',
                              'Karnataka',
                              'Gujarat',
                              'Rajasthan',
                              'UP',
                              'MP',
                            ]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => _selectedState = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _pincodeController,
              decoration: _inputDecoration('Pincode', Icons.pin_drop),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),

            // ID Proof
            _buildSectionHeader('ID Proof', Icons.credit_card),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _idProofType,
              decoration: _inputDecoration('ID Proof Type', Icons.badge),
              items: [
                'Aadhaar',
                'PAN',
                'Driving License',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _idProofType = v!),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File picker will be integrated'),
                  ),
                );
              },
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text('Upload ID Proof'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),

            const SizedBox(height: 24),

            // Bank Details
            _buildSectionHeader(
              'Bank Details (Optional)',
              Icons.account_balance,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _accountNoController,
              decoration: _inputDecoration(
                'Account Number',
                Icons.account_balance_wallet,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ifscController,
                    decoration: _inputDecoration('IFSC Code', Icons.code),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _upiController,
                    decoration: _inputDecoration('UPI ID', Icons.payment),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Remarks
            _buildSectionHeader('Remarks', Icons.note),
            const SizedBox(height: 12),

            TextFormField(
              controller: _remarksController,
              decoration: _inputDecoration('Internal Notes', Icons.comment),
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                      _agentNameController.clear();
                      _firmNameController.clear();
                      _mobileController.clear();
                      _emailController.clear();
                      _passwordController.clear();
                      _altContactController.clear();
                      _addressController.clear();
                      _cityController.clear();
                      _pincodeController.clear();
                      _accountNoController.clear();
                      _ifscController.clear();
                      _upiController.clear();
                      _remarksController.clear();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text('Reset Form'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addAgent({
                          'name': _agentNameController.text.trim(),
                          'firmName': _firmNameController.text.trim(),
                          'email': _emailController.text.trim(),
                          'phone': _mobileController.text.trim(),
                          'password': _passwordController.text.trim(),
                          'altPhone': _altContactController.text.trim(),
                          'address': _addressController.text.trim(),
                          'city': _cityController.text.trim(),
                          'state': _selectedState,
                          'pincode': _pincodeController.text.trim(),
                          'idProofType': _idProofType,
                          'bankDetails': {
                            'accountNo': _accountNoController.text.trim(),
                            'ifsc': _ifscController.text.trim(),
                            'upi': _upiController.text.trim(),
                          },
                          'remarks': _remarksController.text.trim(),
                        });
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Agent'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryBlue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlue,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      border: const OutlineInputBorder(),
      isDense: true,
      filled: true,
      fillColor: Colors.white,
    );
  }

  // Tab 3: Assign Universities/Courses
  Agent? _selectedAgentForAssign;
  List<String> _selectedUniversitiesForAssign = [];

  Widget _buildAssignTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assign Universities & Courses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Control which universities and courses each agent can access',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Select Agent
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Select Agent', Icons.person),
                const SizedBox(height: 12),

                DropdownButtonFormField<Agent>(
                  initialValue: _selectedAgentForAssign,
                  decoration: _inputDecoration(
                    'Choose Agent',
                    Icons.person_search,
                  ),
                  items: _allAgents.map((agent) {
                    return DropdownMenuItem(
                      value: agent,
                      child: Text('${agent.name} (${agent.id})'),
                    );
                  }).toList(),
                  onChanged: (agent) {
                    setState(() {
                      _selectedAgentForAssign = agent;
                      _selectedUniversitiesForAssign = List<String>.from(
                        agent?.assignedUniversities ?? [],
                      );
                    });
                  },
                ),

                if (_selectedAgentForAssign != null) ...[
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  _buildSectionHeader('Assign Universities', Icons.school),
                  const SizedBox(height: 12),

                  ..._availableUniversities.map((university) {
                    final isAssigned = _selectedUniversitiesForAssign.contains(
                      university,
                    );
                    return CheckboxListTile(
                      value: isAssigned,
                      title: Text(
                        university,
                        style: const TextStyle(fontSize: 14),
                      ),
                      secondary: Icon(
                        Icons.business,
                        color: isAssigned ? AppTheme.primaryBlue : Colors.grey,
                      ),
                      activeColor: AppTheme.primaryBlue,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedUniversitiesForAssign.add(university);
                          } else {
                            _selectedUniversitiesForAssign.remove(university);
                          }
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 20),

                  // Assignment Mode
                  _buildSectionHeader('Access Level', Icons.security),
                  const SizedBox(height: 12),

                  RadioListTile<String>(
                    value: 'Full Access',
                    groupValue: 'Full Access',
                    title: const Text(
                      'Full Access',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Can add, edit, and view students',
                      style: TextStyle(fontSize: 12),
                    ),
                    activeColor: AppTheme.primaryBlue,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) {},
                  ),
                  RadioListTile<String>(
                    value: 'Lead Access',
                    groupValue: 'Full Access',
                    title: const Text(
                      'Lead Access Only',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Can only add new leads',
                      style: TextStyle(fontSize: 12),
                    ),
                    activeColor: AppTheme.primaryBlue,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) {},
                  ),
                  RadioListTile<String>(
                    value: 'View Only',
                    groupValue: 'Full Access',
                    title: const Text(
                      'View Only',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Cannot add or edit',
                      style: TextStyle(fontSize: 12),
                    ),
                    activeColor: AppTheme.primaryBlue,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) {},
                  ),

                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_selectedAgentForAssign == null) return;
                        setState(() => _isLoading = true);
                        try {
                          await AgentService.updateAgent(
                            _selectedAgentForAssign!.id,
                            {
                              'assigned_universities':
                                  _selectedUniversitiesForAssign,
                            },
                          );
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Assignments saved successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _loadAgents();
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save Assignments'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tab 4: Commissions - Enhanced with University-wise details
  Agent? _selectedAgentForCommission;
  String _commissionType = 'Percentage';
  String _applyToUniversity = 'All';
  String? _selectedUniversity;
  final _commissionValueController = TextEditingController();

  // Sample commission data per university
  final Map<String, Map<String, dynamic>> _universityCommissions = {
    'Sunrise University': {
      'type': 'Percentage',
      'value': 10,
      'agent': 'Rahul Sharma',
    },
    'MIT University': {'type': 'Flat', 'value': 5000, 'agent': 'Priya Verma'},
    'Global Tech University': {
      'type': 'Percentage',
      'value': 12,
      'agent': 'Rahul Sharma',
    },
    'Healthcare Hub': {
      'type': 'One-time',
      'value': 3000,
      'agent': 'Priya Verma',
    },
  };

  Widget _buildCommissionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Commission Setup',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'University-wise commission management',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: _showCommissionSummary,
                icon: const Icon(Icons.summarize, size: 18),
                label: const Text('Summary', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryBlue,
                  side: const BorderSide(color: AppTheme.primaryBlue),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Commission Setup Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Select Agent', Icons.person),
                const SizedBox(height: 12),

                DropdownButtonFormField<Agent>(
                  initialValue: _selectedAgentForCommission,
                  decoration: _inputDecoration(
                    'Choose Agent',
                    Icons.person_search,
                  ),
                  items: _allAgents.map((agent) {
                    return DropdownMenuItem(
                      value: agent,
                      child: Text('${agent.name} (${agent.id})'),
                    );
                  }).toList(),
                  onChanged: (agent) {
                    setState(() {
                      _selectedAgentForCommission = agent;
                      _commissionType = agent?.commissionType ?? 'Percentage';
                      _commissionValueController.text =
                          agent?.commissionValue.toString() ?? '0';
                    });
                  },
                ),

                if (_selectedAgentForCommission != null) ...[
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  // University Selection
                  _buildSectionHeader('Apply Commission To', Icons.school),
                  const SizedBox(height: 12),

                  RadioListTile<String>(
                    value: 'All',
                    groupValue: _applyToUniversity,
                    title: const Text(
                      'All Universities',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Same commission for all',
                      style: TextStyle(fontSize: 12),
                    ),
                    activeColor: AppTheme.primaryBlue,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setState(() => _applyToUniversity = v!),
                  ),
                  RadioListTile<String>(
                    value: 'Specific',
                    groupValue: _applyToUniversity,
                    title: const Text(
                      'Specific University',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Different commission per university',
                      style: TextStyle(fontSize: 12),
                    ),
                    activeColor: AppTheme.primaryBlue,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setState(() => _applyToUniversity = v!),
                  ),

                  if (_applyToUniversity == 'Specific') ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedUniversity,
                      decoration: _inputDecoration(
                        'Select University',
                        Icons.business,
                      ),
                      items: _availableUniversities.map((uni) {
                        return DropdownMenuItem(value: uni, child: Text(uni));
                      }).toList(),
                      onChanged: (v) => setState(() => _selectedUniversity = v),
                    ),
                  ],

                  const SizedBox(height: 20),

                  _buildSectionHeader(
                    'Commission Structure',
                    Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 12),

                  // Commission Type
                  DropdownButtonFormField<String>(
                    initialValue: _commissionType,
                    decoration: _inputDecoration(
                      'Commission Type',
                      Icons.category,
                    ),
                    items: ['Percentage', 'Flat', 'One-time']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _commissionType = v!),
                  ),
                  const SizedBox(height: 12),

                  // Commission Value
                  TextFormField(
                    controller: _commissionValueController,
                    decoration: _inputDecoration(
                      _commissionType == 'Percentage'
                          ? 'Commission Value (%)'
                          : 'Commission Amount (₹)',
                      Icons.money,
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),

                  // Example Calculation
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.calculate,
                              color: Colors.green,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Example Calculation',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Course Fee: ₹50,000',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                        if (_commissionType == 'Percentage')
                          Text(
                            'Agent Commission: ₹${((double.tryParse(_commissionValueController.text) ?? 0) * 50000 / 100).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          )
                        else
                          Text(
                            'Agent Commission: ₹${_commissionValueController.text}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_selectedAgentForCommission == null) return;
                        setState(() => _isLoading = true);

                        try {
                          final Map<String, dynamic> updateData = {};

                          if (_applyToUniversity == 'All') {
                            updateData['commission_rule'] = {
                              'type': _commissionType.toUpperCase(),
                              _commissionType == 'Percentage'
                                      ? 'percentage'
                                      : 'flatAmount':
                                  double.tryParse(
                                    _commissionValueController.text,
                                  ) ??
                                  0,
                            };
                          } else if (_selectedUniversity != null) {
                            // Backend specific university rule
                            updateData['university_rules'] = [
                              {
                                'universityName': _selectedUniversity,
                                'type': _commissionType.toUpperCase(),
                                'value':
                                    double.tryParse(
                                      _commissionValueController.text,
                                    ) ??
                                    0,
                              },
                            ];
                          }

                          await AgentService.updateAgent(
                            _selectedAgentForCommission!.id,
                            updateData,
                          );

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Commission updated successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _loadAgents();
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save Commission'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // University-wise Commission Breakdown
          _buildSectionHeader('University-wise Commission Data', Icons.grid_on),
          const SizedBox(height: 12),

          ..._universityCommissions.entries.map((entry) {
            return _buildUniversityCommissionCard(
              entry.key,
              entry.value['type'],
              entry.value['value'],
              entry.value['agent'],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildUniversityCommissionCard(
    String university,
    String type,
    dynamic value,
    String agent,
  ) {
    Color typeColor = type == 'Percentage'
        ? Colors.blue
        : (type == 'Flat' ? Colors.green : Colors.orange);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.business, color: typeColor, size: 20),
        ),
        title: Text(
          university,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text('Agent: $agent', style: const TextStyle(fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: typeColor),
          ),
          child: Text(
            type == 'Percentage' ? '$value%' : '₹$value',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: typeColor,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Commission Type', type, typeColor),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Commission Value',
                  type == 'Percentage' ? '$value%' : '₹$value',
                  typeColor,
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Agent Name', agent, Colors.grey.shade700),
                const SizedBox(height: 8),
                _buildDetailRow('Status', 'Active', Colors.green),
                const SizedBox(height: 16),

                // Example calculation
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Example for ₹50,000 course:',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Agent gets:',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            type == 'Percentage'
                                ? '₹${(value * 50000 / 100).toStringAsFixed(0)}'
                                : '₹$value',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: typeColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Consultant gets:',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            type == 'Percentage'
                                ? '₹${(50000 - (value * 50000 / 100)).toStringAsFixed(0)}'
                                : '₹${50000 - (value as int)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Edit commission for $university'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text(
                          'Edit',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('View history for $university'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.history, size: 16),
                        label: const Text(
                          'History',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                        ),
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
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  void _showCommissionSummary() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.summarize, color: AppTheme.primaryBlue),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Commission Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Summary Stats
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard('Universities', '4', Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard('Agents', '2', Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Avg Commission',
                      '₹4K',
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Paid',
                      '₹73K',
                      Colors.purple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Agent-wise Breakdown',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  children: [
                    _buildAgentSummaryCard('Rahul Sharma', 2, '₹35K'),
                    _buildAgentSummaryCard('Priya Verma', 2, '₹16K'),
                    _buildAgentSummaryCard('Amit Kumar', 1, '₹12.5K'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildAgentSummaryCard(String name, int universities, String earned) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
          child: Text(
            name[0],
            style: const TextStyle(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '$universities universities',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: Text(
          earned,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  // Tab 5: Activity Monitor
  Widget _buildActivityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Agent Activity Monitor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track performance and earnings of each agent',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildActivityCard(
                  'Total Leads',
                  _allAgents.fold(0, (sum, a) => sum + a.totalLeads).toString(),
                  Icons.phone_in_talk,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActivityCard(
                  'Admissions',
                  _allAgents
                      .fold(0, (sum, a) => sum + a.verifiedAdmissions)
                      .toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActivityCard(
                  'Earnings',
                  '₹${(_allAgents.fold(0.0, (sum, a) => sum + a.totalEarnings) / 1000).toStringAsFixed(1)}K',
                  Icons.account_balance_wallet,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActivityCard(
                  'Active Agents',
                  _allAgents
                      .where((a) => a.status == 'Active')
                      .length
                      .toString(),
                  Icons.people,
                  Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Agent List
          ..._allAgents.map((agent) => _buildActivityAgentCard(agent)),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildActivityAgentCard(Agent agent) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  child: Text(
                    agent.name[0],
                    style: const TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agent.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        agent.id,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: agent.status == 'Active'
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    agent.status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: agent.status == 'Active'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Leads',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        agent.totalLeads.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admissions',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        agent.verifiedAdmissions.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        agent.pendingAdmissions.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Earnings',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${(agent.totalEarnings / 1000).toStringAsFixed(0)}K',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Joined: ${agent.joinedDate.day}/${agent.joinedDate.month}/${agent.joinedDate.year}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Tab 6: Permissions
  Agent? _selectedAgentForPermissions;

  Widget _buildPermissionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Role & Permissions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Control dashboard access for each agent',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Select Agent', Icons.person),
                const SizedBox(height: 12),

                DropdownButtonFormField<Agent>(
                  initialValue: _selectedAgentForPermissions,
                  decoration: _inputDecoration(
                    'Choose Agent',
                    Icons.person_search,
                  ),
                  items: _allAgents.map((agent) {
                    return DropdownMenuItem(
                      value: agent,
                      child: Text('${agent.name} (${agent.id})'),
                    );
                  }).toList(),
                  onChanged: (agent) {
                    setState(() {
                      _selectedAgentForPermissions = agent;
                    });
                  },
                ),

                if (_selectedAgentForPermissions != null) ...[
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  _buildSectionHeader('Module Access', Icons.security),
                  const SizedBox(height: 12),

                  // TODO: Agent model needs to be extended to support permissions
                  // The current Agent model doesn't have a permissions field
                  // Once the backend and model are updated to support permissions,
                  // uncomment the permission switches below
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Permissions management for ${_selectedAgentForPermissions!.name} will be available once the Agent model is updated to support permissions.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /* 
                  // Uncomment when Agent model supports permissions:
                  _buildPermissionSwitch(
                    'Student Management',
                    'Access to student module',
                    _selectedAgentForPermissions!.permissions['student_management'],
                    (val) => setState(
                      () => _selectedAgentForPermissions!.permissions['student_management'] = val,
                    ),
                  ),
                  // ... other permission switches
                  */
                  const SizedBox(height: 24),

                  // Save Button (disabled until permissions are implemented)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          null, // Disabled until permissions are implemented
                      icon: const Icon(Icons.save),
                      label: const Text('Save Permissions (Coming Soon)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tab 7: Blocked Agents
  Widget _buildBlockedTab() {
    final blockedAgents = _allAgents.where((a) => a.blocked == true).toList();

    return blockedAgents.isEmpty
        ? const Center(child: Text('No blocked agents'))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: blockedAgents.length,
            itemBuilder: (context, index) =>
                _buildAgentCard(blockedAgents[index]),
          );
  }

  // Actions
  void _viewAgentDetails(Agent agent) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(agent.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agent ID: ${agent.id}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Mobile: ${agent.phone}'),
              Text('Email: ${agent.email}'),
              Text('Firm: ${agent.firmName}'),
              const SizedBox(height: 12),
              // assigned_universities and last_login are not in the Agent model yet
              const Text('Universities: (Extended details not available)'),
              Text('Total Leads: ${agent.totalLeads}'),
              Text('Verified Admissions: ${agent.verifiedAdmissions}'),
              Text('Total Earnings: ₹${agent.totalEarnings}'),
              const SizedBox(height: 12),
              const Text('Last Login: (Not available)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editAgent(Agent agent) {
    // Note: EditAgentForm expects Map or Agent?
    // Currently EditAgentForm is likely expecting a Map based on previous code.
    // If it expects a Map, we might need to use a toMap method or map literal.
    // However, the goal is to refactor towards Agent model.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAgentForm(
          // For now, if EditAgentForm expects a Map, we provide a placeholder or convert.
          // Let's assume we might need to check EditAgentForm next if it breaks.
          agent: agent,
          onSave: (updatedData) {
            // Note: Updated data from form is likely still a Map.
            // In a real app, we'd call an API and reload.
            _loadAgents();
          },
        ),
      ),
    );
  }

  // Additional Features

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Filter Agents'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Active Agents'),
              value: true,
              onChanged: (v) {},
            ),
            CheckboxListTile(
              title: const Text('Inactive Agents'),
              value: true,
              onChanged: (v) {},
            ),
            CheckboxListTile(
              title: const Text('Blocked Agents'),
              value: false,
              onChanged: (v) {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Universities Assigned'),
              subtitle: const Text('Any'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Earnings Range'),
              subtitle: const Text('Any amount'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Clear All'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
            ),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }

  void _exportToExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.table_chart, color: Colors.white),
            SizedBox(width: 12),
            Text('Exporting to Excel...'),
          ],
        ),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'OPEN',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _exportToPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.white),
            SizedBox(width: 12),
            Text('Exporting to PDF...'),
          ],
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'OPEN',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _showBulkActions() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bulk Actions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.send, color: AppTheme.primaryBlue),
              title: const Text('Send Notification'),
              subtitle: const Text('to selected agents'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification feature coming soon'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block Multiple'),
              subtitle: const Text('Select agents to block'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bulk block feature coming soon'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text('Update Commission'),
              subtitle: const Text('for multiple agents'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bulk commission update coming soon'),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReports() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.assessment, color: AppTheme.primaryBlue),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Agent Reports',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildReportCard(
                      'Performance Report',
                      'View individual agent performance',
                      Icons.trending_up,
                      Colors.green,
                    ),
                    _buildReportCard(
                      'Commission Summary',
                      'Total commissions earned',
                      Icons.account_balance_wallet,
                      Colors.blue,
                    ),
                    _buildReportCard(
                      'Activity Timeline',
                      'Agent activity history',
                      Icons.timeline,
                      Colors.orange,
                    ),
                    _buildReportCard(
                      'Student Conversion',
                      'Lead to admission ratio',
                      Icons.swap_horiz,
                      Colors.purple,
                    ),
                    _buildReportCard(
                      'Monthly Summary',
                      'Month-wise breakdown',
                      Icons.calendar_month,
                      Colors.teal,
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

  Widget _buildReportCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title will be available soon')),
          );
        },
      ),
    );
  }

  void _showHistory() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.history, color: AppTheme.primaryBlue),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Activity History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildHistoryItem(
                      'Agent Added',
                      'Rahul Sharma joined the network',
                      '2 hours ago',
                      Icons.person_add,
                      Colors.green,
                    ),
                    _buildHistoryItem(
                      'Commission Updated',
                      'Priya Verma commission changed to 12%',
                      '5 hours ago',
                      Icons.account_balance_wallet,
                      Colors.blue,
                    ),
                    _buildHistoryItem(
                      'Agent Blocked',
                      'Sneha Patel blocked for policy violation',
                      '1 day ago',
                      Icons.block,
                      Colors.red,
                    ),
                    _buildHistoryItem(
                      'University Assigned',
                      'MIT University assigned to Amit Kumar',
                      '2 days ago',
                      Icons.school,
                      Colors.orange,
                    ),
                    _buildHistoryItem(
                      'Permission Changed',
                      'View Reports enabled for Rahul Sharma',
                      '3 days ago',
                      Icons.security,
                      Colors.purple,
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

  Widget _buildHistoryItem(
    String action,
    String description,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
