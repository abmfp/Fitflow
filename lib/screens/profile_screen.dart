import 'package:fitflow/screens/exercise_library_screen.dart';
import 'package:fitflow/screens/settings_screen.dart'; // Import settings screen
import 'package:fitflow/services/user_service.dart'; // Import user service
import 'package:flutter/material.dart';
import 'package.page_transition/page_transition.dart';

// 1. Convert to StatefulWidget to listen for changes
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();

  // 2. Add listener
  @override
  void initState() {
    super.initState();
    _userService.addListener(_onUserChanged);
  }

  // 3. Remove listener
  @override
  void dispose() {
    _userService.removeListener(_onUserChanged);
    super.dispose();
  }

  // 4. Rebuild the screen when username changes
  void _onUserChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 40),
              _buildOptionCard(
                context,
                icon: Icons.list_alt_rounded,
                title: 'Exercise Library',
                subtitle: 'View all your exercises',
                onTap: () {
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const ExerciseLibraryScreen()));
                },
              ),
              _buildOptionCard(
                context,
                icon: Icons.history_rounded,
                title: 'Workout Log',
                subtitle: 'See your past workouts',
                onTap: () {},
              ),
              _buildOptionCard(
                context,
                icon: Icons.settings_rounded,
                title: 'Settings',
                subtitle: 'App preferences',
                onTap: () {
                  // 5. Navigate to the new Settings screen
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const SettingsScreen()));
                },
              ),
              const Spacer(),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Color(0xFF3A384B), child: Icon(Icons.person, size: 50, color: Colors.white70)),
            Positioned(
              bottom: -5, right: -5,
              child: CircleAvatar(
                radius: 15, backgroundColor: Colors.white,
                child: Icon(Icons.edit, size: 18, color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        // 6. Use the live username from the service
        Text('Hi ${_userService.username}!', style: Theme.of(context).textTheme.displayLarge),
      ],
    );
  }

  Widget _buildOptionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            leading: Icon(icon, color: Colors.white, size: 28),
            title: Text(title, style: Theme.of(context).textTheme.labelLarge),
            subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text('Log Out', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}
