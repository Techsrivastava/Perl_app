# University Course Management System
## Complete Flutter Development Guide

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [Feature Breakdown](#feature-breakdown)
3. [Architecture](#architecture)
4. [Database Schema](#database-schema)
6. [Screen Flow](#screen-flow)
7. [Component Structure](#component-structure)
8. [Installation & Setup](#installation--setup)
9. [Development Guidelines](#development-guidelines)
10. [Commission Calculation Logic](#commission-calculation-logic)

---

## Project Overview

**App Name:** University Management System  
**Platform:** Flutter (iOS & Android)  
**Purpose:** Manage university courses, student admissions, and consultancy commission tracking

### Core Modules
1. **University Management** - Profile, facilities, documents
2. **Course Management** - Add, edit, delete courses with seats management
3. **Student Management** - Track students by consultancy, manage registrations
4. **Consultancy Management** - Track consultants and commission structures
5. **Commission Tracking** - Calculate and manage three commission types

### Key Features
- Email verification (OTP-based)
- Dashboard with real-time statistics
- Multi-module commission system
- Student registration workflow
- Comprehensive reporting

---

## Feature Breakdown

### 1. Authentication & Verification
```
Flow: Login → Email Verification → OTP Validation → Dashboard
- Email field with validation
- 4-digit OTP entry
- Resend OTP after 25 seconds
- Session management
```

### 2. Dashboard
```
Metrics Display:
- Total Courses: 127
- Total Students: 2,450
- Consultancies: 23
- Pending Applications: 48

Recent Activity:
- New applications
- Course updates
- Partnership approvals
```

### 3. Course Management

#### Add Course Screen
```
Basic Information:
- Course Name (required)
- Course Code (required)
- Department (dropdown)
- Degree Type (dropdown)
- Duration (text field)
- Mode of Study (dropdown)
- Level (dropdown)

Fees & Seats:
- Course Fees (per year)
- Total Seats: 60
- Available Seats: 60

Course Details:
- Course Description
- Eligibility Criteria
- Syllabus Overview
- Career Prospects

Additional Features:
- Course Active Toggle
- Scholarship Available Toggle
- Placement Support Toggle
```

#### Course List Screen
```
Display:
- Course name
- Duration
- Total/Available seats
- Department
- Status indicator

Actions:
- View details
- Edit course
- Delete course
```

### 4. Student Management

#### Student Registrations Screen
```
Statistics:
- Total: 5
- Pending: 2
- Approved: 2
- Rejected: 1

List View:
- Student name
- Email address
- Course enrolled
- Applied date
- Status badge

Actions:
- Approve/Reject
- View details
- Download list
```

#### Student Details Modal
```
Information Displayed:
- Student Name
- Email
- Phone Number
- Course
- Consultant Name
- Status
- Applied Date
- Documents (with icons)
  - Transcript
  - TOEFL
  - Passport
  - Recommendation
```

### 5. University Profile

#### Basic Information
```
- Institution Type: University
- University Name: Stanford University
- Short Name/Abbreviation: Stanford
- Established Year: 1885
- University Type: Private
```

#### Recognition & Affiliations
```
Badges:
- UGC (University Grants Commission)
- AICTE (All India Council for Technical Education)
- NAAC (National Assessment and Accreditation Council)
```

#### Facilities & Services
```
Available Facilities (checkboxes):
- Hostel
- Library
- Laboratories
- Transport
- Placement Cell

Other Facilities (optional):
- Research Centers, Sports Complex
```

#### Documents & Certificates
```
Required Documents:
- UGC Certificate (ugc_certificate.pdf)
- AICTE Certificate (aicte_certificate.pdf)
- NAAC Certificate (naac_certificate.pdf)
- Authorization Letter
- University Prospectus
```

#### Admission Information
```
Collapsible section with:
- Eligibility requirements
- Application process
- Important dates
- Contact information
```

### 6. Consultancy Management

#### Consultancy Dashboard
```
Statistics:
- Total Consultants: 4
- Total Students: 120
- Total Commission: $60,000
- Active: 3

List View with:
- Consultant Name
- Contact Email
- Students enrolled
- Commission earned
- Commission type badge
- Status indicator
```

#### Consultancy Details Card
```
- Company Name
- Contact Email
- Phone Number
- Status (Active/Inactive)
- Students count
- Commission amount
- Commission type & value
- Edit button
- View Details button
```

#### Commission Configuration
```
Three Commission Types:

1. Percentage-Based
   - Input: 15%
   - Display: "15.00%"
   - Calculation: (Student Fees × 15%) / 100

2. Flat Fee
   - Input: $500
   - Display: "$500.00"
   - Calculation: Fixed amount per student

3. One-Time Commission
   - Input: $1000
   - Display: "$1000.00 (One-time)"
   - Calculation: Single payment regardless of fees

Color Coding:
- Percentage: Green (#C8E6C9)
- Flat: Orange (#FFE0B2)
- One-Time: Blue (#E3F2FD)
```

### 7. Reports & Analytics
```
Consultant Reports Screen:
- Filter by status
- Download list
- Commission breakdown
- Student enrollment trends
- Revenue calculations
```

---

## Architecture

### Project Structure
```
lib/
├── main.dart
├── config/
│   ├── theme.dart
│   ├── constants.dart
│   └── app_config.dart
├── models/
│   ├── university_model.dart
│   ├── course_model.dart
│   ├── student_model.dart
│   ├── consultancy_model.dart
│   └── commission_model.dart
├── services/
│   ├── api_service.dart
│   ├── database_service.dart
│   ├── auth_service.dart
│   └── commission_service.dart
├── providers/
│   ├── university_provider.dart
│   ├── course_provider.dart
│   ├── student_provider.dart
│   └── consultancy_provider.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── verification_screen.dart
│   ├── dashboard/
│   │   ├── dashboard_screen.dart
│   │   └── dashboard_content.dart
│   ├── courses/
│   │   ├── courses_screen.dart
│   │   ├── add_course_screen.dart
│   │   └── course_details_screen.dart
│   ├── students/
│   │   ├── students_screen.dart
│   │   ├── student_details_screen.dart
│   │   └── student_registration_screen.dart
│   ├── university/
│   │   ├── university_profile_screen.dart
│   │   └── edit_university_screen.dart
│   └── consultancy/
│       ├── consultancy_screen.dart
│       ├── add_consultancy_screen.dart
│       └── commission_config_screen.dart
├── widgets/
│   ├── app_header.dart
│   ├── app_bottom_nav.dart
│   ├── stat_card.dart
│   ├── status_badge.dart
│   ├── commission_badge.dart
│   ├── section_header.dart
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── confirmation_dialog.dart
│   └── loading_dialog.dart
└── utils/
    ├── validators.dart
    ├── formatters.dart
    └── commission_calculator.dart
```

### Design Pattern
- **State Management:** Provider / Riverpod
- **Navigation:** Named routes
- **Database:** SQLite / Hive (local), Firebase/REST API (backend)
- **API Communication:** Dio / http package

---

## Database Schema

### Universities Table
```sql
CREATE TABLE universities (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  abbreviation TEXT NOT NULL,
  established_year INTEGER,
  type TEXT,
  facilities TEXT, -- JSON array
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

### Courses Table
```sql
CREATE TABLE courses (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  name TEXT NOT NULL,
  code TEXT NOT NULL UNIQUE,
  department TEXT,
  degree_type TEXT,
  duration TEXT,
  mode_of_study TEXT,
  level TEXT,
  fees REAL,
  total_seats INTEGER,
  available_seats INTEGER,
  description TEXT,
  eligibility TEXT, -- JSON array
  is_active BOOLEAN,
  scholarship_available BOOLEAN,
  placement_support BOOLEAN,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (university_id) REFERENCES universities(id)
);
```

### Students Table
```sql
CREATE TABLE students (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  phone TEXT,
  course_id TEXT NOT NULL,
  consultancy_id TEXT NOT NULL,
  status TEXT, -- 'Pending', 'Approved', 'Rejected'
  applied_date TIMESTAMP,
  documents TEXT, -- JSON array
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (course_id) REFERENCES courses(id),
  FOREIGN KEY (consultancy_id) REFERENCES consultancies(id)
);
```

### Consultancies Table
```sql
CREATE TABLE consultancies (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  commission_type TEXT, -- 'percentage', 'flat', 'oneTime'
  commission_value REAL,
  status TEXT, -- 'Active', 'Inactive'
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

### Commission Transactions Table
```sql
CREATE TABLE commissions (
  id TEXT PRIMARY KEY,
  consultancy_id TEXT NOT NULL,
  student_id TEXT NOT NULL,
  course_id TEXT NOT NULL,
  commission_type TEXT,
  commission_value REAL,
  course_fees REAL,
  calculated_commission REAL,
  transaction_date TIMESTAMP,
  status TEXT, -- 'Pending', 'Paid', 'Cancelled'
  FOREIGN KEY (consultancy_id) REFERENCES consultancies(id),
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (course_id) REFERENCES courses(id)
);
```

---

## API Endpoints

### Authentication
```
POST /api/auth/login
Body: { email: string }
Response: { otp_sent: boolean, expires_in: number }

POST /api/auth/verify-otp
Body: { email: string, otp: string }
Response: { token: string, user: object }
```

### Courses
```
GET /api/courses
GET /api/courses/:id
POST /api/courses
Body: { name, code, department, degreeType, duration, ... }
PUT /api/courses/:id
DELETE /api/courses/:id
```

### Students
```
GET /api/students
GET /api/students/:id
POST /api/students
Body: { name, email, phone, courseId, consultancyId, ... }
PUT /api/students/:id
PATCH /api/students/:id/status
Body: { status: 'Approved'|'Rejected'|'Pending' }
```

### Consultancies
```
GET /api/consultancies
GET /api/consultancies/:id
POST /api/consultancies
Body: { name, email, phone, commissionType, commissionValue }
PUT /api/consultancies/:id
PUT /api/consultancies/:id/commission
Body: { type, value }
```

### University
```
GET /api/university
PUT /api/university
Body: { name, abbreviation, facilities, ... }
```

### Reports
```
GET /api/reports/consultancy-summary
GET /api/reports/commission-breakdown
GET /api/reports/student-enrollment
GET /api/reports/export
Query: { format: 'pdf'|'excel', startDate, endDate }
```

---

## Screen Flow

### User Flow Diagram
```
Login Screen
    ↓
Email Verification (OTP)
    ↓
Dashboard
    ├→ Courses Management
    │   ├→ View Courses
    │   ├→ Add Course
    │   └→ Edit Course
    │
    ├→ Student Management
    │   ├→ View Registrations
    │   ├→ Student Details
    │   └→ Approve/Reject
    │
    ├→ University Profile
    │   ├→ Basic Info
    │   ├→ Facilities
    │   ├→ Documents
    │   └→ Edit Profile
    │
    └→ Consultancy Management
        ├→ View Consultants
        ├→ Add Consultant
        ├→ Commission Config
        └→ Reports
```

### Module Navigation
```
Bottom Tab Navigation:
1. Dashboard (Home)
2. Courses
3. Students
4. Consultancy
5. University (Profile)
```

---

## Component Structure

### Reusable Widgets

#### 1. AppHeader
```dart
AppHeader(
  title: 'Dashboard',
  showBackButton: false,
  onBackPressed: () {}
)
```

#### 2. StatCard
```dart
StatCard(
  title: 'Total Courses',
  value: '127',
  color: Colors.blue,
  icon: Icons.book
)
```

#### 3. StatusBadge
```dart
StatusBadge(
  status: 'Approved', // 'Pending', 'Rejected', 'Active', 'Inactive'
)
```

#### 4. CommissionBadge
```dart
CommissionBadge(
  type: CommissionType.percentage, // .flat, .oneTime
  value: 15.0
)
```

#### 5. CustomButton
```dart
CustomButton(
  label: 'Add Course',
  onPressed: () {},
  variant: 'primary' // 'secondary', 'success', 'danger'
)
```

#### 6. CustomTextField
```dart
CustomTextField(
  label: 'Course Name',
  hint: 'Enter course name',
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
  onChanged: (value) {}
)
```

---

## Installation & Setup

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / Xcode
- Firebase account (optional)

### Steps

1. **Clone Repository**
```bash
git clone <repository-url>
cd university-management-app
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Generate Code**
```bash
flutter pub run build_runner build
```

4. **Configure Environment**
Create `.env` file:
```
API_BASE_URL=https://api.example.com
API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
```

5. **Run App**
```bash
flutter run
```

### Pubspec Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  http: ^1.1.0
  dio: ^5.0.0
  sqflite: ^2.2.0
  hive: ^2.2.0
  intl: ^0.18.0
  cached_network_image: ^3.2.0
  flutter_dotenv: ^5.1.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_linter: ^3.0.0
  build_runner: ^2.3.0
```

---

## Development Guidelines

### Code Style
- Follow Flutter style guide
- Use PascalCase for class names
- Use camelCase for variables and methods
- Prefix private methods with underscore

### State Management Pattern
```dart
// Use Provider for state management
final courseProvider = StateNotifierProvider<CourseNotifier, List<Course>>((ref) {
  return CourseNotifier();
});

class CourseNotifier extends StateNotifier<List<Course>> {
  CourseNotifier() : super([]);
  
  Future<void> addCourse(Course course) async {
    // Implementation
  }
}
```

### Error Handling
```dart
try {
  final courses = await courseService.getCourses();
  state = courses;
} on ApiException catch (e) {
  // Handle API error
} on DatabaseException catch (e) {
  // Handle database error
} catch (e) {
  // Handle unexpected error
}
```

### Validation
```dart
class Validators {
  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
      return 'Invalid email format';
    }
    return null;
  }
  
  static String? validatePhone(String? value) {
    if (value?.isEmpty ?? true) return 'Phone is required';
    if (!RegExp(r'^\+?[\d\s\-()]{10,}$').hasMatch(value!)) {
      return 'Invalid phone format';
    }
    return null;
  }
}
```

### Testing
```dart
void main() {
  group('Course Service Tests', () {
    test('Should add course successfully', () async {
      final service = CourseService();
      final course = Course(...);
      
      final result = await service.addCourse(course);
      
      expect(result, isNotNull);
    });
  });
}
```

---

## Commission Calculation Logic

### 1. Percentage-Based Commission
```
Formula: (Course Fees × Commission Percentage) / 100
Example: $10,000 course × 15% = $1,500

Implementation:
double calculatePercentageCommission(
  double courseFees, 
  double percentage
) {
  return (courseFees * percentage) / 100;
}
```

### 2. Flat Fee Commission
```
Formula: Fixed Amount per Student
Example: $500 per student regardless of course fees

Implementation:
double calculateFlatCommission(double flatAmount) {
  return flatAmount;
}
```

### 3. One-Time Commission
```
Formula: Fixed Amount (paid once per consultancy)
Example: $1,000 one-time payment

Implementation:
double calculateOneTimeCommission(double oneTimeAmount) {
  return oneTimeAmount;
}
```

### Commission Service Implementation
```dart
class CommissionCalculator {
  static double calculate({
    required CommissionType type,
    required double value,
    required double courseFees,
    required bool isFirstStudent,
  }) {
    switch (type) {
      case CommissionType.percentage:
        return (courseFees * value) / 100;
      
      case CommissionType.flat:
        return value;
      
      case CommissionType.oneTime:
        // Only calculate for first student
        return isFirstStudent ? value : 0;
    }
  }
  
  static double calculateBulk({
    required CommissionType type,
    required double value,
    required List<double> coursesFees,
  }) {
    return coursesFees.fold(0, (sum, fees) {
      if (type == CommissionType.percentage) {
        return sum + ((fees * value) / 100);
      } else if (type == CommissionType.flat) {
        return sum + value;
      } else {
        return sum; // One-time already counted
      }
    });
  }
}
```

### Commission Report Generation
```
Report Fields:
- Consultancy Name
- Students Count
- Total Student Fees
- Commission Type
- Commission Rate
- Total Commission Earned
- Transactions
  - Student Name
  - Course
  - Fees
  - Commission Amount
  - Date
  - Status
```

---

## Additional Notes

### Performance Optimization
- Use `const` constructors for widgets
- Implement pagination for large lists
- Cache API responses
- Use `RepaintBoundary` for expensive widgets

### Security
- Store sensitive data in secure storage
- Validate all inputs
- Use HTTPS for API calls
- Implement token refresh mechanism
- Hash passwords on backend

### Testing Coverage
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for workflows
- Target 80%+ code coverage

### Future Enhancements
- Dark mode support
- Multi-language support
- Offline sync capability
- Push notifications
- Advanced analytics
- Mobile payment integration
- Video consultation module

---

## Support & Resources

- Flutter Documentation: https://flutter.dev/docs
- Dart Documentation: https://dart.dev/guides
- Material Design: https://material.io/design
- Firebase Documentation: https://firebase.google.com/docs

---

**Last Updated:** October 2025  
**Version:** 1.0  
**Author:** Flutter Development Team