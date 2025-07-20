
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: _Palette.brown),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              const Text('Forgot Password',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: _Palette.brown)),
              const SizedBox(height: 6),
              const Text(
                  'Enter your registered email and we\'ll send you a reset link.',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0ECE9),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: _Palette.brown.withOpacity(.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        decoration: _fieldDecoration(
                          hint: 'Email Address',
                          icon: Icons.alternate_email,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _Palette.brown,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26)),
                          ),
                          onPressed: _onSubmit,
                          child: const Text('Send Reset Link',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    const pattern = r'^.+@.+\..+$';
    if (!RegExp(pattern).hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reset link sent to ${_emailController.text}'),
      ));
      Navigator.pop(context); // back to login
    }
  }

  InputDecoration _fieldDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _Palette.brown.withOpacity(.25)),
        borderRadius: BorderRadius.circular(24),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: _Palette.brown, width: 1.4),
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}

class _Palette {
  static const brown = Color(0xFF9C6735);
}
