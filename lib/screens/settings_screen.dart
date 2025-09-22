import 'dart.io';
import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/widgets/gradient_container.dart';
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
    // Add a listener to rebuild if the profile picture changes
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

  void _saveUsername() {
    _userService.updateUsername(_nameController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username updated!')),
    );
    Navigator.of(context).pop();
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
      body: GradientContainer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // --- Profile Picture Section ---
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF3A384B),
                backgroundImage: imagePath != null ? FileImage(File(imagePath)) : null,
                child: imagePath == null ? const Icon(Icons.person, size: 60, color: Colors.white70) : null,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _pickProfilePicture,
                child: const Text('Change Profile Picture'),
              ),
              const SizedBox(height: 30),

              // --- Username Section ---
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  filled: true,
                  fillColor: Theme.of(context).cardTheme.color,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveUsername,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1F1D2B),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
