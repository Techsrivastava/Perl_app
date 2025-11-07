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
      if (_statusFilter != 'All' && lead['status'] != _statusFilter) return false;
      if (_sourceFilter != 'All' && lead['source'] != _sourceFilter) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('View Leads'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              _showAddLeadDialog();
            },
            tooltip: 'Add New Lead',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatChip('Total', '${_leads.length}', Colors.blue),
                ),
                Expanded(
                  child: _buildStatChip('Pending', '${_leads.where((l) => l['status'] == 'Pending').length}', Colors.orange),
                ),
                Expanded(
                  child: _buildStatChip('Converted', '${_leads.where((l) => l['status'] == 'Converted').length}', Colors.green),
                ),
                Expanded(
                  child: _buildStatChip('Dropped', '0', Colors.red),
                ),
              ],
            ),
          ),
          
          // Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('Filters: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: _statusFilter,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: ['All', 'Pending', 'In Progress', 'Converted', 'Dropped']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => setState(() => _statusFilter = v!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: _sourceFilter,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: ['All', 'App', 'Manual', 'Admin']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => setState(() => _sourceFilter = v!),
                  ),
                ),
              ],
            ),
          ),
          
          // Leads List
          Expanded(
            child: _filteredLeads.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No leads found', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredLeads.length,
                    itemBuilder: (context, index) => _buildLeadCard(_filteredLeads[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildLeadCard(Map<String, dynamic> lead) {
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showLeadDetails(lead),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lead['id'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lead['status'],
                      style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                lead['name'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.school, lead['course']),
              const SizedBox(height: 4),
              _buildInfoRow(Icons.business, lead['university']),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: _buildInfoRow(Icons.person, lead['agent'])),
                  Expanded(child: _buildInfoRow(Icons.source, lead['source'])),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lead['date'], style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () => _showEditDialog(lead),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                        onPressed: () => _showDeleteDialog(lead),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showLeadDetails(Map<String, dynamic> lead) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lead Details - ${lead['id']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name', lead['name']),
              _buildDetailRow('Phone', lead['phone']),
              _buildDetailRow('Course', lead['course']),
              _buildDetailRow('University', lead['university']),
              _buildDetailRow('Agent', lead['agent']),
              _buildDetailRow('Source', lead['source']),
              _buildDetailRow('Status', lead['status']),
              _buildDetailRow('Date', lead['date']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (lead['status'] == 'In Progress')
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lead converted to admission!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
              child: const Text('Convert to Admission', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddLeadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Lead'),
        content: const Text('Lead creation form will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lead added successfully!')),
              );
            },
            child: const Text('Add Lead'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> lead) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Lead - ${lead['id']}'),
        content: const Text('Edit form will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lead updated successfully!')),
              );
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> lead) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lead'),
        content: Text('Are you sure you want to delete lead ${lead['id']} - ${lead['name']}?'),
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
                const SnackBar(content: Text('Lead deleted'), backgroundColor: Colors.red),
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
