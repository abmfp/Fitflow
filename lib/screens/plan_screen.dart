import 'dart.io';
import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitflow/widgets/app_scaffold.dart';

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

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- Profile Picture Section ---
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF3A384B),
              backgroundImage: imagePath != null && File(imagePath).existsSync() ? FileImage(File(imagePath)) : null,
              child: imagePath == null || !File(imagePath).existsSync() ? const Icon(Icons.person, size: 60, color: Colors.white70) : null,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _pickProfilePicture,
              child: const Text('Change Profile Picture'),
            ),
            const SizedBox(height: 30),

            // --- Customization Section with GlassCard ---
            GlassCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.image_outlined, color: Colors.white),
                title: const Text('Background Image'),
                subtitle: const Text('Select a custom background for the app'),
                onTap: _pickBackgroundImage,
              ),
            ),

            // --- Account Section with styled inputs ---
            const SizedBox(height: 20),
            _buildTextField(controller: _nameController, label: 'Username'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveUsername,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1F1D2B),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Save Username', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to keep text field styling consistent
  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Theme.of(context).cardTheme.color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
