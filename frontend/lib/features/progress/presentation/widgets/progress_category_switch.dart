//**
// frontend/features/progress/presentation/widgets/progress_category_switch.dart
//
// frontend:
// Reusable widget. Menampilkan komponen UI yang dapat digunakan di berbagai places.
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

import 'package:frontend/shared/design_system/design_system.dart';

enum ProgressCategory { studying, completed }

class ProgressCategorySwitch extends StatelessWidget {
  const ProgressCategorySwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ProgressCategory value;

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
