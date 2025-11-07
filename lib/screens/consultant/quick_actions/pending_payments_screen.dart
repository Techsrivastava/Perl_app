import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class PendingPaymentsScreen extends StatefulWidget {
  const PendingPaymentsScreen({super.key});

  @override
  State<PendingPaymentsScreen> createState() => _PendingPaymentsScreenState();
}

class _PendingPaymentsScreenState extends State<PendingPaymentsScreen> {
  String _statusFilter = 'All';
  
  final List<Map<String, dynamic>> _payments = [
    {
      'student': 'Rahul Sharma',
      'course': 'MBA Marketing',
      'university': 'Dehradun Business School',
      'amount': 50000,
      'status': 'Pending',
      'date': '2025-01-10',
      'agent': 'Priya Gupta',
      'utr': 'UTR123456789',
    },
    {
      'student': 'Priya Singh',
      'course': 'B.Tech CSE',
      'university': 'Tech University',
      'amount': 75000,
      'status': 'Verified',
      'date': '2025-01-08',
      'agent': 'Raj Kumar',
      'utr': 'UTR987654321',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final pending = _payments.where((p) => p['status'] == 'Pending').length;
    final verified = _payments.where((p) => p['status'] == 'Verified').length;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Pending Payments'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Stats Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('Pending Verification', pending.toString(), Colors.orange),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('Verified', verified.toString(), Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('Payment Issues', '0', Colors.red),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('Transferred', '0', Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: DropdownButton<String>(
                    value: _statusFilter,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: ['All', 'Pending', 'Verified', 'Reverted'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => _statusFilter = v!),
                  ),
                ),
              ],
            ),
          ),
          
          // Payments List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _payments.length,
              itemBuilder: (context, index) => _buildPaymentCard(_payments[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> payment) {
    final isPending = payment['status'] == 'Pending';
    final statusColor = isPending ? Colors.orange : Colors.green;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    payment['student'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    payment['status'],
                    style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(payment['course'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            Text(payment['university'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    Text('₹${payment['amount']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.success)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Agent', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    Text(payment['agent'], style: const TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Date', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    Text(payment['date'], style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            if (isPending) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showProofDialog(payment),
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('View Proof', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _approvePayment(payment),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Approve', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showProofDialog(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Proof'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student: ${payment['student']}'),
            Text('UTR: ${payment['utr']}'),
            Text('Amount: ₹${payment['amount']}'),
            const SizedBox(height: 16),
            Container(
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: Text('Screenshot placeholder')),
            ),
          ],
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

  void _approvePayment(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Payment'),
        content: Text('Approve payment of ₹${payment['amount']} from ${payment['student']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => payment['status'] = 'Verified');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment approved!'), backgroundColor: AppTheme.success),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
            child: const Text('Approve', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
