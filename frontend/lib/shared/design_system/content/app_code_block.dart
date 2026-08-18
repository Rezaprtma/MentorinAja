//**
// frontend/shared/design_system/content/app_code_block.dart
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
import 'package:flutter/services.dart';

import '../../../core/theme/theme.dart';

class AppCodeBlock extends StatelessWidget {
  const AppCodeBlock({
    super.key,
    required this.code,
    this.label,
    this.copyTooltip = 'Salin kode',
    this.onCopy,
  });

  final String code;

  final String? label;

  final String copyTooltip;

  final ValueChanged<String>? onCopy;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: code));
    onCopy?.call(code);
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: ext.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.code_rounded,
                      size: AppIconSizes.xs,
                      color: ext.textDisabled,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      label ?? 'Kode',
                      style: AppTypeScale.labelSmall.copyWith(
                        color: ext.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: copyTooltip,
                onPressed: () => _copy(context),
                icon: Icon(
                  Icons.copy_rounded,
                  size: AppIconSizes.sm,
                  color: ext.textDisabled,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          Divider(height: 1, color: ext.border),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              code,
              style: AppTypeScale.code.copyWith(color: ext.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
