import 'package:fitflow/screens/exercise_library_screen.dart';
import 'package:flutter/material.dart';
import 'package.page_transition/page_transition.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // --- Profile Header ---
              _buildProfileHeader(context),
              const SizedBox(height: 40),

              // --- Options List ---
              _buildOptionCard(
                context,
                icon: Icons.list_alt_rounded,
                title: 'Exercise Library',
                subtitle: 'View all your exercises',
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const ExerciseLibraryScreen(),
                    ),
                  );
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
                onTap: () {},
              ),

              // This Spacer pushes the logout button to the bottom
              const Spacer(),

              // --- Log Out Button ---
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the profile picture and name
  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF3A384B),
              child: Icon(Icons.person, size: 50, color: Colors.white70),
            ),
            Positioned(
              bottom: -5,
              right: -5,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Text(
          'Hi User!',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    );
  }

  // Reusable widget for the tappable option cards
  Widget _buildOptionCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            leading: Icon(icon, color: Colors.white, size: 28),
            title: Text(title, style: Theme.of(context).textTheme.labelLarge),
            subtitle:
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            trailing:
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }

  // Widget for the log out button
  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          // TODO: Implement logout logic
        },
        child: Text(
          'Log Out',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
        ),
      ),
    );
  }
}
