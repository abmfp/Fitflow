import 'dart:io';
import 'package:fitflow/screens/exercise_library_screen.dart';
import 'package:fitflow/screens/settings_screen.dart';
import 'package:fitflow/screens/workout_history_screen.dart';
import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/widgets/glass_card.dart';
import 'package:fitflow/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _userService.addListener(_onUserChanged);
  }

  @override
  void dispose() {
    _userService.removeListener(_onUserChanged);
    super.dispose();
  }

  void _onUserChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 30),
              _buildOptionCard(context, icon: Icons.list_alt_rounded, title: 'Exercise Library', subtitle: 'View all your exercises', onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const ExerciseLibraryScreen()))),
              _buildOptionCard(context, icon: Icons.history_rounded, title: 'Workout Log', subtitle: 'See your past workouts', onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const WorkoutHistoryScreen()))),
              _buildOptionCard(context, icon: Icons.settings_rounded, title: 'Settings', subtitle: 'App preferences', onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const SettingsScreen()))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final imagePath = _userService.profilePicturePath;
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xFF3A384B),
          backgroundImage: imagePath != null && File(imagePath).existsSync() ? FileImage(File(imagePath)) : null,
          child: imagePath == null || !File(imagePath).existsSync()
              ? const Icon(Icons.person, size: 50, color: Colors.white70)
              : null,
        ),
        const SizedBox(width: 20),
        Text('Hi ${_userService.username}!', style: Theme.of(context).textTheme.displayLarge),
      ],
    );
  }

  Widget _buildOptionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: Colors.white, size: 28),
        title: Text(title, style: Theme.of(context).textTheme.labelLarge),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      ),
    );
  }
}
