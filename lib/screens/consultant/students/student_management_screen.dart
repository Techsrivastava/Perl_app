import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() => _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedUniversity = 'All';
  String _selectedCourse = 'All';
  
  final List<Map<String, dynamic>> _allStudents = [
    {
      'student_id': 'STU5010',
      'name': 'Rahul Kumar',
      'father_name': 'Suresh Kumar',
      'mother_name': 'Anita Kumar',
      'mobile': '9876543210',
      'email': 'rahul@example.com',
      'dob': '15/08/2005',
      'gender': 'Male',
      'category': 'General',
      'address': '123 MG Road, Gandhi Nagar',
      'city': 'Mumbai',
      'state': 'Maharashtra',
      'pincode': '400001',
      'course': 'BNYS',
      'university': 'Sunrise University',
      'mode': 'Regular',
      'duration': '4 Years',
      'added_by': 'Consultant',
      'agent': 'Self',
      'status': 'Admission Approved',
      'registered_date': '2024-10-15',
      '10th_board': 'CBSE',
      '10th_marks': '85%',
      '10th_year': '2020',
      '12th_board': 'CBSE',
      '12th_marks': '78%',
      '12th_year': '2022',
      'total_fee': 35000,
      'paid_amount': 15000,
      'pending_amount': 20000,
      'payment_status': 'Partial',
      'utr_number': 'UTR123456789',
      'consultant_share': 5000,
      'documents': ['10th', '12th', 'Aadhar', 'TC', 'Photo'],
      'documents_verified': true,
      'remarks': 'All documents verified. Payment in progress.',
      'university_remarks': '',
    },
    {
      'student_id': 'STU5011',
      'name': 'Priya Sharma',
      'father_name': 'Rajesh Sharma',
      'mother_name': 'Sunita Sharma',
      'mobile': '9123456789',
      'email': 'priya@example.com',
      'dob': '22/03/2004',
      'gender': 'Female',
      'category': 'OBC',
      'address': '45 Park Street, Sector 12',
      'city': 'Pune',
      'state': 'Maharashtra',
      'pincode': '411001',
      'course': 'BCA',
      'university': 'MIT University',
      'mode': 'Regular',
      'duration': '3 Years',
      'added_by': 'Agent',
      'agent': 'Rakesh Consultancy',
      'status': 'Applied',
      'registered_date': '2024-11-01',
      '10th_board': 'State Board',
      '10th_marks': '88%',
      '10th_year': '2019',
      '12th_board': 'State Board',
      '12th_marks': '82%',
      '12th_year': '2021',
      'total_fee': 150000,
      'paid_amount': 0,
      'pending_amount': 150000,
      'payment_status': 'Pending',
      'utr_number': '',
      'consultant_share': 15000,
      'documents': ['10th', '12th', 'Aadhar'],
      'documents_verified': false,
      'remarks': 'Application forwarded to university',
      'university_remarks': '',
    },
    {
      'student_id': 'STU5012',
      'name': 'Amit Verma',
      'father_name': 'Vikas Verma',
      'mother_name': 'Meena Verma',
      'mobile': '9988776655',
      'email': 'amit@example.com',
      'dob': '10/12/2003',
      'gender': 'Male',
      'category': 'General',
      'address': '78 Civil Lines, North Block',
      'city': 'Dehradun',
      'state': 'Uttarakhand',
      'pincode': '248001',
      'course': 'MBA',
      'university': 'Excellence University',
      'mode': 'Regular',
      'duration': '2 Years',
      'added_by': 'Consultant',
      'agent': 'Self',
      'status': 'Reverted',
      'registered_date': '2024-10-28',
      '10th_board': 'CBSE',
      '10th_marks': '75%',
      '10th_year': '2018',
      '12th_board': 'CBSE',
      '12th_marks': '72%',
      '12th_year': '2020',
      'total_fee': 95000,
      'paid_amount': 10000,
      'pending_amount': 85000,
      'payment_status': 'Pending',
      'utr_number': '',
      'consultant_share': 9500,
      'documents': ['10th', '12th', 'Aadhar'],
      'documents_verified': false,
      'remarks': 'TC document missing - please upload',
      'university_remarks': 'Transfer Certificate not submitted. Please upload within 7 days.',
    },
    {
      'student_id': 'STU5013',
      'name': 'Sneha Patel',
      'father_name': 'Ramesh Patel',
      'mother_name': 'Kavita Patel',
      'mobile': '9876501234',
      'email': 'sneha@example.com',
      'dob': '05/06/2005',
      'gender': 'Female',
      'category': 'General',
      'address': '12 Station Road, Model Town',
      'city': 'Ahmedabad',
      'state': 'Gujarat',
      'pincode': '380001',
      'course': 'B.Sc Data Science',
      'university': 'Global Tech University',
      'mode': 'Regular',
      'duration': '3 Years',
      'added_by': 'Agent',
      'agent': 'Patel Consultancy',
      'status': 'Lead',
      'registered_date': '2024-11-05',
      '10th_board': 'GSEB',
      '10th_marks': '90%',
      '10th_year': '2020',
      '12th_board': 'GSEB',
      '12th_marks': '87%',
      '12th_year': '2022',
      'total_fee': 120000,
      'paid_amount': 0,
      'pending_amount': 120000,
      'payment_status': 'Not Started',
      'utr_number': '',
      'consultant_share': 12000,
      'documents': [],
      'documents_verified': false,
      'remarks': 'Initial inquiry - follow up needed',
      'university_remarks': '',
    },
    {
      'student_id': 'STU5014',
      'name': 'Vikram Singh',
      'father_name': 'Ajay Singh',
      'mother_name': 'Priya Singh',
      'mobile': '9654321098',
      'email': 'vikram@example.com',
      'dob': '18/09/2004',
      'gender': 'Male',
      'category': 'SC',
      'address': '34 Ring Road, Sector 5',
      'city': 'Jaipur',
      'state': 'Rajasthan',
      'pincode': '302001',
      'course': 'Diploma in Nursing',
      'university': 'Healthcare Hub',
      'mode': 'Regular',
      'duration': '2 Years',
      'added_by': 'Consultant',
      'agent': 'Self',
      'status': 'Rejected',
      'registered_date': '2024-10-20',
      '10th_board': 'RBSE',
      '10th_marks': '65%',
      '10th_year': '2019',
      '12th_board': 'RBSE',
      '12th_marks': '48%',
      '12th_year': '2021',
      'total_fee': 65000,
      'paid_amount': 0,
      'pending_amount': 65000,
      'payment_status': 'Not Started',
      'utr_number': '',
      'consultant_share': 0,
      'documents': ['10th', '12th', 'Aadhar'],
      'documents_verified': false,
      'remarks': 'Application rejected by university',
      'university_remarks': 'Rejected - Below 50% in 12th standard. Minimum eligibility not met.',
    },
    {
      'student_id': 'STU5015',
      'name': 'Anjali Desai',
      'father_name': 'Manoj Desai',
      'mother_name': 'Rekha Desai',
      'mobile': '9871234567',
      'email': 'anjali.desai@example.com',
      'dob': '12/01/2005',
      'gender': 'Female',
      'category': 'General',
      'address': '67 Lake View Road, Sector 8',
      'city': 'Bangalore',
      'state': 'Karnataka',
      'pincode': '560001',
      'course': 'B.Tech Computer Science',
      'university': 'MIT University',
      'mode': 'Regular',
      'duration': '4 Years',
      'added_by': 'Agent',
      'agent': 'Tech Consultancy',
      'status': 'Admission Approved',
      'registered_date': '2024-10-22',
      '10th_board': 'ICSE',
      '10th_marks': '92%',
      '10th_year': '2020',
      '12th_board': 'ICSE',
      '12th_marks': '88%',
      '12th_year': '2022',
      'total_fee': 180000,
      'paid_amount': 50000,
      'pending_amount': 130000,
      'payment_status': 'Partial',
      'utr_number': 'UTR987654321',
      'consultant_share': 18000,
      'documents': ['10th', '12th', 'Aadhar', 'TC', 'Photo'],
      'documents_verified': true,
      'remarks': 'Excellent student, all documents submitted',
      'university_remarks': '',
    },
    {
      'student_id': 'STU5016',
      'name': 'Karan Malhotra',
      'father_name': 'Vikram Malhotra',
      'mother_name': 'Geeta Malhotra',
      'mobile': '9654123789',
      'email': 'karan.m@example.com',
      'dob': '25/07/2004',
      'gender': 'Male',
      'category': 'General',
      'address': '89 Mall Road, Central Avenue',
      'city': 'Chandigarh',
      'state': 'Chandigarh',
      'pincode': '160001',
      'course': 'BBA',
      'university': 'Excellence University',
      'mode': 'Regular',
      'duration': '3 Years',
      'added_by': 'Consultant',
      'agent': 'Self',
      'status': 'Applied',
      'registered_date': '2024-11-03',
      '10th_board': 'CBSE',
      '10th_marks': '80%',
      '10th_year': '2019',
      '12th_board': 'CBSE',
      '12th_marks': '76%',
      '12th_year': '2021',
      'total_fee': 110000,
      'paid_amount': 0,
      'pending_amount': 110000,
      'payment_status': 'Pending',
      'utr_number': '',
      'consultant_share': 11000,
      'documents': ['10th', '12th', 'Aadhar'],
      'documents_verified': false,
      'remarks': 'Documents pending submission',
      'university_remarks': '',
    },
    {
      'student_id': 'STU5017',
      'name': 'Neha Kapoor',
      'father_name': 'Sunil Kapoor',
      'mother_name': 'Asha Kapoor',
      'mobile': '9123987654',
      'email': 'neha.k@example.com',
      'dob': '08/11/2005',
      'gender': 'Female',
      'category': 'OBC',
      'address': '23 Garden Street, Rose Colony',
      'city': 'Lucknow',
      'state': 'Uttar Pradesh',
      'pincode': '226001',
      'course': 'B.Sc Nursing',
      'university': 'Healthcare Hub',
      'mode': 'Regular',
      'duration': '4 Years',
      'added_by': 'Agent',
      'agent': 'Medical Consultancy',
      'status': 'Admission Approved',
      'registered_date': '2024-10-18',
      '10th_board': 'UP Board',
      '10th_marks': '82%',
      '10th_year': '2020',
      '12th_board': 'UP Board',
      '12th_marks': '79%',
      '12th_year': '2022',
      'total_fee': 85000,
      'paid_amount': 85000,
      'pending_amount': 0,
      'payment_status': 'Paid',
      'utr_number': 'UTR555666777',
      'consultant_share': 8500,
      'documents': ['10th', '12th', 'Aadhar', 'TC', 'Photo'],
      'documents_verified': true,
      'remarks': 'Full fee paid, admission confirmed',
      'university_remarks': '',
    },
    {
      'student_id': 'STU5018',
      'name': 'Rohan Gupta',
      'father_name': 'Anil Gupta',
      'mother_name': 'Savita Gupta',
      'mobile': '9988112233',
      'email': 'rohan.g@example.com',
      'dob': '30/04/2004',
      'gender': 'Male',
      'category': 'General',
      'address': '45 New Market, Sector 15',
      'city': 'Noida',
      'state': 'Uttar Pradesh',
      'pincode': '201301',
      'course': 'M.Tech',
      'university': 'Global Tech University',
      'mode': 'Regular',
      'duration': '2 Years',
      'added_by': 'Consultant',
      'agent': 'Self',
      'status': 'Reverted',
      'registered_date': '2024-10-25',
      '10th_board': 'CBSE',
      '10th_marks': '88%',
      '10th_year': '2017',
      '12th_board': 'CBSE',
      '12th_marks': '84%',
      '12th_year': '2019',
      'total_fee': 145000,
      'paid_amount': 20000,
      'pending_amount': 125000,
      'payment_status': 'Pending',
      'utr_number': '',
      'consultant_share': 14500,
      'documents': ['10th', '12th', 'Aadhar'],
      'documents_verified': false,
      'remarks': 'Graduation certificate pending',
      'university_remarks': 'Bachelor degree certificate required for M.Tech admission. Please upload within 5 days.',
    },
    {
      'student_id': 'STU5019',
      'name': 'Divya Reddy',
      'father_name': 'Krishna Reddy',
      'mother_name': 'Lakshmi Reddy',
      'mobile': '9876009876',
      'email': 'divya.r@example.com',
      'dob': '14/09/2005',
      'gender': 'Female',
      'category': 'General',
      'address': '78 Temple Road, Jubilee Hills',
      'city': 'Hyderabad',
      'state': 'Telangana',
      'pincode': '500001',
      'course': 'B.Pharma',
      'university': 'Sunrise University',
      'mode': 'Regular',
      'duration': '4 Years',
      'added_by': 'Agent',
      'agent': 'Pharma Consultancy',
      'status': 'Applied',
      'registered_date': '2024-11-02',
      '10th_board': 'State Board',
      '10th_marks': '86%',
      '10th_year': '2020',
      '12th_board': 'State Board',
      '12th_marks': '81%',
      '12th_year': '2022',
      'total_fee': 125000,
      'paid_amount': 25000,
      'pending_amount': 100000,
      'payment_status': 'Partial',
      'utr_number': 'UTR444555666',
      'consultant_share': 12500,
      'documents': ['10th', '12th', 'Aadhar', 'Photo'],
      'documents_verified': false,
      'remarks': 'Application under review',
      'university_remarks': '',
    },
    {
      'student_id': 'STU5020',
      'name': 'Arjun Sinha',
      'father_name': 'Deepak Sinha',
      'mother_name': 'Rina Sinha',
      'mobile': '9654987321',
      'email': 'arjun.s@example.com',
      'dob': '20/03/2005',
      'gender': 'Male',
      'category': 'SC',
      'address': '12 Station Road, Gandhi Nagar',
      'city': 'Patna',
      'state': 'Bihar',
      'pincode': '800001',
      'course': 'B.Com',
      'university': 'Excellence University',
      'mode': 'Distance',
      'duration': '3 Years',
      'added_by': 'Consultant',
      'agent': 'Self',
      'status': 'Lead',
      'registered_date': '2024-11-06',
      '10th_board': 'Bihar Board',
      '10th_marks': '70%',
      '10th_year': '2020',
      '12th_board': 'Bihar Board',
      '12th_marks': '68%',
      '12th_year': '2022',
      'total_fee': 45000,
      'paid_amount': 0,
      'pending_amount': 45000,
      'payment_status': 'Not Started',
      'utr_number': '',
      'consultant_share': 4500,
      'documents': [],
      'documents_verified': false,
      'remarks': 'Just inquired, need follow-up',
      'university_remarks': '',
    },
    {
      'student_id': 'STU5021',
      'name': 'Pooja Iyer',
      'father_name': 'Venkat Iyer',
      'mother_name': 'Radha Iyer',
      'mobile': '9445566778',
      'email': 'pooja.iyer@example.com',
      'dob': '16/12/2004',
      'gender': 'Female',
      'category': 'General',
      'address': '90 Beach Road, Marina',
      'city': 'Chennai',
      'state': 'Tamil Nadu',
      'pincode': '600001',
      'course': 'M.Sc Data Science',
      'university': 'Global Tech University',
      'mode': 'Regular',
      'duration': '2 Years',
      'added_by': 'Agent',
      'agent': 'Tech Consultancy',
      'status': 'Admission Approved',
      'registered_date': '2024-10-12',
      '10th_board': 'CBSE',
      '10th_marks': '95%',
      '10th_year': '2018',
      '12th_board': 'CBSE',
      '12th_marks': '92%',
      '12th_year': '2020',
      'total_fee': 165000,
      'paid_amount': 165000,
      'pending_amount': 0,
      'payment_status': 'Paid',
      'utr_number': 'UTR111222333',
      'consultant_share': 16500,
      'documents': ['10th', '12th', 'Aadhar', 'TC', 'Photo', 'Migration'],
      'documents_verified': true,
      'remarks': 'Topnotch student, full scholarship candidate',
      'university_remarks': '',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _viewStudent(Map<String, dynamic> student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _StudentDetailsView(student: student),
      ),
    );
  }

  void _editStudent(Map<String, dynamic> student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _EditStudentForm(
          student: student,
          onSave: (updatedData) {
            setState(() {
              student.addAll(updatedData);
            });
          },
        ),
      ),
    );
  }

  void _deleteStudent(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Delete ${student['name']}? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => _allStudents.remove(student));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Student deleted successfully'), backgroundColor: Colors.red),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _forwardToUniversity(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Forward Application'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Forward this application to university for verification?'),
            const SizedBox(height: 12),
            Text('Student: ${student['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('University: ${student['university']}'),
            Text('Course: ${student['course']}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => student['status'] = 'Applied');
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Application forwarded successfully'), backgroundColor: Colors.green),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Forward'),
          ),
        ],
      ),
    );
  }

  void _trackApplication(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primaryBlue, Color(0xFF1565C0)]),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.track_changes, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Track Application', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(student['student_id'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Student Info
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person, size: 20, color: AppTheme.primaryBlue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text('${student['course']} - ${student['university']}', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Timeline
                      const Text('Application Timeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                      const SizedBox(height: 16),
                      
                      _buildTimelineItem('Application Registered', student['registered_date'], 'Student added to system', Colors.blue, true),
                      _buildTimelineItem('Documents Uploaded', _getDocumentUploadDate(student), '${student['documents'].length} documents submitted', student['documents'].isNotEmpty ? Colors.green : Colors.grey, student['documents'].isNotEmpty),
                      _buildTimelineItem('Application Submitted', student['status'] == 'Applied' || student['status'] == 'Admission Approved' || student['status'] == 'Reverted' ? student['registered_date'] : '', 'Forwarded to university', student['status'] != 'Lead' ? Colors.orange : Colors.grey, student['status'] != 'Lead'),
                      _buildTimelineItem('University Review', student['status'] == 'Admission Approved' || student['status'] == 'Reverted' || student['status'] == 'Rejected' ? student['registered_date'] : '', 'Under verification', student['status'] == 'Admission Approved' || student['status'] == 'Reverted' || student['status'] == 'Rejected' ? Colors.purple : Colors.grey, student['status'] == 'Admission Approved' || student['status'] == 'Reverted' || student['status'] == 'Rejected'),
                      _buildTimelineItem('Admission Approved', student['status'] == 'Admission Approved' ? student['registered_date'] : '', 'Admission confirmed', student['status'] == 'Admission Approved' ? Colors.green : Colors.grey, student['status'] == 'Admission Approved', isLast: true),
                      
                      if (student['status'] == 'Reverted') ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber, color: Colors.red, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Action Required', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(student['university_remarks'] ?? 'Please correct the application', style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      if (student['status'] == 'Rejected') ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[900]!.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[900]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.cancel, color: Colors.red, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Application Rejected', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(student['university_remarks'] ?? 'Application declined', style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDocumentUploadDate(Map<String, dynamic> student) {
    return student['documents'].isNotEmpty ? student['registered_date'] : '';
  }

  Widget _buildTimelineItem(String title, String date, String description, Color color, bool isActive, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive ? color : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                isActive ? Icons.check : Icons.circle,
                color: Colors.white,
                size: 16,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isActive ? color.withValues(alpha: 0.3) : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? color : Colors.grey)),
              if (date.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
              const SizedBox(height: 4),
              Text(description, style: TextStyle(fontSize: 12, color: isActive ? Colors.grey[700] : Colors.grey)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Admission Approved': return Colors.green;
      case 'Applied': return Colors.orange;
      case 'Reverted': return Colors.red;
      case 'Rejected': return Colors.red[900]!;
      default: return Colors.blue;
    }
  }

  Widget _buildMiniCard(String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[700])),
          const SizedBox(height: 3),
          Text(amount, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600]), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredStudents {
    return _allStudents.where((s) {
      final matchesSearch = _searchQuery.isEmpty || s['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      final tabIndex = _tabController.index;
      if (tabIndex == 1) return s['status'] == 'Applied' && matchesSearch;
      if (tabIndex == 2) return s['status'] == 'Admission Approved' && matchesSearch;
      if (tabIndex == 3) return s['status'] == 'Reverted' && matchesSearch;
      if (tabIndex == 4) return s['status'] == 'Rejected' && matchesSearch;
      return matchesSearch;
    }).toList();
  }

  int _getStatusCount(String status) {
    if (status == 'All') return _allStudents.length;
    return _allStudents.where((s) => s['status'] == status).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Student Management'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.people, size: 16), const SizedBox(width: 6), Text('All (${_getStatusCount('All')})')])),
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.hourglass_empty, size: 16), const SizedBox(width: 6), Text('Applied (${_getStatusCount('Applied')})')])),
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.check_circle, size: 16), const SizedBox(width: 6), Text('Admission Approved (${_getStatusCount('Admission Approved')})')])),
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.refresh, size: 16), const SizedBox(width: 6), Text('Reverted (${_getStatusCount('Reverted')})')])),
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cancel, size: 16), const SizedBox(width: 6), Text('Rejected (${_getStatusCount('Rejected')})')])),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(child: _buildStatCard('Total', _allStudents.length.toString(), Icons.people, Colors.blue)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard('Approved', _getStatusCount('Admission Approved').toString(), Icons.check_circle, Colors.green)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard('Applied', _getStatusCount('Applied').toString(), Icons.hourglass_empty, Colors.orange)),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard('Reverted', _getStatusCount('Reverted').toString(), Icons.refresh, Colors.red)),
              ],
            ),
          ),
          
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search by name, ID, or mobile...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(5, (_) => _buildStudentList()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    final students = _filteredStudents;
    if (students.isEmpty) {
      return const Center(child: Text('No students found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: students.length,
      itemBuilder: (context, index) => _buildStudentCard(students[index]),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getStatusColor(student['status']).withValues(alpha: 0.2), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_getStatusColor(student['status']).withValues(alpha: 0.1), _getStatusColor(student['status']).withValues(alpha: 0.03)],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [_getStatusColor(student['status']), _getStatusColor(student['status']).withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Text(student['student_id'], style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [_getStatusColor(student['status']).withValues(alpha: 0.15), _getStatusColor(student['status']).withValues(alpha: 0.08)]),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(student['status']).withValues(alpha: 0.4), width: 1.5),
                  ),
                  child: Text(student['status'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _getStatusColor(student['status']))),
                ),
              ],
            ),
          ),

          // Details Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contact Info
                Row(
                  children: [
                    Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(student['mobile'], style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 16),
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(student['registered_date'], style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),

                // Course & University
                Row(
                  children: [
                    Icon(Icons.school, size: 14, color: AppTheme.primaryBlue),
                    const SizedBox(width: 6),
                    Expanded(child: Text(student['course'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.business, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(child: Text(student['university'], style: TextStyle(fontSize: 12, color: Colors.grey[700]))),
                  ],
                ),
                const SizedBox(height: 10),

                // Additional Info
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.book, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(student['mode'] ?? 'Regular', style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.location_city, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(student['city'], style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.people, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Expanded(child: Text(student['agent'], style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Fee Summary Cards
                Row(
                  children: [
                    Expanded(child: _buildMiniCard('Total', '₹${(student['total_fee'] / 1000).toStringAsFixed(0)}K', Colors.blue)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMiniCard('Paid', '₹${(student['paid_amount'] / 1000).toStringAsFixed(0)}K', Colors.green)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMiniCard('Pending', '₹${(student['pending_amount'] / 1000).toStringAsFixed(0)}K', Colors.orange)),
                  ],
                ),

                // Documents Status
                if (student['documents'].isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.folder, size: 14, color: student['documents_verified'] == true ? Colors.green : Colors.orange),
                      const SizedBox(width: 6),
                      Text(
                        '${student['documents'].length} docs uploaded',
                        style: TextStyle(fontSize: 11, color: student['documents_verified'] == true ? Colors.green : Colors.orange),
                      ),
                      if (student['documents_verified'] == true) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, size: 14, color: Colors.green),
                      ],
                    ],
                  ),
                ],

                const SizedBox(height: 12),

                // Action Buttons Row 1
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewStudent(student),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('View', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: AppTheme.primaryBlue.withValues(alpha: 0.5)),
                          foregroundColor: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _trackApplication(student),
                        icon: const Icon(Icons.track_changes, size: 16),
                        label: const Text('Track', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Action Buttons Row 2
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editStudent(student),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: AppTheme.primaryBlue.withValues(alpha: 0.5)),
                          foregroundColor: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (student['status'] == 'Lead')
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _deleteStudent(student),
                          icon: const Icon(Icons.delete_outline, size: 16),
                          label: const Text('Delete', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    if (student['status'] == 'Applied' || student['status'] == 'Lead')
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _forwardToUniversity(student),
                          icon: const Icon(Icons.send, size: 16),
                          label: const Text('Forward', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    if (student['status'] == 'Admission Approved')
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Downloading Admission Slip...'), backgroundColor: Colors.green),
                            );
                          },
                          icon: const Icon(Icons.download, size: 16),
                          label: const Text('Admission Slip', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
}

// Student Details View Widget - Complete admission form view
class _StudentDetailsView extends StatelessWidget {
  final Map<String, dynamic> student;

  const _StudentDetailsView({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // University Remarks Banner (if any)
            if (student['university_remarks']?.toString().isNotEmpty ?? false)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, color: Colors.red, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('University Remarks', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(student['university_remarks'] ?? '', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Student ID Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.primaryBlue, Color(0xFF1565C0)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.person, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student['student_id'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(student['name'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('${student['course']}', style: const TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Basic Information
            _buildSection(
              'Basic Information',
              Icons.person_outline,
              [
                _buildRow('Full Name', student['name']),
                _buildRow('Father Name', student['father_name'] ?? 'N/A'),
                _buildRow('Mother Name', student['mother_name'] ?? 'N/A'),
                _buildRow('Mobile Number', student['mobile']),
                _buildRow('Email', student['email'] ?? 'N/A'),
                _buildRow('Date of Birth', student['dob'] ?? 'N/A'),
                _buildRow('Gender', student['gender'] ?? 'N/A'),
                _buildRow('Category', student['category'] ?? 'N/A'),
              ],
            ),

            const SizedBox(height: 16),

            // Address
            _buildSection(
              'Address Details',
              Icons.location_on_outlined,
              [
                _buildRow('Address', student['address'] ?? 'N/A'),
                _buildRow('City', student['city'] ?? 'N/A'),
                _buildRow('State', student['state'] ?? 'N/A'),
                _buildRow('Pincode', student['pincode'] ?? 'N/A'),
              ],
            ),

            const SizedBox(height: 16),

            // Academic Details
            _buildSection(
              'Academic Details',
              Icons.school_outlined,
              [
                const Text('10th Standard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryBlue)),
                const SizedBox(height: 8),
                _buildRow('Board/University', student['10th_board'] ?? 'N/A'),
                _buildRow('Marks/Percentage', student['10th_marks'] ?? 'N/A'),
                _buildRow('Passing Year', student['10th_year'] ?? 'N/A'),
                const Divider(height: 24),
                const Text('12th Standard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryBlue)),
                const SizedBox(height: 8),
                _buildRow('Board/University', student['12th_board'] ?? 'N/A'),
                _buildRow('Marks/Percentage', student['12th_marks'] ?? 'N/A'),
                _buildRow('Passing Year', student['12th_year'] ?? 'N/A'),
              ],
            ),

            const SizedBox(height: 16),

            // Course & University
            _buildSection(
              'Course & University',
              Icons.business_outlined,
              [
                _buildRow('Course', student['course']),
                _buildRow('University', student['university']),
                _buildRow('Mode', student['mode'] ?? 'N/A'),
                _buildRow('Duration', student['duration'] ?? 'N/A'),
                _buildRow('Added By', student['added_by'] ?? 'N/A'),
                _buildRow('Agent', student['agent'] ?? 'N/A'),
                _buildRow('Status', student['status']),
                _buildRow('Registered Date', student['registered_date']),
              ],
            ),

            const SizedBox(height: 16),

            // Fee Management
            _buildSection(
              'Fee Management',
              Icons.account_balance_wallet_outlined,
              [
                Row(
                  children: [
                    Expanded(child: _buildFeeCard('Total Fee', '₹${student['total_fee']}', Colors.blue)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildFeeCard('Paid', '₹${student['paid_amount']}', Colors.green)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildFeeCard('Pending', '₹${student['pending_amount']}', Colors.orange)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildFeeCard('Commission', '₹${student['consultant_share']}', AppTheme.primaryBlue)),
                  ],
                ),
                if (student['utr_number']?.toString().isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  _buildRow('UTR Number', student['utr_number']),
                  _buildRow('Payment Status', student['payment_status'] ?? 'N/A'),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // Documents
            _buildSection(
              'Documents Submitted',
              Icons.upload_file,
              [
                _buildDocStatus('10th Marksheet', student['documents'].contains('10th')),
                _buildDocStatus('12th Marksheet', student['documents'].contains('12th')),
                _buildDocStatus('Transfer Certificate', student['documents'].contains('TC')),
                _buildDocStatus('Aadhar Card', student['documents'].contains('Aadhar')),
                _buildDocStatus('Passport Photo', student['documents'].contains('Photo')),
                _buildDocStatus('Migration Certificate', student['documents'].contains('Migration')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      student['documents_verified'] == true ? Icons.verified : Icons.pending,
                      color: student['documents_verified'] == true ? Colors.green : Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      student['documents_verified'] == true ? 'All documents verified' : 'Verification pending',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: student['documents_verified'] == true ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Remarks
            _buildSection(
              'Remarks',
              Icons.note_outlined,
              [
                Text(student['remarks'] ?? 'No remarks', style: const TextStyle(fontSize: 13, height: 1.5)),
              ],
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text('$label:', style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildFeeCard(String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
          const SizedBox(height: 6),
          Text(amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildDocStatus(String name, bool uploaded) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(uploaded ? Icons.check_circle : Icons.cancel, size: 18, color: uploaded ? Colors.green : Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 13))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: uploaded ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(uploaded ? 'Uploaded' : 'Missing', style: TextStyle(fontSize: 10, color: uploaded ? Colors.green : Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Edit Student Form Widget - Complete editable admission form  
class _EditStudentForm extends StatefulWidget {
  final Map<String, dynamic> student;
  final Function(Map<String, dynamic>) onSave;

  const _EditStudentForm({required this.student, required this.onSave});

  @override
  State<_EditStudentForm> createState() => _EditStudentFormState();
}

class _EditStudentFormState extends State<_EditStudentForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _fatherNameController;
  late TextEditingController _motherNameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;
  late TextEditingController _tenth_boardController;
  late TextEditingController _tenth_marksController;
  late TextEditingController _tenth_yearController;
  late TextEditingController _twelfth_boardController;
  late TextEditingController _twelfth_marksController;
  late TextEditingController _twelfth_yearController;
  late TextEditingController _remarksController;
  
  String _gender = 'Male';
  String _category = 'General';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student['name']);
    _fatherNameController = TextEditingController(text: widget.student['father_name'] ?? '');
    _motherNameController = TextEditingController(text: widget.student['mother_name'] ?? '');
    _mobileController = TextEditingController(text: widget.student['mobile']);
    _emailController = TextEditingController(text: widget.student['email'] ?? '');
    _dobController = TextEditingController(text: widget.student['dob'] ?? '');
    _addressController = TextEditingController(text: widget.student['address'] ?? '');
    _cityController = TextEditingController(text: widget.student['city'] ?? '');
    _stateController = TextEditingController(text: widget.student['state'] ?? '');
    _pincodeController = TextEditingController(text: widget.student['pincode'] ?? '');
    _tenth_boardController = TextEditingController(text: widget.student['10th_board'] ?? '');
    _tenth_marksController = TextEditingController(text: widget.student['10th_marks'] ?? '');
    _tenth_yearController = TextEditingController(text: widget.student['10th_year'] ?? '');
    _twelfth_boardController = TextEditingController(text: widget.student['12th_board'] ?? '');
    _twelfth_marksController = TextEditingController(text: widget.student['12th_marks'] ?? '');
    _twelfth_yearController = TextEditingController(text: widget.student['12th_year'] ?? '');
    _remarksController = TextEditingController(text: widget.student['remarks'] ?? '');
    _gender = widget.student['gender'] ?? 'Male';
    _category = widget.student['category'] ?? 'General';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _tenth_boardController.dispose();
    _tenth_marksController.dispose();
    _tenth_yearController.dispose();
    _twelfth_boardController.dispose();
    _twelfth_marksController.dispose();
    _twelfth_yearController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Edit Student'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basic Information Section
            _buildSectionTitle('Basic Information', Icons.person_outline),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Full Name *', Icons.person),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _fatherNameController,
              decoration: _inputDecoration('Father Name', Icons.person),
            ),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _motherNameController,
              decoration: _inputDecoration('Mother Name', Icons.person),
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
              decoration: _inputDecoration('Email', Icons.email),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _dobController,
              decoration: _inputDecoration('Date of Birth (DD/MM/YYYY)', Icons.calendar_today),
            ),
            const SizedBox(height: 12),
            
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: _inputDecoration('Gender', Icons.wc),
              items: ['Male', 'Female', 'Other'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _gender = v!),
            ),
            const SizedBox(height: 12),
            
            DropdownButtonFormField<String>(
              value: _category,
              decoration: _inputDecoration('Category', Icons.category),
              items: ['General', 'OBC', 'SC', 'ST', 'EWS'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            
            const SizedBox(height: 24),

            // Address Section
            _buildSectionTitle('Address Details', Icons.location_on_outlined),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _addressController,
              decoration: _inputDecoration('Full Address', Icons.home),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _cityController,
              decoration: _inputDecoration('City', Icons.location_city),
            ),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _stateController,
              decoration: _inputDecoration('State', Icons.map),
            ),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _pincodeController,
              decoration: _inputDecoration('Pincode', Icons.pin_drop),
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 24),

            // Academic Details Section
            _buildSectionTitle('Academic Details', Icons.school_outlined),
            const SizedBox(height: 12),
            
            const Text('10th Standard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryBlue)),
            const SizedBox(height: 8),
            
            TextFormField(
              controller: _tenth_boardController,
              decoration: _inputDecoration('Board/University', Icons.school),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tenth_marksController,
                    decoration: _inputDecoration('Marks %', Icons.grade),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _tenth_yearController,
                    decoration: _inputDecoration('Year', Icons.calendar_today),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            const Text('12th Standard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryBlue)),
            const SizedBox(height: 8),
            
            TextFormField(
              controller: _twelfth_boardController,
              decoration: _inputDecoration('Board/University', Icons.school),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _twelfth_marksController,
                    decoration: _inputDecoration('Marks %', Icons.grade),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _twelfth_yearController,
                    decoration: _inputDecoration('Year', Icons.calendar_today),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),

            // Course Info (Read-only)
            _buildSectionTitle('Course & University (Read-only)', Icons.business_outlined),
            const SizedBox(height: 12),
            
            _buildReadOnlyField('Course', widget.student['course']),
            const SizedBox(height: 12),
            _buildReadOnlyField('University', widget.student['university']),
            const SizedBox(height: 12),
            _buildReadOnlyField('Status', widget.student['status']),
            
            const SizedBox(height: 24),

            // Remarks
            _buildSectionTitle('Remarks', Icons.note_outlined),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _remarksController,
              decoration: _inputDecoration('Add Remarks', Icons.comment),
              maxLines: 3,
            ),
            
            const SizedBox(height: 24),

            // Documents Status (Read-only)
            _buildSectionTitle('Documents Status', Icons.folder),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  _buildDocRow('10th Marksheet', widget.student['documents'].contains('10th')),
                  _buildDocRow('12th Marksheet', widget.student['documents'].contains('12th')),
                  _buildDocRow('Transfer Certificate', widget.student['documents'].contains('TC')),
                  _buildDocRow('Aadhar Card', widget.student['documents'].contains('Aadhar')),
                  _buildDocRow('Passport Photo', widget.student['documents'].contains('Photo')),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSave({
                    'name': _nameController.text,
                    'father_name': _fatherNameController.text,
                    'mother_name': _motherNameController.text,
                    'mobile': _mobileController.text,
                    'email': _emailController.text,
                    'dob': _dobController.text,
                    'gender': _gender,
                    'category': _category,
                    'address': _addressController.text,
                    'city': _cityController.text,
                    'state': _stateController.text,
                    'pincode': _pincodeController.text,
                    '10th_board': _tenth_boardController.text,
                    '10th_marks': _tenth_marksController.text,
                    '10th_year': _tenth_yearController.text,
                    '12th_board': _twelfth_boardController.text,
                    '12th_marks': _twelfth_marksController.text,
                    '12th_year': _twelfth_yearController.text,
                    'remarks': _remarksController.text,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Student updated successfully'), backgroundColor: Colors.green),
                  );
                }
              },
              icon: const Icon(Icons.save, size: 20),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
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

  Widget _buildReadOnlyField(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDocRow(String name, bool uploaded) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(uploaded ? Icons.check_circle : Icons.cancel, size: 16, color: uploaded ? Colors.green : Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 12))),
          Text(uploaded ? 'Uploaded' : 'Missing', style: TextStyle(fontSize: 10, color: uploaded ? Colors.green : Colors.red)),
        ],
      ),
    );
  }
}
