import 'package:fitflow/screens/home_screen.dart';
import 'package:fitflow/screens/plan_screen.dart';
import 'package:fitflow/screens/profile_screen.dart';
import 'package:fitflow/screens/progress_screen.dart';
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
      extendBody: true, // Keep this to allow content to go behind the navbar
      body: _screens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), // Add horizontal and bottom padding
        child: ClipRRect( // Clip to round the corners
          borderRadius: BorderRadius.circular(20), // Adjust the radius as desired
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Progress'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Plan'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            // The theme from app_theme.dart will handle the colors automatically
            // Ensure bottomNavigationBarTheme in app_theme.dart sets a distinct color
          ),
        ),
      ),
    );
  }
}
