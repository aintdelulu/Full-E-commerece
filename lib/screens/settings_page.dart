import 'package:flutter/material.dart';
import '../models/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'My Flutter App',
      applicationVersion: '1.0.0',
      applicationIcon: const FlutterLogo(),
      children: const [
        Text('This is a demo Flutter app for learning purposes.'),
      ],
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change password tapped')),
    );
  }

  void _logout() {
    AuthService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF8B4513);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              value: _darkMode,
              onChanged: (val) => setState(() => _darkMode = val),
              secondary: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
            ),
            SwitchListTile(
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
              secondary: const Icon(Icons.notifications_active),
              title: const Text('Enable Notifications'),
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: _changePassword,
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About App'),
              onTap: _showAboutDialog,
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: brown,
                side: const BorderSide(color: brown),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
