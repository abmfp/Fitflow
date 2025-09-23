import 'dart:io';
import 'package:fitflow/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserService _userService = UserService();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _userService.username);
    _userService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _pickProfilePicture() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      _userService.updateProfilePicture(image.path);
    }
  }

  // New method to pick the background
  Future<void> _pickBackgroundImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      _userService.updateBackgroundImage(image.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Background updated!')),
      );
    }
  }

  void _saveUsername() {
    _userService.updateUsername(_nameController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _userService.profilePicturePath;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF3A384B),
              backgroundImage: imagePath != null ? FileImage(File(imagePath)) : null,
              child: imagePath == null ? const Icon(Icons.person, size: 60, color: Colors.white70) : null,
            ),
            const SizedBox(height: 10),
            TextButton(onPressed: _pickProfilePicture, child: const Text('Change Profile Picture')),
            const Divider(height: 40),

            // New section for background
            Text('Customization', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Background Image'),
              subtitle: const Text('Select a custom background for the app'),
              trailing: const Icon(Icons.image_outlined),
              onTap: _pickBackgroundImage,
            ),
            const Divider(height: 40),

            Text('Account', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration( /* ... */ ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveUsername,
              style: ElevatedButton.styleFrom( /* ... */ ),
              child: const Text('Save Username', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
