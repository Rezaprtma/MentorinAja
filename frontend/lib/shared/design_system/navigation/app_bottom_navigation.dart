import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Data model for a single [AppBottomNav] destination.
class AppNavDestination {
  const AppNavDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  /// Icon shown when unselected.
  final IconData icon;

  /// Icon shown when selected; defaults to [icon] with filled style.
  final IconData? selectedIcon;

  /// Short label always visible below the icon.
  final String label;
}

/// Application-level bottom navigation bar.
///
/// Wraps Material 3 [NavigationBar] with the design-system tokens so all
/// screens share the same surface color, indicator and label behavior. Pass
/// a list of [AppNavDestination]s and a current index; the widget handles
/// selection state, indicator animation and semantic labeling.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.backgroundColor,
    this.elevation = AppElevation.xs,
  });

  /// Index of the currently active destination.
  final int currentIndex;

  /// Called when a destination is tapped.
  final ValueChanged<int> onDestinationSelected;

  /// The list of destinations (2-5 recommended by M3 spec).
  final List<AppNavDestination> destinations;

  /// Background surface color; defaults to `surfaceContainer`.
  final Color? backgroundColor;

  /// Bottom bar elevation.
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
