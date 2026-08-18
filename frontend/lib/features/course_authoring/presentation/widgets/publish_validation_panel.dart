//**
// frontend/features/course_authoring/presentation/widgets/publish_validation_panel.dart
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
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../domain/entities/publish_validation.dart';

class PublishValidationPanel extends StatelessWidget {
  const PublishValidationPanel({super.key, required this.validation});

  final PublishValidation validation;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final valid = validation.isValid;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: valid ? ext.successContainer : ext.warningContainer,
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          child: Row(
            children: [
              Icon(
                valid
                    ? Icons.check_circle_outline_rounded
                    : Icons.error_outline_rounded,
                color: valid ? ext.onSuccessContainer : ext.onWarningContainer,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  valid
                      ? 'Course siap dipublikasikan.'
                      : 'Lengkapi item di bawah sebelum publikasi.',
                  style: AppTypeScale.labelLarge.copyWith(
                    color: valid
                        ? ext.onSuccessContainer
                        : ext.onWarningContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < validation.items.length; i++) ...[
          _ValidationRow(item: validation.items[i]),
          if (i < validation.items.length - 1)
            const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _ValidationRow extends StatelessWidget {
  const _ValidationRow({required this.item});

  final PublishValidationItem item;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          item.isValid ? Icons.check_circle_rounded : Icons.cancel_rounded,
          size: AppIconSizes.md,
          color: item.isValid ? ext.success : scheme.error,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            item.label,
            style: AppTypeScale.bodyMedium.copyWith(
              color: item.isValid ? ext.textPrimary : ext.textSecondary,
              fontWeight: item.isValid ? FontWeight.w400 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
