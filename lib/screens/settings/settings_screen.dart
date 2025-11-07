import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkMode = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
      ),
      body: ListView(
        children: [
          _buildSection(
            'Account Settings',
            [
              _buildListTile(
                Icons.person,
                'Profile Settings',
                'Edit your personal information',
                () {},
              ),
              _buildListTile(
                Icons.lock,
                'Change Password',
                'Update your password',
                () {},
              ),
              _buildListTile(
                Icons.security,
                'Privacy & Security',
                'Manage your privacy settings',
                () {},
              ),
            ],
          ),
          _buildSection(
            'Notifications',
            [
              _buildSwitchTile(
                Icons.email,
                'Email Notifications',
                'Receive notifications via email',
                _emailNotifications,
                (value) => setState(() => _emailNotifications = value),
              ),
              _buildSwitchTile(
                Icons.notifications,
                'Push Notifications',
                'Receive push notifications',
                _pushNotifications,
                (value) => setState(() => _pushNotifications = value),
              ),
            ],
          ),
          _buildSection(
            'Appearance',
            [
              _buildSwitchTile(
                Icons.dark_mode,
                'Dark Mode',
                'Enable dark theme',
                _darkMode,
                (value) => setState(() => _darkMode = value),
              ),
              _buildListTile(
                Icons.language,
                'Language',
                _language,
                () => _showLanguageDialog(),
              ),
            ],
          ),
          _buildSection(
            'About',
            [
              _buildListTile(
                Icons.info,
                'App Version',
                '1.0.0',
                null,
              ),
              _buildListTile(
                Icons.description,
                'Terms & Conditions',
                'Read our terms',
                () {},
              ),
              _buildListTile(
                Icons.privacy_tip,
                'Privacy Policy',
                'Read our privacy policy',
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.mediumGray,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
      ),
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: AppTheme.mediumGray)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryBlue,
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Hindi', 'Spanish', 'French']
              .map((lang) => RadioListTile<String>(
                    title: Text(lang),
                    value: lang,
                    groupValue: _language,
                    onChanged: (value) {
                      setState(() => _language = value!);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
