# 🎓 University Management System - Complete Documentation

## 📱 Overview
Professional Flutter application for managing university operations and consultant workflows with clean architecture.

---

## 🚀 Quick Start

```bash
flutter pub get
flutter run
```

### Entry Points
- **University Login**: Default screen
- **Consultant Login**: `/consultant-login`

---

## 🏗️ Architecture

```
lib/
├── core/                # Framework
│   ├── routes/         # Centralized routing
│   ├── utils/          # Helpers (validators, formatters, navigation)
│   └── widgets/        # Core components (loading, error, safe widgets)
├── config/             # Theme & constants
├── models/             # Data structures
├── services/           # Business logic
├── screens/            # UI screens
└── widgets/            # Shared components
```

---

## 📍 Navigation

```dart
// Import
import 'package:university_app_2/core/routes/app_routes.dart';
import 'package:university_app_2/core/utils/navigation_helper.dart';

// Navigate
NavigationHelper.push(context, AppRoutes.consultantDashboard);
NavigationHelper.pushReplacement(context, AppRoutes.login);
NavigationHelper.pop(context);
```

### Available Routes
```dart
// Auth
AppRoutes.login
AppRoutes.consultantLogin
AppRoutes.universityRegister
AppRoutes.consultantRegister

// University
AppRoutes.universityDashboard
AppRoutes.addCourse
AppRoutes.courseManagement
AppRoutes.studentManagement
AppRoutes.feeReports

// Consultant
AppRoutes.consultantDashboard
AppRoutes.consultantStudents
AppRoutes.consultantAgents
AppRoutes.admissionForm
```

---

## 🛠️ Utilities

### Validators
```dart
TextFormField(
  validator: Validators.email,                    // Email validation
  validator: Validators.phone,                    // Phone (Indian)
  validator: (v) => Validators.required(v, 'Name'), // Required
  validator: Validators.positiveNumber,           // Number > 0
)
```

### Formatters
```dart
Formatters.currency(5000)                // ₹5,000
Formatters.date(DateTime.now())          // 13 Nov 2025
Formatters.relativeTime(dateTime)        // 2 hours ago
Formatters.phone('9876543210')           // +91 98765 43210
Formatters.percentage(15.5)              // 15.5%
```

### Safe Widgets (Prevent Overflow)
```dart
// Text overflow protection
SafeText('Long text...')                 // Auto ellipsis
FlexText('Text in Row', flex: 1)         // Flexible text

// Row overflow protection
SafeRow(children: [...])                 // Scrollable row
WrapRow(children: [...])                 // Auto-wrapping row
OverflowSafeRow(children: [...])         // Auto-wraps text in Row

// Common label-value pattern (prevents overflow)
LabelValueRow(
  label: 'Name',
  value: 'John Doe',
  valueBold: true,
)
```

---

## 🎨 Modern Minimal Design System

### Colors (Updated)
```dart
AppTheme.primaryBlue    // #2563EB - Modern blue
AppTheme.accentPurple   // #7C3AED - Accent
AppTheme.success        // #10B981 - Modern green
AppTheme.error          // #EF4444 - Modern red
AppTheme.warning        // #F59E0B - Modern amber
```

### Typography (Enhanced)
```dart
Theme.of(context).textTheme.displayLarge    // 32px, w800
Theme.of(context).textTheme.headlineLarge   // 28px, w700
Theme.of(context).textTheme.headlineMedium  // 22px, w700
Theme.of(context).textTheme.bodyLarge       // 16px, w400
```

### Modern Widgets
```dart
// Cards
ModernCard(child: ...)              // Flat with border
ModernStatCard(...)                 // Stat display
ModernSectionHeader(title: ...)     // Section header

// Buttons
ModernButton(label: '...')          // Primary CTA
ModernSecondaryButton(label: '...') // Secondary
ModernIconButton(icon: ...)         // Icon button

// Badges
ModernBadge(label: '...', color: ...)
StatusBadge(status: 'Active')
```

---

## 📝 Adding New Features

### 1. Create Screen
```dart
// lib/screens/my_feature/my_screen.dart
class MyScreen extends StatelessWidget {
  const MyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Screen')),
      body: const Center(child: Text('Hello')),
    );
  }
}
```

