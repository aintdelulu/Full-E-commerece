import 'package:flutter/material.dart';
import 'dart:math' as math;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  late final AnimationController _logoController;

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _passwordsMatch = true;

  @override
  void initState() {
    super.initState();
    _logoController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _userController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _checkMatch() {
    setState(() =>
        _passwordsMatch = _passController.text == _confirmController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: _Palette.brown),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, __) => Transform.rotate(
                    angle: _logoController.value * 2 * math.pi,
                    child: ScaleTransition(
                      scale: Tween(begin: 0.9, end: 1.05).animate(
                        CurvedAnimation(
                            parent: _logoController, curve: Curves.easeInOut),
                      ),
                      child: const CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xFFE7D2C2),
                        backgroundImage: AssetImage('assets/logo.jpg'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Let's get started",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: _Palette.brown)),
                  const SizedBox(height: 4),
                  const Text('Create an account to continue',
                      style: TextStyle(fontSize: 14, color: Colors.black87)),
                ])
              ],
            ),
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
                child: Column(children: [
                  _buildField(
                      controller: _userController,
                      hint: 'Username',
                      icon: Icons.person_outline,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Username required' : null),
                  const SizedBox(height: 20),
                  _buildField(
                      controller: _emailController,
                      hint: 'Email',
                      icon: Icons.alternate_email,
                      keyboard: TextInputType.emailAddress,
                      validator: _validateEmail),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 20),
                  _buildConfirmField(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _passwordsMatch
                          ? 'Password match'
                          : 'Password is not match',
                      style: TextStyle(
                          color: _passwordsMatch ? Colors.green : Colors.red,
                          fontSize: 13),
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
                      onPressed: _onCreateAccount,
                      child: const Text('Create Account',
                          style:
                              TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 32),
            Row(children: const [
              Expanded(child: Divider()),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('or continue with')),
              Expanded(child: Divider()),
            ]),
            const SizedBox(height: 24),
            _socialButton('Assets/google_icon.png', 'Continue with Google'),
            const SizedBox(height: 16),
            _socialButton('Assets/facebook_icon.png', 'Continue with Facebook'),
            const SizedBox(height: 32),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Already have an Account? '),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text('Login',
                    style: TextStyle(
                        color: _Palette.brown, fontWeight: FontWeight.w600)),
              ),
            ])
          ]),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        decoration: _decoration(hint: hint, icon: icon),
      );

  Widget _buildPasswordField() => TextFormField(
        controller: _passController,
        obscureText: _obscurePass,
        onChanged: (_) => _checkMatch(),
        decoration: _decoration(
          hint: 'Password',
          icon: Icons.lock_outline,
          suffix: IconButton(
            splashRadius: 20,
            icon: Icon(
                _obscurePass ? Icons.visibility_off : Icons.visibility),
            onPressed: () =>
                setState(() => _obscurePass = !_obscurePass),
          ),
        ),
        validator: (v) => v == null || v.length < 6 ? 'Min 6 chars' : null,
      );

  Widget _buildConfirmField() => TextFormField(
        controller: _confirmController,
        obscureText: _obscureConfirm,
        onChanged: (_) => _checkMatch(),
        decoration: _decoration(
          hint: 'Confirm Password',
          icon: Icons.lock_person_outlined,
          suffix: IconButton(
            splashRadius: 20,
            icon: Icon(
                _obscureConfirm ? Icons.visibility_off : Icons.visibility),
            onPressed: () =>
                setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ),
        validator: (v) =>
            v == null || v.isEmpty ? 'Confirm password' : null,
      );

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) =>
      InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
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


  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    const pattern = r'^.+@.+\..+$';
    if (!RegExp(pattern).hasMatch(value.trim())) return 'Enter valid email';
    return null;
  }

  void _onCreateAccount() {
    _checkMatch();
    if (_formKey.currentState!.validate() && _passwordsMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created (placeholder)')),
      );
      Navigator.pop(context);
    }
  }

  Widget _socialButton(String assetPath, String label) => SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: _Palette.brown.withOpacity(.45)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: Colors.white,
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(assetPath, width: 22, height: 22),
              const SizedBox(width: 12),
              Text(label,
                  style: const TextStyle(
                      color: _Palette.brown, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
}

class _Palette {
  static const brown = Color(0xFF9C6735);
}
