
import 'package:flutter/material.dart';

import 'my_pet_screen.dart';
import 'profile_screen.dart';
import 'gallery_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    ProfileScreen(),
    MyPetScreen(),
    GalleryScreen(),
  ];

  static const Color _accent = Color(0xFF8070B5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFECE7F8),
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: _accent,
            ),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_rounded),
            selectedIcon: Icon(
              Icons.pets_rounded,
              color: _accent,
            ),
            label: 'My Pet',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_rounded),
            selectedIcon: Icon(
              color: _accent,
              Icons.photo_library_rounded,
            ),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}
