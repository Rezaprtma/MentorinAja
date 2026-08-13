import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Which course collection the Progress page currently shows.
enum ProgressCategory { studying, completed }

/// Two-state filter that selects the course collection below it.
///
/// A slim full-width pill rendered from existing tokens: the selected option is
/// filled with the brand orange and white text so the active state reads
/// instantly, while the idle option sits on a neutral track with dark text.
/// Labels stay icon-free so the switch reads clean under the statistics card.
class ProgressCategorySwitch extends StatelessWidget {
  const ProgressCategorySwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// The currently selected category.
  final ProgressCategory value;

  /// Reports category changes; the parent owns the state.
  final ValueChanged<ProgressCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          _option(context, ProgressCategory.studying, 'Sedang Dipelajari'),
          _option(context, ProgressCategory.completed, 'Selesai'),
        ],
      ),
    );
  }

  Widget _option(
    BuildContext context,
    ProgressCategory category,
    String label,
  ) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final selected = value == category;

    return Expanded(
      child: Material(
        color: selected ? scheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: InkWell(
          onTap: () => onChanged(category),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          overlayColor: WidgetStatePropertyAll(
            (selected ? scheme.onPrimary : scheme.primary).withValues(
              alpha: 0.12,
            ),
          ),
          child: SizedBox(
            height: 48,
            child: Center(
              child: Text(
                label,
                style: AppTypeScale.labelLarge.copyWith(
                  color: selected ? scheme.onPrimary : ext.textPrimary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
