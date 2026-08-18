//**
// frontend/shared/design_system/navigation/app_bottom_navigation.dart
//
// frontend:
// Design system widget. Menyediakan reusable UI components.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

class AppNavDestination {
  const AppNavDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final IconData icon;

  final IconData? selectedIcon;

  final String label;
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.backgroundColor,
    this.elevation = AppElevation.xs,
  });

  final int currentIndex;

  final ValueChanged<int> onDestinationSelected;

  final List<AppNavDestination> destinations;

  final Color? backgroundColor;

  final double elevation;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: backgroundColor ?? scheme.surfaceContainer,
      elevation: elevation,
      indicatorColor: scheme.primaryContainer,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: 72,
      destinations: destinations
          .map(
            (d) => NavigationDestination(
              icon: Icon(d.icon, size: AppIconSizes.xl),
              selectedIcon: Icon(
                d.selectedIcon ?? d.icon,
                size: AppIconSizes.xl,
              ),
              label: d.label,
            ),
          )
          .toList(),
    );
  }
}
