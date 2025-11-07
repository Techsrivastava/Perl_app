import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:intl/intl.dart';

class FeeStudentReportsScreen extends StatefulWidget {
  const FeeStudentReportsScreen({Key? key}) : super(key: key);

  @override
  State<FeeStudentReportsScreen> createState() => _FeeStudentReportsScreenState();
}

class _FeeStudentReportsScreenState extends State<FeeStudentReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCourse = 'All Courses';
  String _selectedYear = 'All Years';
  String _exportFormat = 'Excel';
  
  // Report Selection
  bool _selectTotalFees = false;
  bool _selectPendingPayments = false;
  bool _selectCommissionReport = false;
  bool _selectAdmissionStatus = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text('💰 Fee & Student Reports', style: TextStyle(fontSize: 16, color: AppTheme.white)),
        backgroundColor: AppTheme.primaryBlue,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.white,
          unselectedLabelColor: AppTheme.white.withOpacity(0.6),
          indicatorColor: AppTheme.white,
          labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.attach_money, size: 16), text: 'Total Fees'),
            Tab(icon: Icon(Icons.pending_actions, size: 16), text: 'Pending'),
            Tab(icon: Icon(Icons.handshake, size: 16), text: 'Commission'),
            Tab(icon: Icon(Icons.school, size: 16), text: 'Admissions'),
            Tab(icon: Icon(Icons.download, size: 16), text: 'Export'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTotalFeesTab(),
          _buildPendingPaymentsTab(),
          _buildCommissionReportTab(),
          _buildAdmissionStatusTab(),
          _buildStudentExportTab(),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 9, color: color), textAlign: TextAlign.center, maxLines: 1),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
  
  Widget _buildCourseDetailItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 8, color: AppTheme.mediumGray), textAlign: TextAlign.center),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.charcoal), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
  
  void _exportReport(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('📄 Exporting $type report...'), backgroundColor: AppTheme.success),
    );
  }
  
  // 1️⃣ Total Fees Tab - With Student Details
  Widget _buildTotalFeesTab() {
    // Detailed student fee data
    final studentFees = [
      {'studentName': 'Rahul Kumar', 'studentId': 'STU001', 'course': 'BNYS', 'courseFee': 120000, 'paid': 90000, 'pending': 30000, 'year': '2025', 'semester': '1st Sem', 'lastPayment': DateTime(2025, 10, 20), 'consultancy': 'EduConnect Agency', 'consultancyCode': 'CON001'},
      {'studentName': 'Amit Patel', 'studentId': 'STU003', 'course': 'BNYS', 'courseFee': 120000, 'paid': 60000, 'pending': 60000, 'year': '2025', 'semester': '1st Sem', 'lastPayment': DateTime(2025, 9, 15), 'consultancy': 'TechConsult', 'consultancyCode': 'CON003'},
      {'studentName': 'Priya Sharma', 'studentId': 'STU002', 'course': 'BPT', 'courseFee': 110000, 'paid': 110000, 'pending': 0, 'year': '2025', 'semester': '2nd Sem', 'lastPayment': DateTime(2025, 10, 25), 'consultancy': 'AlphaEdu Consultants', 'consultancyCode': 'CON002'},
      {'studentName': 'Neha Singh', 'studentId': 'STU005', 'course': 'BPT', 'courseFee': 110000, 'paid': 110000, 'pending': 0, 'year': '2025', 'semester': '2nd Sem', 'lastPayment': DateTime(2025, 10, 28), 'consultancy': 'AlphaEdu Consultants', 'consultancyCode': 'CON002'},
      {'studentName': 'Sneha Reddy', 'studentId': 'STU004', 'course': 'B.Tech CS', 'courseFee': 500000, 'paid': 400000, 'pending': 100000, 'year': '2025', 'semester': '3rd Sem', 'lastPayment': DateTime(2025, 10, 30), 'consultancy': 'EduConnect Agency', 'consultancyCode': 'CON001'},
      {'studentName': 'Karan Mehta', 'studentId': 'STU006', 'course': 'B.Tech CS', 'courseFee': 500000, 'paid': 450000, 'pending': 50000, 'year': '2025', 'semester': '3rd Sem', 'lastPayment': DateTime(2025, 11, 2), 'consultancy': 'Global Edu Partners', 'consultancyCode': 'CON004'},
    ];
    
    // Filter students
    final filtered = studentFees.where((s) {
      return (_selectedCourse == 'All Courses' || s['course'] == _selectedCourse) &&
             (_selectedYear == 'All Years' || s['year'] == _selectedYear);
    }).toList();
    
    // Group by course
    final courseGroups = <String, List<Map<String, dynamic>>>{};
    for (var student in filtered) {
      final course = student['course'].toString();
      courseGroups.putIfAbsent(course, () => []).add(student);
    }
    
    // Calculate totals
    final totalExp = filtered.fold<int>(0, (sum, s) => sum + (s['courseFee'] as int));
    final totalRec = filtered.fold<int>(0, (sum, s) => sum + (s['paid'] as int));
    final totalPend = filtered.fold<int>(0, (sum, s) => sum + (s['pending'] as int));
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(child: DropdownButtonFormField<String>(
                  value: _selectedCourse,
                  decoration: const InputDecoration(labelText: 'Course', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6)),
                  style: const TextStyle(fontSize: 11),
                  items: ['All Courses', 'BNYS', 'BPT', 'B.Tech CS'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _selectedCourse = v!),
                )),
                const SizedBox(width: 10),
                Expanded(child: DropdownButtonFormField<String>(
                  value: _selectedYear,
                  decoration: const InputDecoration(labelText: 'Year', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6)),
                  style: const TextStyle(fontSize: 11),
                  items: ['All Years', '2025', '2024'].map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
                  onChanged: (v) => setState(() => _selectedYear = v!),
                )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          
          // Overall Stats
          Row(
            children: [
              Expanded(child: _buildStatCard('👥 Students', '${filtered.length}', AppTheme.primaryBlue)),
              const SizedBox(width: 6),
              Expanded(child: _buildStatCard('💰 Total', '₹${NumberFormat('#,##,###').format(totalExp)}', AppTheme.charcoal)),
              const SizedBox(width: 6),
              Expanded(child: _buildStatCard('✅ Received', '₹${NumberFormat('#,##,###').format(totalRec)}', AppTheme.success)),
              const SizedBox(width: 6),
              Expanded(child: _buildStatCard('⏳ Pending', '₹${NumberFormat('#,##,###').format(totalPend)}', AppTheme.warning)),
            ],
          ),
          const SizedBox(height: 10),
          
          // Download Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _exportReport('Total Fees'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, padding: const EdgeInsets.all(10)),
              icon: const Icon(Icons.download, size: 16, color: AppTheme.white),
              label: const Text('Download Detailed Report', style: TextStyle(fontSize: 11, color: AppTheme.white)),
            ),
          ),
          const SizedBox(height: 16),
          
          // Course-wise Groups
          ...courseGroups.entries.map((entry) {
            final courseName = entry.key;
            final students = entry.value;
            final courseFee = students.first['courseFee'] as int;
            final courseTotal = students.fold<int>(0, (sum, s) => sum + (s['paid'] as int));
            final coursePending = students.fold<int>(0, (sum, s) => sum + (s['pending'] as int));
            final collectionRate = ((courseTotal / (courseFee * students.length)) * 100).toStringAsFixed(1);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.success.withOpacity(0.3), width: 2),
              ),
              child: Column(
                children: [
                  // Course Header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppTheme.success, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.school, color: AppTheme.white, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(courseName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              Text('${students.length} student(s) • Fee: ₹${NumberFormat('#,##,###').format(courseFee)}', 
                                style: const TextStyle(fontSize: 10, color: AppTheme.mediumGray)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('$collectionRate%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.success)),
                            const Text('Collection', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Course Stats
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: AppTheme.lightGray.withOpacity(0.3),
                    child: Row(
                      children: [
                        Expanded(child: _buildCourseDetailItem('💰 Expected', '₹${NumberFormat('#,##,###').format(courseFee * students.length)}')),
                        Expanded(child: _buildCourseDetailItem('✅ Collected', '₹${NumberFormat('#,##,###').format(courseTotal)}')),
                        Expanded(child: _buildCourseDetailItem('⏳ Pending', '₹${NumberFormat('#,##,###').format(coursePending)}')),
                      ],
                    ),
                  ),
                  
                  // Student Fee Details
                  ...students.map((student) {
                    final paymentPercent = ((student['paid'] as int) / (student['courseFee'] as int) * 100).toStringAsFixed(0);
                    final isPaid = student['pending'] == 0;
                    
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppTheme.lightGray.withOpacity(0.5))),
                        color: isPaid ? AppTheme.success.withOpacity(0.02) : null,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isPaid ? AppTheme.success.withOpacity(0.1) : AppTheme.warning.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    student['studentName'].toString().substring(0, 1),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isPaid ? AppTheme.success : AppTheme.warning,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            student['studentName'].toString(),
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isPaid) 
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.success,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text('PAID', style: TextStyle(fontSize: 8, color: AppTheme.white, fontWeight: FontWeight.bold)),
                                          ),
                                      ],
                                    ),
                                    Text(
                                      'ID: ${student['studentId']} • ${student['semester']} • $paymentPercent% paid',
                                      style: const TextStyle(fontSize: 9, color: AppTheme.mediumGray),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          // Payment Progress Bar
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Payment Progress', style: const TextStyle(fontSize: 9, color: AppTheme.mediumGray)),
                                  Text('$paymentPercent%', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isPaid ? AppTheme.success : AppTheme.warning)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: (student['paid'] as int) / (student['courseFee'] as int),
                                  backgroundColor: AppTheme.lightGray,
                                  color: isPaid ? AppTheme.success : AppTheme.warning,
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('💰 Course Fee', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                                    Text('₹${NumberFormat('#,##,###').format(student['courseFee'])}', 
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('✅ Paid', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                                    Text('₹${NumberFormat('#,##,###').format(student['paid'])}', 
                                      style: const TextStyle(fontSize: 10, color: AppTheme.success, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('⏳ Pending', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                                    Text('₹${NumberFormat('#,##,###').format(student['pending'])}', 
                                      style: TextStyle(fontSize: 10, color: isPaid ? AppTheme.mediumGray : AppTheme.warning, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('📅 Last Pay', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                                    Text(DateFormat('dd MMM').format(student['lastPayment'] as DateTime), 
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('🤝 Consultant', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                                    Text(student['consultancy'].toString(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('🆔 Code', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                                    Text(student['consultancyCode'].toString(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _showStudentDetailDialog(student),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryBlue,
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                  ),
                                  icon: const Icon(Icons.visibility, size: 12, color: AppTheme.white),
                                  label: const Text('Details', style: TextStyle(fontSize: 9, color: AppTheme.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
  
  // 2️⃣ Pending Payments Tab - Course-wise
  Widget _buildPendingPaymentsTab() {
    final mockPayments = [
      {
        'studentName': 'Rahul Kumar', 'studentId': 'STU001', 'email': 'rahul@email.com', 'phone': '+91 9876543210',
        'course': 'BNYS', 'courseFee': 120000, 'paidAmount': 90000, 'pendingAmount': 30000,
        'consultant': 'EduConnect', 'semester': '1st Sem', 'dueDate': DateTime(2025, 11, 15),
      },
      {
        'studentName': 'Amit Patel', 'studentId': 'STU003', 'email': 'amit@email.com', 'phone': '+91 9876543212',
        'course': 'BNYS', 'courseFee': 120000, 'paidAmount': 60000, 'pendingAmount': 60000,
        'consultant': 'TechConsult', 'semester': '1st Sem', 'dueDate': DateTime(2025, 11, 10),
      },
      {
        'studentName': 'Priya Sharma', 'studentId': 'STU002', 'email': 'priya@email.com', 'phone': '+91 9876543211',
        'course': 'BPT', 'courseFee': 110000, 'paidAmount': 85000, 'pendingAmount': 25000,
        'consultant': 'AlphaEdu', 'semester': '2nd Sem', 'dueDate': DateTime(2025, 11, 20),
      },
      {
        'studentName': 'Sneha Reddy', 'studentId': 'STU004', 'email': 'sneha@email.com', 'phone': '+91 9876543213',
        'course': 'B.Tech CS', 'courseFee': 500000, 'paidAmount': 400000, 'pendingAmount': 100000,
        'consultant': 'EduConnect', 'semester': '3rd Sem', 'dueDate': DateTime(2025, 11, 25),
      },
    ];
    
    // Group by course
    final courseGroups = <String, List<Map<String, dynamic>>>{};
    for (var payment in mockPayments) {
      final course = payment['course'].toString();
      courseGroups.putIfAbsent(course, () => []).add(payment);
    }
    
    final totalPending = mockPayments.fold<int>(0, (sum, p) => sum + (p['pendingAmount'] as int));
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Overall Stats
          Row(
            children: [
              Expanded(child: _buildStatCard('👥 Students', '${mockPayments.length}', AppTheme.primaryBlue)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard('⏳ Pending', '₹${NumberFormat('#,##,###').format(totalPending)}', AppTheme.warning)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard('🎓 Courses', '${courseGroups.length}', AppTheme.success)),
            ],
          ),
          const SizedBox(height: 16),
          
          // Course-wise Groups
          ...courseGroups.entries.map((entry) {
            final courseName = entry.key;
            final payments = entry.value;
            final coursePending = payments.fold<int>(0, (sum, p) => sum + (p['pendingAmount'] as int));
            final coursePaid = payments.fold<int>(0, (sum, p) => sum + (p['paidAmount'] as int));
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3), width: 2),
              ),
              child: Column(
                children: [
                  // Course Header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppTheme.primaryBlue, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.school, color: AppTheme.white, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(courseName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              Text('${payments.length} student(s)', style: const TextStyle(fontSize: 10, color: AppTheme.mediumGray)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppTheme.warning, borderRadius: BorderRadius.circular(6)),
                          child: Text('₹${NumberFormat('#,##,###').format(coursePending)}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.white)),
                        ),
                      ],
                    ),
                  ),
                  
                  // Course Stats
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: AppTheme.lightGray.withOpacity(0.3),
                    child: Row(
                      children: [
                        Expanded(child: _buildCourseDetailItem('✅ Paid', '₹${NumberFormat('#,##,###').format(coursePaid)}')),
                        Expanded(child: _buildCourseDetailItem('⏳ Pending', '₹${NumberFormat('#,##,###').format(coursePending)}')),
                        Expanded(child: _buildCourseDetailItem('👥 Students', '${payments.length}')),
                      ],
                    ),
                  ),
                  
                  // Student Cards
                  ...payments.map((payment) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppTheme.lightGray.withOpacity(0.5)))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: AppTheme.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                              child: Center(child: Text(payment['studentName'].toString().substring(0, 1), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.warning))),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(payment['studentName'].toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  Text('ID: ${payment['studentId']} • ${payment['semester']}', style: const TextStyle(fontSize: 9, color: AppTheme.mediumGray)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('₹${NumberFormat('#,##,###').format(payment['pendingAmount'])}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.warning)),
                                Text('Due: ${DateFormat('dd MMM').format(payment['dueDate'] as DateTime)}', style: const TextStyle(fontSize: 8, color: AppTheme.error)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('📧 Email', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                              Text(payment['email'].toString(), style: const TextStyle(fontSize: 9), overflow: TextOverflow.ellipsis),
                            ])),
                            const SizedBox(width: 8),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('📞 Phone', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                              Text(payment['phone'].toString(), style: const TextStyle(fontSize: 9)),
                            ])),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('🤝 Consultant', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                              Text(payment['consultant'].toString(), style: const TextStyle(fontSize: 9)),
                            ])),
                            const SizedBox(width: 8),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('✅ Paid', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                              Text('₹${NumberFormat('#,##,###').format(payment['paidAmount'])}', style: const TextStyle(fontSize: 9, color: AppTheme.success)),
                            ])),
                          ],
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
  
  // 3️⃣ Commission Report Tab - Complete Implementation
  Widget _buildCommissionReportTab() {
    final commissionData = [
      {'consultantName': 'EduConnect Agency', 'code': 'CON001', 'course': 'BNYS', 'shareType': 'Percentage', 'shareValue': 15, 'students': 1, 'totalFee': 120000, 'commission': 18000, 'universityProfit': 102000},
      {'consultantName': 'EduConnect Agency', 'code': 'CON001', 'course': 'B.Tech CS', 'shareType': 'Percentage', 'shareValue': 12, 'students': 1, 'totalFee': 500000, 'commission': 60000, 'universityProfit': 440000},
      {'consultantName': 'TechConsult', 'code': 'CON003', 'course': 'BNYS', 'shareType': 'Flat', 'shareValue': 25000, 'students': 1, 'totalFee': 120000, 'commission': 25000, 'universityProfit': 95000},
      {'consultantName': 'AlphaEdu Consultants', 'code': 'CON002', 'course': 'BPT', 'shareType': 'Percentage', 'shareValue': 18, 'students': 2, 'totalFee': 220000, 'commission': 39600, 'universityProfit': 180400},
      {'consultantName': 'Global Edu Partners', 'code': 'CON004', 'course': 'B.Tech CS', 'shareType': 'Percentage', 'shareValue': 10, 'students': 1, 'totalFee': 500000, 'commission': 50000, 'universityProfit': 450000},
    ];
    
    final totalCommission = commissionData.fold<int>(0, (sum, c) => sum + (c['commission'] as int));
    final totalProfit = commissionData.fold<int>(0, (sum, c) => sum + (c['universityProfit'] as int));
    final totalStudents = commissionData.fold<int>(0, (sum, c) => sum + (c['students'] as int));
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard('👥 Students', '$totalStudents', AppTheme.primaryBlue)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard('💰 Commission', '₹${NumberFormat('#,##,###').format(totalCommission)}', AppTheme.warning)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard('🏦 Profit', '₹${NumberFormat('#,##,###').format(totalProfit)}', AppTheme.success)),
            ],
          ),
          const SizedBox(height: 16),
          
          ...commissionData.map((data) {
            final shareDisplay = data['shareType'] == 'Percentage' 
                ? '${data['shareValue']}%' 
                : '₹${NumberFormat('#,##,###').format(data['shareValue'])}';
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.warning.withOpacity(0.3), width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: AppTheme.warning,
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: Center(
                            child: Text(
                              data['consultantName'].toString().substring(0, 1),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['consultantName'].toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              Text('Code: ${data['code']} • ${data['course']}', style: const TextStyle(fontSize: 10, color: AppTheme.mediumGray)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(data['shareType'].toString(), style: const TextStyle(fontSize: 9, color: AppTheme.white, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 3),
                            Text(shareDisplay, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.warning)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Column(children: [
                              const Text('👥 Students', style: TextStyle(fontSize: 9, color: AppTheme.mediumGray)),
                              Text('${data['students']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ])),
                            Expanded(child: Column(children: [
                              const Text('💰 Total Fee', style: TextStyle(fontSize: 9, color: AppTheme.mediumGray)),
                              Text('₹${NumberFormat('#,##,###').format(data['totalFee'])}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ])),
                            Expanded(child: Column(children: [
                              const Text('🤝 Commission', style: TextStyle(fontSize: 9, color: AppTheme.mediumGray)),
                              Text('₹${NumberFormat('#,##,###').format(data['commission'])}', style: const TextStyle(fontSize: 10, color: AppTheme.warning, fontWeight: FontWeight.bold)),
                            ])),
                            Expanded(child: Column(children: [
                              const Text('🏦 Profit', style: TextStyle(fontSize: 9, color: AppTheme.mediumGray)),
                              Text('₹${NumberFormat('#,##,###').format(data['universityProfit'])}', style: const TextStyle(fontSize: 10, color: AppTheme.success, fontWeight: FontWeight.bold)),
                            ])),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showCommissionDetailDialog(data),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            icon: const Icon(Icons.visibility, size: 14, color: AppTheme.white),
                            label: const Text('View Details', style: TextStyle(fontSize: 11, color: AppTheme.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
  
  // 4️⃣ Admission Status Tab - Course-wise
  Widget _buildAdmissionStatusTab() {
    final mockAdmissions = [
      {'studentName': 'Rahul Kumar', 'studentId': 'STU001', 'email': 'rahul@email.com', 'phone': '+91 9876543210',
       'course': 'BNYS', 'consultant': 'EduConnect', 'status': 'Approved', 'feeStatus': 'Paid', 'appliedDate': DateTime(2025, 10, 15)},
      {'studentName': 'Amit Patel', 'studentId': 'STU003', 'email': 'amit@email.com', 'phone': '+91 9876543212',
       'course': 'BNYS', 'consultant': 'TechConsult', 'status': 'Approved', 'feeStatus': 'Partially Paid', 'appliedDate': DateTime(2025, 10, 20)},
      {'studentName': 'Priya Sharma', 'studentId': 'STU002', 'email': 'priya@email.com', 'phone': '+91 9876543211',
       'course': 'BPT', 'consultant': 'AlphaEdu', 'status': 'Pending', 'feeStatus': 'Pending', 'appliedDate': DateTime(2025, 11, 1)},
    ];
    
    final approved = mockAdmissions.where((s) => s['status'] == 'Approved').length;
    final pending = mockAdmissions.where((s) => s['status'] == 'Pending').length;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard('✅ Approved', '$approved', AppTheme.success)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard('⏳ Pending', '$pending', AppTheme.warning)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard('📊 Total', '${mockAdmissions.length}', AppTheme.primaryBlue)),
            ],
          ),
          const SizedBox(height: 12),
          ...mockAdmissions.map((student) {
            final statusColor = student['status'] == 'Approved' ? AppTheme.success : AppTheme.warning;
            final feeColor = student['feeStatus'] == 'Paid' ? AppTheme.success : student['feeStatus'] == 'Partially Paid' ? AppTheme.warning : AppTheme.error;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: statusColor.withOpacity(0.3), width: 2)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text(student['studentName'].toString().substring(0, 1), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: statusColor))),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(student['studentName'].toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('ID: ${student['studentId']} • ${DateFormat('dd MMM yyyy').format(student['appliedDate'] as DateTime)}', style: const TextStyle(fontSize: 9, color: AppTheme.mediumGray)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                            child: Text(student['status'].toString(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: statusColor)),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(color: feeColor.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                            child: Text(student['feeStatus'].toString(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: feeColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 12),
                  Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('🎓 Course', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                        Text(student['course'].toString(), style: const TextStyle(fontSize: 10)),
                      ])),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('🤝 Consultant', style: TextStyle(fontSize: 8, color: AppTheme.mediumGray)),
                        Text(student['consultant'].toString(), style: const TextStyle(fontSize: 10)),
                      ])),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
  
  // 5️⃣ Student Export Tab - With Report Selection
  Widget _buildStudentExportTab() {
    final selectedCount = [_selectTotalFees, _selectPendingPayments, _selectCommissionReport, _selectAdmissionStatus]
        .where((selected) => selected).length;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Export Format Selection
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.settings, color: AppTheme.primaryBlue, size: 20),
                    const SizedBox(width: 8),
                    const Text('📥 Export Configuration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _exportFormat,
                  decoration: const InputDecoration(
                    labelText: 'Export Format',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 12),
                  items: [
                    DropdownMenuItem(value: 'Excel', child: Row(children: [
                      const Icon(Icons.table_chart, size: 16, color: AppTheme.success),
                      const SizedBox(width: 8),
                      const Text('Excel (.xlsx)'),
                    ])),
                    DropdownMenuItem(value: 'PDF', child: Row(children: [
                      const Icon(Icons.picture_as_pdf, size: 16, color: AppTheme.error),
                      const SizedBox(width: 8),
                      const Text('PDF (.pdf)'),
                    ])),
                    DropdownMenuItem(value: 'CSV', child: Row(children: [
                      const Icon(Icons.description, size: 16, color: AppTheme.warning),
                      const SizedBox(width: 8),
                      const Text('CSV (.csv)'),
                    ])),
                  ],
                  onChanged: (v) => setState(() => _exportFormat = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Report Selection
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.success.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.checklist, color: AppTheme.success, size: 20),
                    const SizedBox(width: 8),
                    const Text('📊 Select Reports to Export', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Selected: $selectedCount report${selectedCount != 1 ? 's' : ''}',
                  style: TextStyle(fontSize: 11, color: selectedCount > 0 ? AppTheme.success : AppTheme.mediumGray),
                ),
                const Divider(height: 16),
                
                // Total Fees Report
                _buildReportCheckbox(
                  title: '💰 Total Fees Report',
                  description: 'Complete fee collection details with student-wise breakdown',
                  value: _selectTotalFees,
                  onChanged: (val) => setState(() => _selectTotalFees = val!),
                  color: AppTheme.success,
                ),
                const SizedBox(height: 10),
                
                // Pending Payments Report
                _buildReportCheckbox(
                  title: '⏳ Pending Payments Report',
                  description: 'Outstanding payments with due dates and installment details',
                  value: _selectPendingPayments,
                  onChanged: (val) => setState(() => _selectPendingPayments = val!),
                  color: AppTheme.warning,
                ),
                const SizedBox(height: 10),
                
                // Commission Report
                _buildReportCheckbox(
                  title: '🤝 Commission Report',
                  description: 'Consultant commission breakdown and university profit margins',
                  value: _selectCommissionReport,
                  onChanged: (val) => setState(() => _selectCommissionReport = val!),
                  color: AppTheme.warning,
                ),
                const SizedBox(height: 10),
                
                // Admission Status Report
                _buildReportCheckbox(
                  title: '📋 Admission Status Report',
                  description: 'Student admission status with fee payment tracking',
                  value: _selectAdmissionStatus,
                  onChanged: (val) => setState(() => _selectAdmissionStatus = val!),
                  color: AppTheme.primaryBlue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: selectedCount > 0 ? () {
                    setState(() {
                      _selectTotalFees = false;
                      _selectPendingPayments = false;
                      _selectCommissionReport = false;
                      _selectAdmissionStatus = false;
                    });
                  } : null,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    side: BorderSide(color: selectedCount > 0 ? AppTheme.error : AppTheme.lightGray),
                  ),
                  icon: Icon(Icons.clear_all, size: 16, color: selectedCount > 0 ? AppTheme.error : AppTheme.mediumGray),
                  label: Text('Clear All', style: TextStyle(fontSize: 11, color: selectedCount > 0 ? AppTheme.error : AppTheme.mediumGray)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectTotalFees = true;
                      _selectPendingPayments = true;
                      _selectCommissionReport = true;
                      _selectAdmissionStatus = true;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    side: const BorderSide(color: AppTheme.primaryBlue),
                  ),
                  icon: const Icon(Icons.select_all, size: 16, color: AppTheme.primaryBlue),
                  label: const Text('Select All', style: TextStyle(fontSize: 11, color: AppTheme.primaryBlue)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          // Generate Report Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: selectedCount > 0 ? () => _generateSelectedReports() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedCount > 0 ? AppTheme.success : AppTheme.lightGray,
                padding: const EdgeInsets.all(14),
                elevation: selectedCount > 0 ? 2 : 0,
              ),
              icon: Icon(Icons.download, size: 18, color: selectedCount > 0 ? AppTheme.white : AppTheme.mediumGray),
              label: Text(
                selectedCount > 0 
                    ? 'Download $selectedCount Report${selectedCount != 1 ? 's' : ''} ($_exportFormat)' 
                    : 'Select Reports to Export',
                style: TextStyle(fontSize: 12, color: selectedCount > 0 ? AppTheme.white : AppTheme.mediumGray, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          // Info Card
          if (selectedCount > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reports will be exported in $_exportFormat format with current filter settings',
                      style: const TextStyle(fontSize: 10, color: AppTheme.charcoal),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildReportCheckbox({
    required String title,
    required String description,
    required bool value,
    required Function(bool?) onChanged,
    required Color color,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: value ? color.withOpacity(0.05) : null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: value ? color.withOpacity(0.5) : AppTheme.lightGray,
            width: value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: color,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(description, style: const TextStyle(fontSize: 10, color: AppTheme.mediumGray)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _generateSelectedReports() {
    final selectedReports = <String>[];
    if (_selectTotalFees) selectedReports.add('Total Fees');
    if (_selectPendingPayments) selectedReports.add('Pending Payments');
    if (_selectCommissionReport) selectedReports.add('Commission Report');
    if (_selectAdmissionStatus) selectedReports.add('Admission Status');
    
    if (selectedReports.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please select at least one report'), backgroundColor: AppTheme.warning),
      );
      return;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📥 Downloading ${selectedReports.length} report(s) in $_exportFormat format:\n${selectedReports.join(', ')}'),
        backgroundColor: AppTheme.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  // Dialog Methods
  void _showStudentDetailDialog(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(23),
              ),
              child: Center(
                child: Text(
                  student['studentName'].toString().substring(0, 1),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student['studentName'].toString(), style: const TextStyle(fontSize: 14)),
                  Text('ID: ${student['studentId']}', style: const TextStyle(fontSize: 11, color: AppTheme.mediumGray)),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('🎓 Course', student['course'].toString()),
              _buildDetailRow('💰 Course Fee', '₹${NumberFormat('#,##,###').format(student['courseFee'])}'),
              _buildDetailRow('✅ Paid', '₹${NumberFormat('#,##,###').format(student['paid'])}'),
              _buildDetailRow('⏳ Pending', '₹${NumberFormat('#,##,###').format(student['pending'])}'),
              _buildDetailRow('📚 Semester', student['semester'].toString()),
              _buildDetailRow('🤝 Consultant', student['consultancy'].toString()),
              _buildDetailRow('🆔 Consultant Code', student['consultancyCode'].toString()),
              _buildDetailRow('📅 Last Payment', DateFormat('dd MMM yyyy').format(student['lastPayment'] as DateTime)),
              _buildDetailRow('📊 Year', student['year'].toString()),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppTheme.success, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Payment: ${((student['paid'] as int) / (student['courseFee'] as int) * 100).toStringAsFixed(1)}% Complete',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.success),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
  
  void _showCommissionDetailDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppTheme.warning,
                borderRadius: BorderRadius.circular(23),
              ),
              child: Center(
                child: Text(
                  data['consultantName'].toString().substring(0, 1),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.white),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['consultantName'].toString(), style: const TextStyle(fontSize: 14)),
                  Text('Code: ${data['code']}', style: const TextStyle(fontSize: 11, color: AppTheme.mediumGray)),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('🎓 Course', data['course'].toString()),
              _buildDetailRow('📋 Share Type', data['shareType'].toString()),
              _buildDetailRow('💎 Share Value', 
                data['shareType'] == 'Percentage' 
                  ? '${data['shareValue']}%' 
                  : '₹${NumberFormat('#,##,###').format(data['shareValue'])}'),
              const Divider(height: 20),
              _buildDetailRow('👥 Total Students', '${data['students']}'),
              _buildDetailRow('💰 Total Fee', '₹${NumberFormat('#,##,###').format(data['totalFee'])}'),
              _buildDetailRow('🤝 Commission', '₹${NumberFormat('#,##,###').format(data['commission'])}'),
              _buildDetailRow('🏦 University Profit', '₹${NumberFormat('#,##,###').format(data['universityProfit'])}'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Commission Rate:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        Text('${((data['commission'] as int) / (data['totalFee'] as int) * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.warning)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('University Share:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        Text('${((data['universityProfit'] as int) / (data['totalFee'] as int) * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.success)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.mediumGray)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
