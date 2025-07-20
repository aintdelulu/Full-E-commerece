import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:clickcart/screens/login_page.dart';
import 'users_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slideAnimation = Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Widget> _sections = const [
    DashboardSection(),
    SizedBox(), // Profile
    ReportsSection(),
    SettingsSection(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: theme.colorScheme.primary,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              if (index == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserPage()));
              } else if (index == 4) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
              } else {
                setState(() {
                  _selectedIndex = index;
                  _controller.forward(from: 0);
                });
              }
            },
            selectedIconTheme: const IconThemeData(color: Colors.white),
            selectedLabelTextStyle: const TextStyle(color: Colors.white),
            unselectedIconTheme: const IconThemeData(color: Colors.white60),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white54),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text("Dashboard")),
              NavigationRailDestination(icon: Icon(Icons.person), label: Text("Profile")),
              NavigationRailDestination(icon: Icon(Icons.bar_chart), label: Text("Reports")),
              NavigationRailDestination(icon: Icon(Icons.settings), label: Text("Settings")),
              NavigationRailDestination(icon: Icon(Icons.logout), label: Text("Logout")),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _sections[_selectedIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Dashboard ----------------
class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  List<BarChartGroupData> generateChartData(Color color, double min, double max) {
    return List.generate(5, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: min + Random().nextDouble() * (max - min),
            color: color,
            width: 20,
            borderRadius: BorderRadius.zero,
          )
        ],
      );
    });
  }

  Widget buildChart(String title, Color color, double min, double max) {
    final data = generateChartData(color, min, max);
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: data,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) => SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8,
                        child: Text(
                          months[value.toInt() % months.length],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome Admin!", style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: const [
              _StatCard(title: "Orders Today", value: "32"),
              _StatCard(title: "Revenue", value: "₱3,250"),
              _StatCard(title: "Users Online", value: "89"),
              _StatCard(title: "Returns", value: "2"),
            ],
          ),
          buildChart("Sales Chart", Colors.orange, 20, 100),
          buildChart("Revenue Chart", Colors.green, 2000, 12000),
          buildChart("Users Chart", Colors.blue, 100, 500),
        ],
      ),
    );
  }
}

// ---------------- Reports ----------------
class ReportsSection extends StatefulWidget {
  const ReportsSection({super.key});

  @override
  State<ReportsSection> createState() => _ReportsSectionState();
}

class _ReportsSectionState extends State<ReportsSection> {
  String selected = 'Users';

  final List<String> categories = ['Users', 'Revenue', 'Sales'];
  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];

  List<BarChartGroupData> getData() {
    Color color;
    double min, max;

    switch (selected) {
      case 'Revenue':
        color = Colors.green;
        min = 3000;
        max = 15000;
        break;
      case 'Sales':
        color = Colors.orange;
        min = 50;
        max = 300;
        break;
      default:
        color = Colors.blue;
        min = 100;
        max = 500;
    }

    return List.generate(
      5,
      (i) => BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(toY: min + Random().nextDouble() * (max - min), color: color, width: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = getData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Reports", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        DropdownButton<String>(
          value: selected,
          onChanged: (value) => setState(() => selected = value!),
          items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: BarChart(
            BarChartData(
              barGroups: data,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8,
                      child: Text(
                        months[value.toInt() % months.length],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------- Settings ----------------
class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  void _changePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: oldPasswordController, obscureText: true, decoration: const InputDecoration(labelText: "Old Password")),
            TextField(controller: newPasswordController, obscureText: true, decoration: const InputDecoration(labelText: "New Password")),
            TextField(controller: confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: "Confirm Password")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text == confirmPasswordController.text) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password changed successfully.")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match.")));
              }
            },
            child: const Text("Change"),
          ),
        ],
      ),
    );
  }

  void _contactSupportDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Contact Support"),
        content: const Text("Email: support@example.com\nPhone: +63-900-123-4567"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cache cleared successfully.")));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text("Settings", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 24),
        SwitchListTile(
          title: const Text("Dark Mode"),
          value: isDarkMode,
          onChanged: (val) => setState(() => isDarkMode = val),
        ),
        SwitchListTile(
          title: const Text("Enable Notifications"),
          value: notificationsEnabled,
          onChanged: (val) => setState(() => notificationsEnabled = val),
        ),
        const Divider(height: 32),
        ListTile(leading: const Icon(Icons.lock_outline), title: const Text("Change Password"), onTap: _changePasswordDialog),
        ListTile(leading: const Icon(Icons.cleaning_services_outlined), title: const Text("Clear Cache"), onTap: _clearCache),
        ListTile(leading: const Icon(Icons.info_outline), title: const Text("App Info"), subtitle: const Text("Version 1.0.0 • Admin Dashboard")),
        ListTile(leading: const Icon(Icons.contact_support_outlined), title: const Text("Contact Support"), onTap: _contactSupportDialog),
      ],
    );
  }
}

// ---------------- Stat Card ----------------
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
