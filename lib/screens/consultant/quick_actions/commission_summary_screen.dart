import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class CommissionSummaryScreen extends StatefulWidget {
  const CommissionSummaryScreen({super.key});

  @override
  State<CommissionSummaryScreen> createState() =>
      _CommissionSummaryScreenState();
}

class _CommissionSummaryScreenState extends State<CommissionSummaryScreen> {
  String _paymentFilter = 'All';
  String _selectedAgent = 'All';
  DateTime? _startDate;
  DateTime? _endDate;

  final List<Map<String, dynamic>> _commissions = [
    {
      'university': 'Dehradun Business School',
      'course': 'MBA Marketing',
      'student': 'Rahul Sharma',
      'courseFee': 250000,
      'shareType': '10%',
      'earned': 25000,
      'status': 'Paid',
      'date': DateTime(2025, 1, 15),
      'agent': 'Aditi Verma',
    },
    {
      'university': 'Tech University',
      'course': 'B.Tech CSE',
      'student': 'Priya Singh',
      'courseFee': 350000,
      'shareType': '8%',
      'earned': 28000,
      'status': 'Pending',
      'date': DateTime(2025, 1, 10),
      'agent': 'Mohit Sharma',
    },
    {
      'university': 'Global Commerce College',
      'course': 'BBA Finance',
      'student': 'Neha Kapoor',
      'courseFee': 180000,
      'shareType': '12%',
      'earned': 21600,
      'status': 'Paid',
      'date': DateTime(2024, 12, 28),
      'agent': 'Aditi Verma',
    },
    {
      'university': 'Modern Medical Institute',
      'course': 'BPT',
      'student': 'Sahil Khan',
      'courseFee': 420000,
      'shareType': '9%',
      'earned': 37800,
      'status': 'In Review',
      'date': DateTime(2025, 2, 3),
      'agent': 'Mohit Sharma',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCommissions = _getFilteredCommissions();
    final totalEarned = filteredCommissions.fold<int>(
      0,
      (sum, c) => sum + (c['earned'] as int),
    );
    final totalPaid = filteredCommissions
        .where((c) => c['status'] == 'Paid')
        .fold<int>(0, (sum, c) => sum + (c['earned'] as int));
    final totalPending = filteredCommissions
        .where((c) => c['status'] == 'Pending')
        .fold<int>(0, (sum, c) => sum + (c['earned'] as int));
    final agentSummary = _getAgentSummary(filteredCommissions);
    final agentGroups = _groupCommissionsByAgent(filteredCommissions);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Commission Summary'),
        backgroundColor: AppTheme.success,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading report...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            _buildSummarySection(totalEarned, totalPaid, totalPending),
            const SizedBox(height: 12),
            // Filters
            _buildFilters(agentSummary.keys.toList()),
            if (agentSummary.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildAgentSummary(agentSummary),
            ],
            if (agentGroups.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildAgentDetailSection(agentGroups),
            ],
            const SizedBox(height: 12),
            _buildCommissionList(filteredCommissions),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(
    int totalEarned,
    int totalPaid,
    int totalPending,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Earned',
                  totalEarned,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard('Received', totalPaid, Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Pending',
                  totalPending,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  'Average Ticket',
                  _calculateAverage(totalEarned),
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '₹${_formatCurrency(value)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(List<String> agents) {
    final agentOptions = ['All', ...agents.where((a) => a != 'All')];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Status',
                  value: _paymentFilter,
                  items: const ['All', 'Paid', 'Pending', 'In Review'],
                  onChanged: (v) => setState(() => _paymentFilter = v!),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  label: 'Agent',
                  value: _selectedAgent,
                  items: agentOptions,
                  onChanged: (v) => setState(() => _selectedAgent = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildDateSelector(
                  'From',
                  _startDate,
                  (date) => setState(() => _startDate = date),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDateSelector(
                  'To',
                  _endDate,
                  (date) => setState(() => _endDate = date),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgentSummary(Map<String, int> summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agent-wise Commission',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: summary.entries.map((entry) {
            final color = AppTheme.primaryBlue.withOpacity(
              0.1 + (entry.value / 100000).clamp(0, 0.5),
            );
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppTheme.primaryBlue.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${_formatCurrency(entry.value)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCommissionList(List<Map<String, dynamic>> commissions) {
    if (commissions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text(
              'No commission entries found',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Try adjusting the filters above',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: commissions.length,
      itemBuilder: (context, index) => _buildCommissionCard(commissions[index]),
    );
  }

  Widget _buildAgentDetailSection(
    Map<String, List<Map<String, dynamic>>> agentGroups,
  ) {
    final sortedAgents = agentGroups.entries.toList()
      ..sort((a, b) {
        final totalA = a.value.fold<int>(
          0,
          (sum, item) => sum + (item['earned'] as int),
        );
        final totalB = b.value.fold<int>(
          0,
          (sum, item) => sum + (item['earned'] as int),
        );
        return totalB.compareTo(totalA);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agent Performance Details',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...sortedAgents
            .map((entry) => _buildAgentDetailCard(entry.key, entry.value))
            .toList(),
      ],
    );
  }

  Widget _buildAgentDetailCard(
    String agent,
    List<Map<String, dynamic>> records,
  ) {
    final total = records.fold<int>(
      0,
      (sum, item) => sum + (item['earned'] as int),
    );
    final paidCount = records.where((r) => r['status'] == 'Paid').length;
    final pendingCount = records.where((r) => r['status'] == 'Pending').length;
    final inReviewCount = records
        .where((r) => r['status'] == 'In Review')
        .length;
    final average = records.isEmpty ? 0 : (total / records.length).round();
    final sortedRecords = List<Map<String, dynamic>>.from(
      records,
    )..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
            child: Text(
              agent.isNotEmpty ? agent[0].toUpperCase() : '?',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            agent,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildMetricBadge(
                  'Total Deals',
                  '${records.length}',
                  AppTheme.primaryBlue,
                ),
                _buildMetricBadge(
                  'Earned',
                  '₹${_formatCurrency(total)}',
                  Colors.green,
                ),
                _buildMetricBadge(
                  'Avg Ticket',
                  '₹${_formatCurrency(average)}',
                  Colors.purple,
                ),
                if (paidCount > 0)
                  _buildStatusChip('$paidCount Paid', Colors.green),
                if (pendingCount > 0)
                  _buildStatusChip('$pendingCount Pending', Colors.orange),
                if (inReviewCount > 0)
                  _buildStatusChip('$inReviewCount In Review', Colors.blueGrey),
              ],
            ),
          ),
          trailing: Icon(Icons.expand_more, color: Colors.grey[500]),
          children: [
            const Divider(),
            ...sortedRecords.map((record) => _buildAgentDealRow(record)),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentDealRow(Map<String, dynamic> record) {
    final statusColor = _statusColor(record['status'] as String);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.person_outline, size: 16, color: statusColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        record['student'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusChip(record['status'], statusColor),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${record['course']} • ${record['university']}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: ${_formatDate(record['date'] as DateTime)}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                    Text(
                      '₹${record['earned']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.success,
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

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCommissionCard(Map<String, dynamic> commission) {
    final isPaid = commission['status'] == 'Paid';
    final statusColor = isPaid
        ? Colors.green
        : commission['status'] == 'Pending'
        ? Colors.orange
        : Colors.blueGrey;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    commission['university'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    commission['status'],
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              commission['course'],
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Student: ${commission['student']}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Agent: ${commission['agent']}',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course Fee',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    Text(
                      '₹${commission['courseFee']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share ${commission['shareType']}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    Text(
                      '₹${commission['earned']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.success,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    Text(
                      _formatDate(commission['date']),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredCommissions() {
    return _commissions.where((commission) {
      final matchesStatus =
          _paymentFilter == 'All' || commission['status'] == _paymentFilter;
      final matchesAgent =
          _selectedAgent == 'All' || commission['agent'] == _selectedAgent;
      final commissionDate = commission['date'] as DateTime;
      final matchesStart =
          _startDate == null || !commissionDate.isBefore(_startDate!);
      final matchesEnd = _endDate == null || !commissionDate.isAfter(_endDate!);
      return matchesStatus && matchesAgent && matchesStart && matchesEnd;
    }).toList()..sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );
  }

  Map<String, int> _getAgentSummary(List<Map<String, dynamic>> commissions) {
    final summary = <String, int>{};
    for (final commission in commissions) {
      final agent = commission['agent'] as String;
      summary[agent] = (summary[agent] ?? 0) + (commission['earned'] as int);
    }
    return summary;
  }

  Map<String, List<Map<String, dynamic>>> _groupCommissionsByAgent(
    List<Map<String, dynamic>> commissions,
  ) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final commission in commissions) {
      final agent = commission['agent'] as String;
      grouped.putIfAbsent(agent, () => []).add(commission);
    }
    return grouped;
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            onChanged: onChanged,
            items: items
                .map(
                  (item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(
    String label,
    DateTime? selectedDate,
    ValueChanged<DateTime?> onDateSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        OutlinedButton.icon(
          onPressed: () async {
            final now = DateTime.now();
            final initialDate = selectedDate ?? now;
            final picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(now.year - 5),
              lastDate: DateTime(now.year + 1),
            );
            onDateSelected(picked);
          },
          icon: const Icon(Icons.calendar_today, size: 16),
          label: Text(
            selectedDate == null ? 'Any date' : _formatDate(selectedDate),
            style: const TextStyle(fontSize: 12),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            foregroundColor: Colors.grey[700],
            side: BorderSide(color: Colors.grey[300]!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatCurrency(int value) {
    if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(1)}L';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  int _calculateAverage(int totalEarned) {
    if (_commissions.isEmpty) return 0;
    final count = _getFilteredCommissions().length;
    if (count == 0) return 0;
    return (totalEarned / count).round();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'In Review':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }
}
