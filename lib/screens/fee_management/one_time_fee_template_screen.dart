import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/widgets/app_header.dart';

class OneTimeFeeTemplateScreen extends StatefulWidget {
  const OneTimeFeeTemplateScreen({super.key});

  @override
  State<OneTimeFeeTemplateScreen> createState() =>
      _OneTimeFeeTemplateScreenState();
}

class _OneTimeFeeTemplateScreenState extends State<OneTimeFeeTemplateScreen> {
  List<Map<String, dynamic>> _feeTemplates = [];

  @override
  void initState() {
    super.initState();
    _loadDefaultTemplates();
  }

  void _loadDefaultTemplates() {
    setState(() {
      _feeTemplates = [
        {
          'fee_id': 1,
          'fee_name': 'Registration Fee',
          'fee_type': 'One-Time',
          'amount': 2000.0,
          'mandatory': true,
          'applicable_stage': 'Admission',
          'description': 'Payable during admission process',
          'document_required': false,
          'status': 'Active',
        },
        {
          'fee_id': 2,
          'fee_name': 'Exam Fee',
          'fee_type': 'Annual',
          'amount': 5000.0,
          'mandatory': true,
          'applicable_stage': 'Exam',
          'description': 'Annual examination fee',
          'document_required': false,
          'status': 'Active',
        },
        {
          'fee_id': 3,
          'fee_name': 'Hostel Fee',
          'fee_type': 'Annual',
          'amount': 12000.0,
          'mandatory': false,
          'applicable_stage': 'Others',
          'description': 'Optional hostel accommodation',
          'document_required': false,
          'status': 'Active',
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeFees = _feeTemplates
        .where((f) => f['status'] == 'Active')
        .length;
    final mandatoryFees = _feeTemplates
        .where((f) => f['mandatory'] == true)
        .length;
    final totalAmount = _feeTemplates
        .where((f) => f['status'] == 'Active' && f['mandatory'] == true)
        .fold<double>(0, (sum, item) => sum + (item['amount'] as double));

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppHeader(
        title: 'One-Time Fee Template',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: _saveTemplate,
              icon: const Icon(Icons.save, size: 18, color: Colors.white),
              label: const Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    _feeTemplates.length.toString(),
                    AppTheme.primaryBlue,
                    Icons.receipt_long,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Active',
                    activeFees.toString(),
                    AppTheme.success,
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Mandatory',
                    mandatoryFees.toString(),
                    Colors.orange,
                    Icons.priority_high,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Amount',
                    '₹${totalAmount.toStringAsFixed(0)}',
                    Colors.green,
                    Icons.currency_rupee,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showAddFeeDialog,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add Fee',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showPreviewDialog,
                    icon: const Icon(Icons.visibility),
                    label: const Text('Preview'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _feeTemplates.length,
              itemBuilder: (context, index) =>
                  _buildFeeCard(_feeTemplates[index], index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: AppTheme.mediumGray),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeCard(Map<String, dynamic> fee, int index) {
    final isActive = fee['status'] == 'Active';
    final isMandatory = fee['mandatory'] as bool;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.receipt,
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fee['fee_name'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        fee['fee_type'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '₹${fee['amount'].toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.success,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: [
                _buildChip(
                  isMandatory ? 'Mandatory' : 'Optional',
                  isMandatory ? Colors.red : Colors.orange,
                  isMandatory ? Icons.star : Icons.add_circle_outline,
                ),
                _buildChip(
                  fee['applicable_stage'],
                  AppTheme.primaryBlue,
                  Icons.schedule,
                ),
                _buildChip(
                  isActive ? 'Active' : 'Inactive',
                  isActive ? AppTheme.success : Colors.grey,
                  isActive ? Icons.check_circle : Icons.cancel,
                ),
              ],
            ),
            if (fee['description'] != null &&
                (fee['description'] as String).isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  fee['description'],
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.mediumGray,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showEditFeeDialog(fee, index),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _toggleStatus(index),
                  icon: Icon(
                    isActive ? Icons.visibility_off : Icons.visibility,
                    size: 16,
                  ),
                  label: Text(
                    isActive ? 'Hide' : 'Show',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _deleteFee(index),
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.error,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
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

  Widget _buildChip(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddFeeDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedType = 'One-Time';
    String selectedStage = 'Admission';
    bool isMandatory = false;
    bool docRequired = false;
    bool isActive = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryBlue,
                        AppTheme.primaryBlue.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add New Fee',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Create a new fee template',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Fee Name *',
                              hintText: 'e.g., Registration Fee',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.receipt, size: 20),
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Amount *',
                                    hintText: '₹',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.currency_rupee,
                                      size: 20,
                                    ),
                                  ),
                                  validator: (v) =>
                                      v!.isEmpty ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: selectedType,
                                  decoration: InputDecoration(
                                    labelText: 'Type *',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items:
                                      [
                                        'One-Time',
                                        'Annual',
                                        'Semester',
                                        'Per-Service',
                                      ].map((t) {
                                        return DropdownMenuItem(
                                          value: t,
                                          child: Text(
                                            t,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (v) =>
                                      setDialogState(() => selectedType = v!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: selectedStage,
                            decoration: InputDecoration(
                              labelText: 'Applicable Stage *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.schedule, size: 20),
                            ),
                            items: ['Admission', 'Exam', 'Completion', 'Others']
                                .map((s) {
                                  return DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  );
                                })
                                .toList(),
                            onChanged: (v) =>
                                setDialogState(() => selectedStage = v!),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              hintText: 'e.g., Payable during admission',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile(
                            dense: true,
                            title: const Text(
                              'Mandatory Fee',
                              style: TextStyle(fontSize: 13),
                            ),
                            subtitle: const Text(
                              'Auto-added to course fee',
                              style: TextStyle(fontSize: 11),
                            ),
                            value: isMandatory,
                            onChanged: (v) =>
                                setDialogState(() => isMandatory = v),
                            activeTrackColor: AppTheme.primaryBlue,
                          ),
                          SwitchListTile(
                            dense: true,
                            title: const Text(
                              'Document Required',
                              style: TextStyle(fontSize: 13),
                            ),
                            subtitle: const Text(
                              'Require document upload',
                              style: TextStyle(fontSize: 11),
                            ),
                            value: docRequired,
                            onChanged: (v) =>
                                setDialogState(() => docRequired = v),
                            activeTrackColor: AppTheme.primaryBlue,
                          ),
                          SwitchListTile(
                            dense: true,
                            title: const Text(
                              'Active Status',
                              style: TextStyle(fontSize: 13),
                            ),
                            subtitle: const Text(
                              'Enable this fee',
                              style: TextStyle(fontSize: 11),
                            ),
                            value: isActive,
                            onChanged: (v) =>
                                setDialogState(() => isActive = v),
                            activeTrackColor: AppTheme.success,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                _feeTemplates.add({
                                  'fee_id': _feeTemplates.length + 1,
                                  'fee_name': nameController.text,
                                  'fee_type': selectedType,
                                  'amount':
                                      double.tryParse(amountController.text) ??
                                      0.0,
                                  'mandatory': isMandatory,
                                  'applicable_stage': selectedStage,
                                  'description': descriptionController.text,
                                  'document_required': docRequired,
                                  'status': isActive ? 'Active' : 'Inactive',
                                });
                              });
                              Navigator.pop(context);
                              _showSnackBar(
                                '✅ Fee added successfully!',
                                AppTheme.success,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.success,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Add Fee',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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

  void _showEditFeeDialog(Map<String, dynamic> fee, int index) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: fee['fee_name']);
    final amountController = TextEditingController(
      text: fee['amount'].toString(),
    );
    final descriptionController = TextEditingController(
      text: fee['description'] ?? '',
    );
    String selectedType = fee['fee_type'];
    String selectedStage = fee['applicable_stage'];
    bool isMandatory = fee['mandatory'];
    bool docRequired = fee['document_required'];
    bool isActive = fee['status'] == 'Active';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.orange.shade700],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.edit, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Fee',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Update fee template',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Fee Name *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.receipt, size: 20),
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Amount *',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.currency_rupee,
                                      size: 20,
                                    ),
                                  ),
                                  validator: (v) =>
                                      v!.isEmpty ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: selectedType,
                                  decoration: InputDecoration(
                                    labelText: 'Type *',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items:
                                      [
                                        'One-Time',
                                        'Annual',
                                        'Semester',
                                        'Per-Service',
                                      ].map((t) {
                                        return DropdownMenuItem(
                                          value: t,
                                          child: Text(
                                            t,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (v) =>
                                      setDialogState(() => selectedType = v!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: selectedStage,
                            decoration: InputDecoration(
                              labelText: 'Applicable Stage *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.schedule, size: 20),
                            ),
                            items: ['Admission', 'Exam', 'Completion', 'Others']
                                .map((s) {
                                  return DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  );
                                })
                                .toList(),
                            onChanged: (v) =>
                                setDialogState(() => selectedStage = v!),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile(
                            dense: true,
                            title: const Text(
                              'Mandatory Fee',
                              style: TextStyle(fontSize: 13),
                            ),
                            subtitle: const Text(
                              'Auto-added to course fee',
                              style: TextStyle(fontSize: 11),
                            ),
                            value: isMandatory,
                            onChanged: (v) =>
                                setDialogState(() => isMandatory = v),
                            activeTrackColor: AppTheme.primaryBlue,
                          ),
                          SwitchListTile(
                            dense: true,
                            title: const Text(
                              'Document Required',
                              style: TextStyle(fontSize: 13),
                            ),
                            subtitle: const Text(
                              'Require document upload',
                              style: TextStyle(fontSize: 11),
                            ),
                            value: docRequired,
                            onChanged: (v) =>
                                setDialogState(() => docRequired = v),
                            activeTrackColor: AppTheme.primaryBlue,
                          ),
                          SwitchListTile(
                            dense: true,
                            title: const Text(
                              'Active Status',
                              style: TextStyle(fontSize: 13),
                            ),
                            subtitle: const Text(
                              'Enable this fee',
                              style: TextStyle(fontSize: 11),
                            ),
                            value: isActive,
                            onChanged: (v) =>
                                setDialogState(() => isActive = v),
                            activeTrackColor: AppTheme.success,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                _feeTemplates[index] = {
                                  'fee_id': fee['fee_id'],
                                  'fee_name': nameController.text,
                                  'fee_type': selectedType,
                                  'amount':
                                      double.tryParse(amountController.text) ??
                                      0.0,
                                  'mandatory': isMandatory,
                                  'applicable_stage': selectedStage,
                                  'description': descriptionController.text,
                                  'document_required': docRequired,
                                  'status': isActive ? 'Active' : 'Inactive',
                                };
                              });
                              Navigator.pop(context);
                              _showSnackBar(
                                '✅ Fee updated successfully!',
                                Colors.orange,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: const Text(
                            'Update Fee',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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

  void _showPreviewDialog() {
    // Preview implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fee Template Preview'),
        content: SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Fee')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Status')),
            ],
            rows: _feeTemplates.map((fee) {
              return DataRow(
                cells: [
                  DataCell(Text(fee['fee_name'])),
                  DataCell(Text(fee['fee_type'])),
                  DataCell(Text('₹${fee['amount']}')),
                  DataCell(Text(fee['status'])),
                ],
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _toggleStatus(int index) {
    setState(() {
      _feeTemplates[index]['status'] =
          _feeTemplates[index]['status'] == 'Active' ? 'Inactive' : 'Active';
    });
    _showSnackBar('Status updated', Colors.blue);
  }

  void _deleteFee(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Fee'),
        content: const Text('Are you sure you want to delete this fee?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _feeTemplates.removeAt(index));
              Navigator.pop(context);
              _showSnackBar('Fee deleted', AppTheme.error);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _saveTemplate() {
    _showSnackBar('✅ Template saved successfully!', AppTheme.success);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
