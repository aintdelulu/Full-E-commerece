import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

/// Shared color palette
class Palette {
  static const Color brown = Color(0xFF795548);          // Main theme color (Brown)
  static const Color accent = Color(0xFFFFA726);         // Accent color (Orange)
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
}

/// Bottom navigation bar widget used in main pages
BottomNavigationBar bottomNav(int idx, BuildContext ctx) => BottomNavigationBar(
      currentIndex: idx,
      onTap: (i) {
        if (i == idx) return;
        const destinations = ['/home', '/cart', '/profile'];
        Navigator.pushReplacementNamed(ctx, destinations[i]);
      },
      selectedItemColor: Palette.brown,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );

/// Shared scaffold used across most screens
Scaffold simpleScaffold(BuildContext ctx, String title, int? navIdx, Widget body) => Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Palette.brown,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: navIdx == null ? null : bottomNav(navIdx, ctx),
      body: Center(child: body),
    );
