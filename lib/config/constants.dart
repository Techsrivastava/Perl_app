class AppConstants {
  // App Information
  static const String appName = 'University Management System';
  static const String appVersion = '1.0.0';

  // API Constants (for future use)
  static const String baseUrl = 'https://api.example.com';
  static const int timeoutDuration = 30;

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userEmailKey = 'user_email';
  static const String isLoggedInKey = 'is_logged_in';

  // Validation
  static const int minPasswordLength = 6;
  static const int otpLength = 4;
  static const int otpResendDelay = 25; // seconds

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double cardElevation = 2.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Status Values
  static const String statusPending = 'Pending';
  static const String statusApproved = 'Approved';
  static const String statusRejected = 'Rejected';
  static const String statusActive = 'Active';
  static const String statusInactive = 'Inactive';

  // Commission Types
  static const String commissionPercentage = 'percentage';
  static const String commissionFlat = 'flat';
  static const String commissionOneTime = 'oneTime';

  // Course Types
  static const List<String> degreeTypes = [
    'Bachelor',
    'Master',
    'PhD',
    'Diploma',
    'Certificate',
  ];

  static const List<String> departments = [
    'Computer Science',
    'Engineering',
    'Business',
    'Medicine',
    'Arts',
    'Science',
    'Law',
    'Education',
  ];

  static const List<String> studyModes = [
    'Full-time',
    'Part-time',
    'Online',
    'Hybrid',
  ];

  static const List<String> levels = [
    'Undergraduate',
    'Graduate',
    'Postgraduate',
    'Doctorate',
  ];

  // Facilities
  static const List<String> facilities = [
    'Hostel',
    'Library',
    'Laboratories',
    'Transport',
    'Placement Cell',
    'Sports Complex',
    'Research Centers',
    'Cafeteria',
    'Gymnasium',
    'Auditorium',
  ];

  // Document Types
  static const List<String> documentTypes = [
    'Transcript',
    'TOEFL',
    'IELTS',
    'Passport',
    'Recommendation Letter',
    'Statement of Purpose',
    'CV/Resume',
    'Financial Documents',
  ];

  // University Types (India)
  static const List<String> universityTypes = [
    'Government',
    'Private',
    'Deemed',
    'Central',
    'State',
    'Autonomous',
  ];

  // Indian States and Union Territories
  static const List<String> indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Puducherry',
    'Chandigarh',
    'Andaman and Nicobar Islands',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Lakshadweep',
  ];

  // Accreditations (India)
  static const List<String> accreditations = [
    'NAAC A++',
    'NAAC A+',
    'NAAC A',
    'NAAC B++',
    'NAAC B+',
    'NAAC B',
    'NBA',
    'NIRF',
    'UGC',
    'AICTE',
    'NCTE',
    'BCI',
    'MCI',
    'PCI',
    'INC',
    'COA',
  ];

  // Indian Degree Types
  static const List<String> indianDegreeTypes = [
    'B.Tech',
    'B.E',
    'B.Sc',
    'B.Com',
    'B.A',
    'BBA',
    'BCA',
    'B.Arch',
    'B.Pharm',
    'MBBS',
    'BDS',
    'BAMS',
    'BHMS',
    'B.Ed',
    'LLB',
    'M.Tech',
    'M.E',
    'M.Sc',
    'M.Com',
    'M.A',
    'MBA',
    'MCA',
    'M.Arch',
    'M.Pharm',
    'MD',
    'MS',
    'M.Ed',
    'LLM',
    'Ph.D',
    'Diploma',
    'Certificate',
  ];

  // Indian Departments/Streams
  static const List<String> indianDepartments = [
    'Computer Science & Engineering',
    'Information Technology',
    'Electronics & Communication Engineering',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Chemical Engineering',
    'Biotechnology',
    'Aerospace Engineering',
    'Automobile Engineering',
    'Commerce',
    'Business Administration',
    'Management Studies',
    'Economics',
    'Accounting & Finance',
    'Arts & Humanities',
    'English Literature',
    'History',
    'Political Science',
    'Sociology',
    'Psychology',
    'Physics',
    'Chemistry',
    'Mathematics',
    'Biology',
    'Zoology',
    'Botany',
    'Medicine',
    'Dentistry',
    'Nursing',
    'Pharmacy',
    'Physiotherapy',
    'Ayurveda',
    'Homeopathy',
    'Law',
    'Education',
    'Architecture',
    'Fashion Design',
    'Fine Arts',
    'Mass Communication',
    'Journalism',
    'Hotel Management',
    'Agriculture',
  ];

  // Course Specializations
  static const List<String> specializations = [
    'Artificial Intelligence',
    'Machine Learning',
    'Data Science',
    'Cyber Security',
    'Cloud Computing',
    'Internet of Things',
    'Blockchain',
    'Full Stack Development',
    'Mobile App Development',
    'DevOps',
    'Finance',
    'Marketing',
    'Human Resources',
    'Operations',
    'International Business',
    'Digital Marketing',
    'Supply Chain Management',
    'Business Analytics',
    'Entrepreneurship',
    'General Medicine',
    'Pediatrics',
    'Orthopedics',
    'Cardiology',
    'Neurology',
    'Radiology',
    'Anesthesiology',
    'Corporate Law',
    'Criminal Law',
    'Constitutional Law',
    'Intellectual Property Rights',
    'Taxation Law',
  ];
}
