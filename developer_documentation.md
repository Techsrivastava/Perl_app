# EduConnect Web Application - Developer Documentation

This document provides complete architectural, functional, and data model documentation for developing the **EduConnect Web Application**. This web app mirrors the functionality of the existing mobile application (Flutter/Dart) designed for educational CRM.

---

## 1. Overview
EduConnect is an Educational CRM platform connecting Universities, Educational Consultants, Agents, and Students. It streamlines the admission process, fee management, commission tracking, and lead generation. The web application should provide parity with the mobile app, offering responsive dashboards and forms for all user roles.

---

## 2. User Roles & Permissions

The application supports 5 main roles:
1. **SUPER_ADMIN**: Full access to the platform. Manages users, configures global settings, and oversees all universities and consultants.
2. **UNIVERSITY**: Can manage their own profile, upload documents (accreditations, logos), manage courses, view student applications, and track payments.
3. **CONSULTANT**: The primary B2B user. Can browse universities and courses, manage sub-agents, track leads, process student admissions, calculate fee splits/commissions, and use marketing tools.
4. **AGENT**: Works under a specific Consultant. Can generate leads, register students, and view their own commissions.
5. **STUDENT**: End user. Can track their admission status, view fee structures, and verify documents.

---

## 3. Core Entities & Data Models

### 3.1. User Model
*   **Fields**: `id`, `name`, `email`, `role`, `parentId` (for linking Agents to Consultants), `isActive`, `referralCode`, `createdAt`.

### 3.2. University Model
*   **Basic Info**: `name`, `abbreviation`, `establishedYear`, `type` (Central, State, Private, Deemed), `description`.
*   **Contact Info**: `contactEmail`, `contactPhone`, `address`.
*   **Bank details**: `bankName`, `accountNumber`, `ifscCode`, `branch`.
*   **Assets**: `logoUrl`, `coverUrl`, `accreditationCertificateUrl`.
*   **Features/Facilities**: `facilities`, `accreditations`, `socialLinks`, `authorizedPerson`, `entranceTest`.
*   **Commissions**: `commissionModel` (Type: FLAT, PERCENTAGE, MIXED), `flatAmount`, `percentage`.

### 3.3. Course Model
*   **Academic**: `name`, `code`, `department`, `degreeType`, `duration`, `modeOfStudy`, `level`, `eligibility`, `courseOutcomes`.
*   **Financials**: `fees`, `displayFee` (shown to consultants/agents/students), `actualFee` (charged to students), `scholarshipAvailable`.
*   **Placement & Features**: `placementPercentage`, `averagePackage`, `highestPackage`, `topRecruiters`, `placementSupport`.
*   **India-Specific Attributes**: `accreditation` (NAAC, NBA), `approvedBy` (AICTE, UGC, MCI), `entranceExam`.

### 3.4. Admission Process (Admission Form Model)
This is a comprehensive flow containing multiple sub-sections:
*   **StudentDetails**: Name, DoB, Contact, Address, Parents' Details.
*   **AcademicDetails**: Highest Qualification, Passing Year, Board/University, Percentage, Marksheet.
*   **CourseSelection**: Linked `universityId`, `courseId`, `specialization`, `modeOfStudy`.
*   **FeeDetails**:
    *   `universityFee` (Base fee)
    *   `displayFee` (Shown to student)
    *   `actualFee` (What is actually collected)
    *   `agentCommission` (Calculated based on `agentShareType`% or flat amount)
    *   `agentExpensesTotal` and `consultancyExpensesTotal` (List of related expenses)
    *   `finalProfit` = Actual Profit - Agent Commission - Total Expenses
    *   `universityPaymentMode` ("Share Deduct" vs "Full Fee")
*   **Documents**: ID Proof, Address Proof, Transfer Certificate, Migration, Passport Photo.
*   **Declarations**: Checkboxes for responsibilities and non-refundable agreements.

### 3.5. Lead Model
*   **Fields**: `studentName`, `email`, `phone`, `interestedCourseIds`, `agentId`, `consultantId`, `source` (BANNER, LEAD_FORM, MANUAL), `notes`.
*   **Status**: NEW, CONTACTED, INTERESTED, CONVERTED, LOST.

