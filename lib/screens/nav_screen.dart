import 'package:fitflow/screens/home_screen.dart';
import 'package:fitflow/screens/plan_screen.dart';
import 'package:fitflow/screens/profile_screen.dart';
import 'package:fitflow/screens/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package.fitflow/widgets/app_scaffold.dart';

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
      HomeScreen(onNavigateToProgress: () => _onItemTapped(1)),
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
    return AppScaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Progress'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Plan'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: Theme.of(context).bottomNavigationBarTheme.type,
            selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            showSelectedLabels: Theme.of(context).bottomNavigationBarTheme.showSelectedLabels,
            showUnselectedLabels: Theme.of(context).bottomNavigationBarTheme.showUnselectedLabels,
          ),
        ),
      ),
    );
  }
}
