import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> student;
  
  const StudentDetailsScreen({super.key, required this.student});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditing = false;
  
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _remarksController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _nameController = TextEditingController(text: widget.student['name']);
    _mobileController = TextEditingController(text: widget.student['mobile']);
    _emailController = TextEditingController(text: widget.student['email']);
    _remarksController = TextEditingController(text: widget.student['remarks']);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _remarksController.dispose();
    super.dispose();
  }
  
  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }
  
  void _saveChanges() {
    setState(() {
      widget.student['name'] = _nameController.text;
      widget.student['mobile'] = _mobileController.text;
      widget.student['email'] = _emailController.text;
      widget.student['remarks'] = _remarksController.text;
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved successfully'), backgroundColor: Colors.green),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Verified': return Colors.green;
      case 'Applied': return Colors.orange;
      case 'Reverted': return Colors.red;
      case 'Rejected': return Colors.red[900]!;
      case 'Lead': return Colors.blue;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.student['status'];
    final statusColor = _getStatusColor(status);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing && (widget.student['status'] == 'Lead' || widget.student['status'] == 'Reverted'))
            IconButton(
              onPressed: _toggleEdit,
              icon: const Icon(Icons.edit),
              tooltip: 'Edit',
            ),
          if (_isEditing)
            IconButton(
              onPressed: () {
                setState(() => _isEditing = false);
              },
              icon: const Icon(Icons.close),
              tooltip: 'Cancel',
            ),
          if (_isEditing)
            IconButton(
              onPressed: _saveChanges,
              icon: const Icon(Icons.check),
              tooltip: 'Save',
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.info, size: 18), text: 'Info'),
            Tab(icon: Icon(Icons.attach_money, size: 18), text: 'Fee'),
            Tab(icon: Icon(Icons.upload_file, size: 18), text: 'Documents'),
            Tab(icon: Icon(Icons.history, size: 18), text: 'Timeline'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor.withValues(alpha: 0.8), statusColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.student['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(widget.student['student_id'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInfoTab(),
                _buildFeeTab(),
                _buildDocumentsTab(),
                _buildTimelineTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoCard('Personal', [
            if (_isEditing) ...[
              _buildEditField('Name', _nameController, Icons.person),
              _buildEditField('Mobile', _mobileController, Icons.phone),
              _buildEditField('Email', _emailController, Icons.email),
            ] else ...[
              _buildRow('Name', widget.student['name']),
              _buildRow('Mobile', widget.student['mobile']),
              _buildRow('Email', widget.student['email']),
            ],
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Course', [
            _buildRow('Course', widget.student['course']),
            _buildRow('University', widget.student['university']),
            _buildRow('Status', widget.student['status']),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Remarks', [
            if (_isEditing)
              _buildEditField('Remarks', _remarksController, Icons.note, maxLines: 3)
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  widget.student['remarks'] ?? 'No remarks',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
          ]),
        ],
      ),
    );
  }

  Widget _buildFeeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildFeeCard('Total', '₹${widget.student['total_fee']}', Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildFeeCard('Paid', '₹${widget.student['paid_amount']}', Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _buildFeeCard('Pending', '₹${widget.student['pending_amount']}', Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    final docs = widget.student['documents'] as List;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDocCard('10th Marksheet', docs.contains('10th')),
        _buildDocCard('12th Marksheet', docs.contains('12th')),
        _buildDocCard('Aadhar Card', docs.contains('Aadhar')),
        _buildDocCard('Transfer Certificate', docs.contains('TC')),
      ],
    );
  }

  Widget _buildTimelineTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTimelineItem('Application Registered', '2024-10-15', Colors.blue, true),
        _buildTimelineItem('Documents Uploaded', '2024-10-15', Colors.green, false),
        _buildTimelineItem('Application Submitted', '2024-10-15', Colors.orange, false),
        _buildTimelineItem('Verified', '2024-10-18', Colors.green, false),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text('Take Action'),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...children,
      ]),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        SizedBox(width: 100, child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600]))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
      ]),
    );
  }
  
  Widget _buildEditField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppTheme.primaryBlue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildFeeCard(String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Column(children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[700])),
        const SizedBox(height: 4),
        Text(amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }

  Widget _buildDocCard(String name, bool uploaded) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: uploaded ? Colors.green : Colors.grey[200]!)),
      child: Row(children: [
        Icon(uploaded ? Icons.check_circle : Icons.upload_file, color: uploaded ? Colors.green : Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(child: Text(name, style: const TextStyle(fontSize: 13))),
        Text(uploaded ? 'Uploaded' : 'Pending', style: TextStyle(fontSize: 11, color: uploaded ? Colors.green : Colors.grey[600])),
      ]),
    );
  }

  Widget _buildTimelineItem(String title, String date, Color color, bool isFirst) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        if (!isFirst) Container(width: 2, height: 20, color: Colors.grey[300]),
        Container(width: 32, height: 32, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle, border: Border.all(color: color, width: 2))),
        Container(width: 2, height: 40, color: Colors.grey[300]),
      ]),
      const SizedBox(width: 12),
      Expanded(child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          Text(date, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ]),
      )),
    ]);
  }
}
