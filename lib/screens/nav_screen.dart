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
      extendBody: true, // Allows content to go behind the navbar
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildModernNavBar(),
    );
  }

  Widget _buildModernNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24), // Wider margin
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Progress'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Plan'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          // Use the theme for colors and properties
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          type: Theme.of(context).bottomNavigationBarTheme.type,
          selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          showSelectedLabels: Theme.of(context).bottomNavigationBarTheme.showSelectedLabels,
          showUnselectedLabels: Theme.of(context).bottomNavigationBarTheme.showUnselectedLabels,
          elevation: 0,
        ),
      ),
    );
  }
}
