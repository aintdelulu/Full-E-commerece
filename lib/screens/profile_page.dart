import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/auth_service.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late AppUser user;
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  DateTime? _dob;
  String? _gender;

  final _picker = ImagePicker();
  File? _profileImage;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    final currentUser = AuthService.currentUser;
    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }

    user = currentUser;
    _emailController.text = user.email ?? '';
    _nameController.text = user.name ?? '';
    _phoneController.text = user.phone ?? '';
    _bioController.text = user.bio ?? '';
    _dob = user.dob;
    _gender = user.gender;

    if (user.imagePath != null && user.imagePath!.isNotEmpty) {
      _profileImage = File(user.imagePath!);
    }

    _tabController = TabController(length: 1, vsync: this); // Only 1 tab now
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
        user.imagePath = picked.path;
      });
    }
  }

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  void _saveProfile() {
    setState(() {
      user.email = _emailController.text;
      user.name = _nameController.text;
      user.phone = _phoneController.text;
      user.bio = _bioController.text;
      user.dob = _dob;
      user.gender = _gender;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  Widget _buildProfileTab(Color brown, Color beige) {
    return Container(
      color: brown,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white24,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/profile.jpg') as ImageProvider,
                    child: _profileImage == null
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  IconButton(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white30,
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField("Full Name", _nameController),
            _buildTextField("Email", _emailController, keyboard: TextInputType.emailAddress),
            _buildTextField("Phone", _phoneController, keyboard: TextInputType.phone),
            _buildTextField("Bio", _bioController, maxLines: 2),
            const SizedBox(height: 16),

            // Date of Birth
            Row(
              children: [
                const Icon(Icons.cake, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _pickDateOfBirth,
                    child: Text(
                      _dob != null
                          ? DateFormat.yMMMMd().format(_dob!)
                          : "Select Date of Birth",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Gender
            DropdownButtonFormField<String>(
              value: _gender,
              dropdownColor: brown,
              decoration: const InputDecoration(
                labelText: "Gender",
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.white,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) => setState(() => _gender = value),
            ),

            const SizedBox(height: 24),
            Card(
              color: beige,
              child: ListTile(
                leading: Icon(
                  user.isAdmin ? Icons.admin_panel_settings : Icons.verified_user,
                  color: brown,
                ),
                title: Text(
                  user.isAdmin ? 'Administrator' : 'Regular User',
                  style: TextStyle(color: brown),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brown,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF8B4513);
    const beige = Color(0xFFF5EBDD);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brown,
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: brown,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(icon: Icon(Icons.person), text: 'Profile'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(brown, beige),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
