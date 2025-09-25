import 'dart:io';
import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/widgets/app_scaffold.dart';
import 'package:fitflow/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserService _userService = UserService();
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: _userService.username);
    _userService.addListener(_onUserChanged);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _userService.removeListener(_onUserChanged);
    super.dispose();
  }

  void _onUserChanged() {
    if (mounted) {
      setState(() {
        _usernameController.text = _userService.username;
      });
    }
  }

  Future<void> _pickProfilePicture() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      await _userService.updateProfilePicture(image.path);
    }
  }

  void _saveUsername() {
    _userService.updateUsername(_usernameController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Username updated to ${_userService.username}'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Future<void> _pickBackgroundImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (image != null) {
      await _userService.updateBackgroundImage(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfilePictureSection(context),
            const SizedBox(height: 30),
            _buildCustomizationSection(context),
            const SizedBox(height: 30),
            _buildAccountSection(context),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Future functionality: Reset data
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reset Data functionality not yet implemented.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.2),
                foregroundColor: Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Theme.of(context).colorScheme.error.withOpacity(0.5)),
                ),
              ),
              child: const Text('Reset All Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(BuildContext context) {
    final imagePath = _userService.profilePicturePath;
    return Column(
      children: [
        GlassCard(
          padding: const EdgeInsets.all(10), // Padding inside the glass card for the avatar
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.1),
            backgroundImage: imagePath != null && File(imagePath).existsSync() ? FileImage(File(imagePath)) : null,
            child: imagePath == null || !File(imagePath).existsSync()
                ? const Icon(Icons.person, size: 60, color: Colors.white70)
                : null,
          ),
        ),
        const SizedBox(height: 15),
        OutlinedButton(
          onPressed: _pickProfilePicture,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            side: const BorderSide(color: Colors.white70),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Change Profile Picture', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildCustomizationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
          child: Text('Customization', style: Theme.of(context).textTheme.displayMedium),
        ),
        GlassCard(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            leading: const Icon(Icons.image_outlined, color: Colors.white, size: 28),
            title: Text('Background Image', style: Theme.of(context).textTheme.labelLarge),
            subtitle: Text('Select a custom background for the app', style: Theme.of(context).textTheme.bodyMedium),
            trailing: IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white70),
              onPressed: _pickBackgroundImage,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
          child: Text('Account', style: Theme.of(context).textTheme.displayMedium),
        ),
        GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _saveUsername,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1F1D2B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Username', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