### 2. Add Route
```dart
// lib/core/routes/app_routes.dart
static const String myScreen = '/my-screen';
```

### 3. Register Route
```dart
// lib/core/routes/route_generator.dart
case AppRoutes.myScreen:
  return _buildRoute(const MyScreen());
```

### 4. Navigate
```dart
NavigationHelper.push(context, AppRoutes.myScreen);
```

---

## 💡 Common Patterns

### Form with Validation
```dart
final _formKey = GlobalKey<FormState>();

void _submit() {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    // Process data
  }
}

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        validator: Validators.email,
        decoration: InputDecoration(labelText: 'Email'),
      ),
      ElevatedButton(
        onPressed: _submit,
        child: Text('Submit'),
      ),
    ],
  ),
)
```

### Loading & Error States
```dart
// Loading
AppLoading()
AppLoading(message: 'Loading...')
AppLoadingOverlay.show(context)

// Error
AppError(
  message: 'Failed to load',
  onRetry: _retry,
)

// Empty
AppEmptyState(
  message: 'No data',
  onAction: _add,
  actionLabel: 'Add New',
)
```

### Responsive Design
```dart
final isMobile = ResponsiveUtils.isMobile(context);
final padding = ResponsiveUtils.getScreenPadding(context);

Padding(
  padding: padding,
  child: isMobile ? MobileLayout() : DesktopLayout(),
)
```

---

## 📦 Key Dependencies

- `provider` - State management
- `intl` - Formatting & i18n
- `animate_do` - Animations
- `shimmer` - Loading effects
- `file_picker` & `image_picker` - File selection

---

## ✅ Best Practices

### DO ✅
```dart
const Text('Hello')                      // Use const
NavigationHelper.push(...)               // Use helpers
Validators.email(value)                  // Use validators
Formatters.currency(amount)              // Use formatters
SafeText('Long text')                    // Prevent overflow
```

### DON'T ❌
```dart
Text('Hello')                            // Missing const
Navigator.pushNamed(...)                 // Direct Navigator
if (email.contains('@'))                 // Manual validation
'₹${amount.round()}'                     // Manual formatting
Text('Very long text...')                // Potential overflow
```

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Import error | Check path: `core/utils` not `utils` |
| Route not found | Register in `RouteGenerator` |
| Widget not updating | Use `setState()` in StatefulWidget |
| Overflow error | Use `SafeText`, `FlexText`, or `SafeRow` |
| Theme not applied | Use `Theme.of(context)` or `AppTheme` |

---

## 📊 Features

### 🏫 University Module
- Dashboard with analytics
- Course management
- Student applications
- Fee structure templates
- Consultant share setup & reports

### 👨‍💼 Consultant Module
- Dedicated dashboard
- Lead & student management
- Commission tracking
- Agent management
- University course catalog
- Admission processing

---

## 🎯 Code Quality Standards

- ✅ Clean Architecture
- ✅ SOLID Principles
- ✅ Type Safety
- ✅ Null Safety
- ✅ Responsive Design
- ✅ Comprehensive Validation
- ✅ Consistent Formatting
- ✅ Error Handling

---

## 📁 File Organization

### Models
- Include `fromJson` and `toJson`
- Add `copyWith` method
- Proper documentation

### Screens
- Extract complex widgets
- Use const constructors
- Leverage existing widgets

### Services
- Keep business logic separate
- Make functions pure when possible
- Add proper error handling

---

## 🔍 Quick Reference

### Find Things
- **Add route?** → `core/routes/app_routes.dart`
- **Validators?** → `core/utils/validators.dart`
- **Formatters?** → `core/utils/formatters.dart`
- **Theme?** → `config/theme.dart`
- **Constants?** → `config/constants.dart`
- **Widgets?** → `widgets/` folder

### Naming Conventions
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables: `camelCase`
- Constants: `camelCase`

---

## 🎉 You're Ready!

This app follows **professional, production-ready** standards with:
- ✅ Clean architecture
- ✅ Type-safe navigation
- ✅ Comprehensive utilities
- ✅ Consistent UI/UX
- ✅ Overflow prevention
- ✅ Best practices

Happy coding! 🚀
