import 'package:flutter/material.dart';
import '../widgets/helpers.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: Palette.brown,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Help Center',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Need help with your order, payment, or account? Reach us at:\n\nsupport@example.com',
          ),
          SizedBox(height: 24),
          Text(
            'FAQs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Q: How do I place an order?\nA: Add items to cart and go to checkout.'),
          SizedBox(height: 8),
          Text('Q: What payment methods are accepted?\nA: Cash, GCash, and Credit/Debit Cards.'),
          SizedBox(height: 24),
          Text(
            'Privacy Policy',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'We respect your privacy. Your personal data will never be shared without consent.',
          ),
        ],
      ),
    );
  }
}
