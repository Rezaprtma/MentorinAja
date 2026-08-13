import 'package:flutter/material.dart';

import 'package:frontend/features/explore/explore.dart';
import 'package:frontend/features/home/home.dart';
import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/features/progress/progress.dart';
import 'package:frontend/shared/design_system/design_system.dart';

/// Post-authentication shell hosting the four main tabs.
///
/// Holds the active tab index, renders the tab pages in an [IndexedStack] so
/// each screen keeps its scroll position and state, and floats
/// [AppFloatingBottomNav] above the bottom edge for navigation.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const List<AppNavDestination> _destinations = [
    AppNavDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    AppNavDestination(
      icon: Icons.search,
      selectedIcon: Icons.search,
      label: 'Explore',
    ),
    AppNavDestination(
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart_rounded,
      label: 'Progress',
    ),
    AppNavDestination(
      icon: Icons.person_outline,
      selectedIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  late final List<Widget> _pages = [
    HomePage(onExplore: () => setState(() => _selectedIndex = 1)),
    const ExplorePage(),
    ProgressPage(onExplore: () => setState(() => _selectedIndex = 1)),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: AppFloatingBottomNav(
        currentIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: _destinations,
      ),
    );
  }
}
