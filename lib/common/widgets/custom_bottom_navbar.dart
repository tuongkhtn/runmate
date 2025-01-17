import 'package:flutter/material.dart';
import "package:runmate/features/let_run/screens/run_screen.dart";
import "../../features/profile/screens/profile_screen.dart";
import "../../features/challenge/screens/challenge_screen.dart";
import "../utils/constants.dart";

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar({super.key});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ProfileScreen(),
    const RunScreen(),
    const ChallengeScreen(),
    const ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTap,
        backgroundColor: kSecondaryColor,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Let\'s Run',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Challenges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
