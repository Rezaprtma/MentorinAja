import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'app_bottom_navigation.dart';
import '../layout/app_safe_area.dart';

/// Floating, detached bottom navigation bar.
///
/// [AppFloatingBottomNav] renders a rounded capsule hover above the bottom
/// edge instead of a full-width Material [NavigationBar]. It insets itself for
/// safe areas, floats with horizontal margins, and highlights the active
/// destination with a soft pill. Reusable across main-shell screens that need
/// persistent tab navigation; pass the same [AppNavDestination] list the
/// caller owns so every shell shares one definition.
///
/// ```dart
/// AppFloatingBottomNav(
///   currentIndex: index,
///   onDestinationSelected: (i) => setState(() => index = i),
///   destinations: const [
///     AppNavDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
///   ],
/// )
/// ```
class AppFloatingBottomNav extends StatelessWidget {
  const AppFloatingBottomNav({
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

  /// The list of destinations rendered inside the bar.
  final List<AppNavDestination> destinations;

  /// Bar surface color; defaults to the design-system card surface.
  final Color? backgroundColor;

  /// Floating shadow strength; softens or lifts the bar.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return AppSafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Container(
          height: 72,
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: backgroundColor ?? ext.card,
            borderRadius: BorderRadius.circular(AppRadius.extraLarge),
            border: Border.all(color: ext.border),
            boxShadow: const [AppShadow.soft],
          ),
          child: Row(
            children: [
              for (var i = 0; i < destinations.length; i++)
                Expanded(
                  child: _FloatingNavItem(
                    destination: destinations[i],
                    selected: i == currentIndex,
                    onTap: () => onDestinationSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single tappable destination inside [AppFloatingBottomNav].
class _FloatingNavItem extends StatelessWidget {
  const _FloatingNavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final AppNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final activeColor = scheme.primary;
    final idleColor = context.appColors.textSecondary;

    final icon = selected
        ? (destination.selectedIcon ?? destination.icon)
        : destination.icon;

    return Semantics(
      selected: selected,
      button: true,
      label: destination.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppEasing.standard,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: selected ? scheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppIconSizes.lg,
                color: selected ? activeColor : idleColor,
              ),
              const SizedBox(height: AppSpacing.xxs),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  destination.label,
                  style: AppTypeScale.labelSmall.copyWith(
                    color: selected ? activeColor : idleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
