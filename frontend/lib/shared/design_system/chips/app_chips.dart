import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Filter chip — toggleable, used for multi-select scenarios.
///
/// Applies primary-container tint when selected and uses the global
/// [ChipTheme] defaults from Material 3 for focus and hover overlays.
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.avatar,
    this.deleteIcon,
    this.onDeleted,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final Widget? avatar;
  final Widget? deleteIcon;
  final VoidCallback? onDeleted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: enabled ? onSelected : null,
      avatar: avatar,
      deleteIcon: deleteIcon,
      onDeleted: onDeleted,
      selectedColor: scheme.primaryContainer,
      checkmarkColor: scheme.onPrimaryContainer,
      labelStyle: AppTypeScale.labelLarge.copyWith(
        color: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
      ),
      side: BorderSide(
        color: selected
            ? scheme.primary.withValues(alpha: 0.3)
            : scheme.outline,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
    );
  }
}

/// Choice chip — single-select, used in a group where one must be active.
class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.avatar,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final Widget? avatar;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: enabled ? onSelected : null,
      avatar: avatar,
      selectedColor: scheme.secondaryContainer,
      labelStyle: AppTypeScale.labelLarge.copyWith(
        color: selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant,
      ),
      side: BorderSide(
        color: selected
            ? scheme.secondary.withValues(alpha: 0.3)
            : scheme.outline,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
    );
  }
}

/// Input chip — compact chip with a trailing delete action.
///
/// Used for selected filters, tags and removable suggestions.
class AppInputChip extends StatelessWidget {
  const AppInputChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.avatar,
    this.enabled = true,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onDeleted;
  final Widget? avatar;
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return InputChip(
      label: Text(label),
      avatar: avatar,
      deleteIcon: const Icon(Icons.close, size: AppIconSizes.sm),
      onDeleted: onDeleted,
      onPressed: enabled ? onPressed : null,
      backgroundColor: ext.card,
      side: BorderSide(color: ext.border),
      labelStyle: AppTypeScale.bodySmall.copyWith(color: ext.textPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
    );
  }
}
