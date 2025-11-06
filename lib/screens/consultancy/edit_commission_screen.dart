import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/custom_button.dart';
import 'package:university_app_2/models/consultancy_model.dart';

class EditCommissionScreen extends StatefulWidget {
  final Consultancy consultancy;

  const EditCommissionScreen({super.key, required this.consultancy});

  @override
  State<EditCommissionScreen> createState() => _EditCommissionScreenState();
}

class _EditCommissionScreenState extends State<EditCommissionScreen> {
  late CommissionType _commissionType;
  late double _commissionValue;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _commissionType = widget.consultancy.commissionType;
    _commissionValue = widget.consultancy.commissionValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: const AppHeader(title: 'Edit Commission'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding / 2),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.consultancy.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.charcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.consultancy.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.mediumGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Edit Form Section
              _buildInfoSection(
                title: 'Commission Settings',
                children: [
                  DropdownButtonFormField<CommissionType>(
                    value: _commissionType,
                    decoration: InputDecoration(
                      labelText: 'Commission Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: CommissionType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getCommissionTypeString(type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _commissionType = value!;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a type' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _commissionValue.toString(),
                    decoration: InputDecoration(
                      labelText: 'Commission Value',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixText: _getSuffixText(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _commissionValue = double.tryParse(value) ?? 0.0;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter a value';
                      if (double.tryParse(value) == null)
                        return 'Invalid number';
                      return null;
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Save Button
              CustomButton(
                label: 'Save Changes',
                variant: ButtonVariant.primary,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Update consultancy (in real app, via service)
                    // widget.consultancy.commissionType = _commissionType;
                    // widget.consultancy.commissionValue = _commissionValue;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Commission updated successfully'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                icon: Icons.save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  String _getCommissionTypeString(CommissionType type) {
    switch (type) {
      case CommissionType.percentage:
        return 'Percentage-Based';
      case CommissionType.flat:
        return 'Flat Fee';
      case CommissionType.oneTime:
        return 'One-Time Payment';
    }
  }

  String _getSuffixText() {
    switch (_commissionType) {
      case CommissionType.percentage:
        return '%';
      default:
        return 'INR';
    }
  }
}
