import 'package:flutter/material.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/support_page.dart';
import 'screens/cart_page.dart';
import 'screens/checkout_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/forgot_password.dart';
import 'screens/auth_choice_page.dart';
import 'admin/admin_page.dart';
import 'admin/orders_page.dart';
import 'admin/users_page.dart';
import 'admin/products_page.dart';

void main() => runApp(const clickcart1());

class clickcart1 extends StatelessWidget {
  const clickcart1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClickCart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFFFF7EC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B4513),
          primary: const Color(0xFF8B4513),
          secondary: const Color(0xFFF5EBDD),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B4513),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),

      // ✅ Start at SplashScreen
      home: const SplashScreen(),

      // ✅ Route table for named navigation
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/support': (context) => const SupportPage(),
        '/cart': (context) => const CartPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/product': (context) => const ProductDetailPage(),
        '/admin': (context) => const AdminPage(),
        '/admin/users': (context) => const UserPage(),
        '/admin/orders': (context) => const OrdersPage(),
        '/admin/products': (context) => const products_page(),
         '/auth-choice': (context) => const AuthChoicePage(),
      },
    );
  }
}
