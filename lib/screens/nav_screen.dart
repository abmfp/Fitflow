import 'package:fitflow/screens/home_screen.dart';
import 'package:fitflow/screens/plan_screen.dart';
import 'package:fitflow/screens/profile_screen.dart';
import 'package:fitflow/screens/progress_screen.dart';
import 'package:fitflow/widgets/glass_card.dart'; // Import the GlassCard
import 'package:flutter/material.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onNavigateToProgress: () => _onItemTapped(1),
      ),
      const ProgressScreen(),
      const PlanScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extend the body behind the now-transparent navbar
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildModernNavBar(),
    );
  }

  // New helper widget for the modern navigation bar
  Widget _buildModernNavBar() {
    return Padding(
      // Add padding to the sides and bottom to make it "float"
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: GlassCard(
        // Use a tighter padding inside the card
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Progress'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Plan'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          // Important: make the original navbar background transparent
          backgroundColor: Colors.transparent,
          elevation: 0,
          // Use the theme's colors for the icons
          selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        ),
      ),
    );
  }
}