---

## 4. Module-wise Feature List (Action List)

### 4.1. Authentication Module
*   **Login**: Email & Password -> Sends OTP -> Verify OTP -> Get JWT Token & User Data.
*   **Direct Login**: Available for Super Admins and Students (bypasses OTP in some configurations).
*   **Registration**: Dynamic forms based on role (Consultants vs Students).
*   **Password Management**: Update password functionality via settings.

### 4.2. Consultant Dashboard
*   **Stats Overview**: Universities count, Courses available, Active Students, Active Agents, Earnings (Rs), Pending Payments, Total Leads.
*   **Quick Actions**: View Leads, Commission Summary, Pending Payments.
*   **Profile**: Manage personal data, ID, referral code.

### 4.3. University & Course Browsing
*   **List View**: Search, filter and view all active universities and their branches.
*   **Course Details**: View detailed breakdowns of courses, fee structures (excluding hidden splits), placements, and eligibility.

### 4.4. Admission Management (Consultant/Agent view)
*   **Step-by-Step Wizard**:
    1. Fill Student Details.
    2. Academic Records.
    3. Course & University Selection.
    4. Financial Breakdown (Fee logic & Commission calc).
    5. Document Uploads.
    6. Declarations & Submission.
*   **Tracking**: Status tracking (Draft, Submitted, Processing, Approved, Rejected).

### 4.5. Financial & Commission Management
*   **Fee Calculator**: Real-time calculation of Custom fees, University base fees, Agent splits, Expenses, and Final Consultancy Profit.
*   **Expense Tracking**: Add expenses with document proofs (Receipts, tickets).
*   **Commission Summary**: View earned amounts vs realized amounts.
*   **Payment Tracking**: UTR numbers, payment statuses (Pending, Paid, Verified).

### 4.6. Marketing & Creative Generator
*   **Dynamic Banners**: Tool for consultants/agents to generate promotional banners quickly.
*   **Customization**: Select University, Select Course, Type Offer Text.
*   **Branding Overlay**: Automatically applies Consultant Name + Referral Code + Contact at the bottom.
*   **QR Code**: Generates and overlays a traceable Lead Generation QR code for the specific agent.
*   **Share**: Download or natively share via web APIs (Web Share API).

---

## 5. Action Rules & Business Logic

*   **Role Fallback**: If a role is missing or unrecognised, default to `STUDENT` for minimal access.
*   **Agent Assignment**: An Agent is strictly tied to a `parentId` (the Consultant). They cannot operate independently without a Consultant.
*   **Fee Privacy**: `actualFee` and `displayFee` fields in Courses keep the `universityFee` hidden from end-users to allow Consultants to configure their margin.
*   **Commission Formulas**:
    *   *Actual Profit* = Actual Student Fee - University Base Fee
    *   *Agent Commission* = Configured via Flat Rate OR Percentage of Actual Profit.
    *   *Final Profit (Consultant)* = Actual Profit - Agent Commission - Agent Expenses - Consultancy Expenses.
*   **Lead States**: A lead progresses from `NEW` to `CONVERTED`. Once `CONVERTED`, it should automatically generate an `AdmissionForm` draft.

---

## 6. Frontend Web Architecture Recommendations (React/Next.js)

1.  **State Management**: Use Redux Toolkit, Zustand, or React Context for global state (User role, JWT token, nested form data in Admissions).
2.  **Routing**: Use role-based route guards (e.g., `/consultant/*`, `/admin/*`, `/student/*`).
3.  **UI Library**: Tailwind CSS with Shadcn UI for a clean, modern B2B SaaS dashboard interface. Use interactive tables and charts (e.g., Recharts) for dashboard widgets.
4.  **Forms**: Use `react-hook-form` with `zod` for the extensive multi-step Admission forms and validation.
5.  **Marketing Generator Tool**: Use HTML5 Canvas (`html2canvas` and `fabric.js` or similar) to allow visual composition of banners, text overlays, and QR codes directly in the browser.
6.  **API Integration**: Use Axios or Ky to communicate with the REST API. Ensure JWT token is attached as Bearer header on every request.

---
*End of Documentation*
