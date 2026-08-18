//**
// frontend/shared/design_system/navigation/app_floating_bottom_navigation.dart
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
import 'app_bottom_navigation.dart';
import '../layout/app_safe_area.dart';

class AppFloatingBottomNav extends StatelessWidget {
  const AppFloatingBottomNav({
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
