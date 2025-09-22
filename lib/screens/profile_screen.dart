import 'dart.io';
import 'package:fitflow/screens/exercise_library_screen.dart';
import 'package:fitflow/screens/settings_screen.dart';
import 'package:fitflow/screens/workout_history_screen.dart';
import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/widgets/gradient_container.dart';
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
    return Scaffold(
      body: GradientContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildProfileHeader(context),
                const SizedBox(height: 40),
                _buildOptionCard(context, icon: Icons.list_alt_rounded, title: 'Exercise Library', subtitle: 'View all your exercises', onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const ExerciseLibraryScreen()))),
                _buildOptionCard(context, icon: Icons.history_rounded, title: 'Workout Log', subtitle: 'See your past workouts', onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const WorkoutHistoryScreen()))),
                _buildOptionCard(context, icon: Icons.settings_rounded, title: 'Settings', subtitle: 'App preferences', onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const SettingsScreen()))),
                const Spacer(),
                _buildLogoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final imagePath = _userService.profilePicturePath;

    return Row(
      children: [
        // The avatar no longer has the Stack with the edit button
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xFF3A384B),
          backgroundImage: imagePath != null ? FileImage(File(imagePath)) : null,
          child: imagePath == null ? const Icon(Icons.person, size: 50, color: Colors.white70) : null,
        ),
        const SizedBox(width: 20),
        Text('Hi ${_userService.username}!', style: Theme.of(context).textTheme.displayLarge),
      ],
    );
  }

  Widget _buildOptionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    // ... same as before ...
  }

  Widget _buildLogoutButton(BuildContext context) {
    // ... same as before ...
  }
}
