import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class EditAgentForm extends StatefulWidget {
  final Map<String, dynamic> agent;
  final Function(Map<String, dynamic>) onSave;

  const EditAgentForm({super.key, required this.agent, required this.onSave});

  @override
  State<EditAgentForm> createState() => _EditAgentFormState();
}

class _EditAgentFormState extends State<EditAgentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _firmController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _altContactController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _pincodeController;
  late TextEditingController _remarksController;
  late String _selectedState;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.agent['agent_name']);
    _firmController = TextEditingController(text: widget.agent['firm_name']);
    _mobileController = TextEditingController(text: widget.agent['mobile']);
    _emailController = TextEditingController(text: widget.agent['email']);
    _altContactController = TextEditingController(text: widget.agent['alt_contact'] ?? '');
    _addressController = TextEditingController(text: widget.agent['address'] ?? '');
    _cityController = TextEditingController(text: widget.agent['city']);
    _pincodeController = TextEditingController(text: widget.agent['pincode'] ?? '');
    _remarksController = TextEditingController(text: widget.agent['remarks'] ?? '');
    _selectedState = widget.agent['state'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _firmController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _altContactController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Edit ${widget.agent['agent_name']}'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Agent ID Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primaryBlue, Color(0xFF1565C0)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white, size: 32),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.agent['agent_id'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(widget.agent['agent_name'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Basic Information
              _buildSectionHeader('Basic Information', Icons.person),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Agent Name *', Icons.person),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _firmController,
                decoration: _inputDecoration('Firm / Agency Name', Icons.business),
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
                controller: _altContactController,
                decoration: _inputDecoration('Alternate Contact', Icons.phone_android),
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
                      value: _selectedState,
                      decoration: _inputDecoration('State', Icons.map),
                      items: ['Maharashtra', 'Delhi', 'Karnataka', 'Gujarat', 'Rajasthan', 'UP', 'MP']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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

              // Status Information (Read-only)
              _buildSectionHeader('Current Status', Icons.info),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Status', widget.agent['status']),
                    const SizedBox(height: 8),
                    _buildInfoRow('Joined Date', widget.agent['joined_date']),
                    const SizedBox(height: 8),
                    _buildInfoRow('Total Leads', widget.agent['total_leads'].toString()),
                    const SizedBox(height: 8),
                    _buildInfoRow('Verified Admissions', widget.agent['verified_admissions'].toString()),
                    const SizedBox(height: 8),
                    _buildInfoRow('Total Earnings', '₹${widget.agent['total_earnings']}'),
                  ],
                ),
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
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSave({
                            'agent_name': _nameController.text,
                            'firm_name': _firmController.text,
                            'mobile': _mobileController.text,
                            'email': _emailController.text,
                            'city': _cityController.text,
                            'state': _selectedState,
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Agent updated successfully'), backgroundColor: Colors.green),
                          );
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save Changes'),
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
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryBlue),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
