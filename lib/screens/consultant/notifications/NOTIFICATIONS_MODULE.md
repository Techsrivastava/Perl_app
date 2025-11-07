# Profit Pulse EduConnect – Consultant Dashboard Notifications Module

## Objective
Deliver real-time, categorized alerts so consultants, university partners, and sub-agents always know about critical actions (admissions, payments, updates, and agent activity) without leaving the dashboard.

## Location & Navigation
```
Consultant Dashboard → Notification Bell (AppBar) → Notifications Screen
Tabs: Admissions | Payments | University Updates | Reverted Applications | Agent Activity
```

## Notification Categories
| Category | Description |
| --- | --- |
| 🧾 New Admission Alerts | Submitted, approved, reverted, or cancelled admissions |
| 💳 Payment Approval Notifications | Payment uploads, verifications, rejections, transfers |
| 🏛 University Updates | Course/fee changes, policy announcements, accreditation news |
| 🔁 Reverted Application Alerts | Applications needing corrections or document uploads |
| 👥 Agent Activity Notifications | Leads, admissions, payments, and account status from sub-agents |

## Data Model (Simplified JSON)
```json
{
  "notification_id": 9001,
  "type": "Payment Approval",
  "title": "Payment Verified for Rahul Kumar",
  "message": "₹25,000 verified for BNYS course.",
  "category": "Payments",
  "priority": "High",
  "related_id": "STU_5001",
  "source": "Consultant",
  "status": "Unread",
  "timestamp": "2025-11-07T15:32:00",
  "link": "/students/5001/payment-details"
}
```

## Triggers & Fields
### 1. Admissions
- **Triggers:** Submit, approve, revert, cancel applications
- **Fields:** Student, course, university, action, timestamp, read status, deep link
- **Examples:**
  - `🎓 New admission application received for BNYS – Sunrise University.`
  - `✅ Admission for Rahul Sharma has been approved.`
  - `⚠️ Application for Priya Verma reverted for missing document.`

### 2. Payments
- **Triggers:** Payment upload, verification, rejection, transfer
- **Fields:** Student, amount, status, verified by, timestamp
- **Examples:**
  - `💰 ₹25,000 payment received for Rahul Kumar (BPT).`
  - `🧾 Payment for Amit Singh verified successfully.`
  - `🚫 Payment rejected — incorrect receipt uploaded.`

### 3. University Updates
- **Triggers:** New courses, fee structure changes, policy updates, accreditation
- **Fields:** University, update type, summary, attachment link, date, read status
- **Examples:**
  - `🏫 Sunrise University has updated BNYS fee structure.`
  - `📢 New NAAC A+ accreditation announcement received.`

### 4. Reverted Applications
- **Triggers:** Missing documents, incorrect data, fee issues
- **Fields:** Student, reverted by, reason, timestamp, action required
- **Examples:**
  - `🔁 Rohit Sharma’s admission reverted — Upload missing mark sheet.`
  - `⚠️ Application reverted due to incorrect fee entry.`

### 5. Agent Activity
- **Triggers:** New lead, admission update, fee upload, agent status change
- **Fields:** Agent, activity type, related student, timestamp, status
- **Examples:**
  - `👤 Agent Saurabh Yadav added a new lead – BNYS Student.`
  - `💳 Fee receipt uploaded by Agent #102 for Rahul Kumar.`
  - `🔒 Agent Neha Gupta account blocked due to inactivity.`

## Priority & Cleanup
- High: Admissions, Payments (red badges)
- Medium: University Updates (amber badges)
- Low: Agent Activity (blue badges)
- Auto-archive notifications older than 60 days.

## Role Visibility
| Role | Categories |
| --- | --- |
| Consultant | All |
| Agent | Assigned leads, payments, approvals |
| University | University updates, relevant admissions |
| Admin | Global visibility |

## UI Components
- **AppBar Bell Icon** with unread badge count
- **Notifications Screen** with compact tab bar, filters, action buttons
- **Recent Activity Drawer** previewing latest unread items
- **Quick Actions:** Mark All Read, Clear All (per tab), Filter by date/source, Export to PDF/Excel
- **Color Coding:** 🔴 High priority, 🟡 Medium, 🔵 Low

## Delivery Channels
| Channel | Usage |
| --- | --- |
| In-app | Real-time toast + list update |
| Email | High-impact events (payments, approvals) |
| Push (Mobile) | Firebase-linked instant notifications |
| SMS (Optional) | Configurable for critical alerts |

## Implementation Notes
- Maintain grouped sample data per category for UI mocking
- Ensure deep links navigate to student/fee detail screens
- Provide toggle switches to enable/disable categories per user
- Persist read state (local mock for now, API-ready structure)
- Add bulk actions and per-item overflow menu (View Details, Mark Read, Pin, Delete)

## Final Outcome
Centralized, categorized notification center keeps consultants and partner roles informed, reduces manual follow-ups, and enables proactive action on admissions, fees, and agent performance.
