import 'package:flutter/material.dart';

class FeeCalculationCard extends StatelessWidget {
  final double universityFee;
  final double displayFee;
  final String consultancyShareType;
  final double consultancyShareValue;

  const FeeCalculationCard({
    Key? key,
    required this.universityFee,
    required this.displayFee,
    required this.consultancyShareType,
    required this.consultancyShareValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 18),
              const SizedBox(width: 8),
              const Text(
                'Auto-filled from Course Setup (Read-only)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildReadOnlyRow('University Fee (Fixed)', '₹${universityFee.toStringAsFixed(0)}'),
          _buildReadOnlyRow('Display Fee (Shown to Students)', '₹${displayFee.toStringAsFixed(0)}'),
          _buildReadOnlyRow(
            'Consultancy Share',
            '$consultancyShareType - $consultancyShareValue${consultancyShareType == "percent" ? "%" : ""}',
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
