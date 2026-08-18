//**
// frontend/features/lesson/presentation/widgets/lesson_content_block_view.dart
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

import '../../domain/entities/lesson_content.dart';
import 'exercises/lesson_exercise_view.dart';

class LessonContentBlockView extends StatelessWidget {
  const LessonContentBlockView({super.key, required this.block});

  final LessonContentBlock block;

  @override
  Widget build(BuildContext context) {
    final content = switch (block.type) {
      LessonContentBlockType.paragraph => _ParagraphView(
        text: block.text ?? '',
      ),
      LessonContentBlockType.bulletList => _BulletListView(items: block.items),
      LessonContentBlockType.code => _CodeBlockView(
        label: block.label,
        code: block.text ?? '',
      ),
      LessonContentBlockType.tip => _TipView(text: block.text ?? ''),
      LessonContentBlockType.exercise =>
        block.exercise == null
            ? const SizedBox.shrink()
            : LessonExerciseView(exercise: block.exercise!),
      LessonContentBlockType.heading => _HeadingView(text: block.text ?? ''),
      LessonContentBlockType.subheading => _SubheadingView(
        text: block.text ?? '',
      ),
      LessonContentBlockType.numberedList => _NumberedListView(
        items: block.items,
      ),
      LessonContentBlockType.warning => _WarningView(text: block.text ?? ''),
      LessonContentBlockType.example => _ExampleView(text: block.text ?? ''),
      LessonContentBlockType.summary => _SummaryView(text: block.text ?? ''),
      LessonContentBlockType.checklist => _ChecklistView(items: block.items),
    };

    if (block.heading == null || block.heading!.isEmpty) return content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PhaseHeading(label: block.heading!),
        const SizedBox(height: AppSpacing.xs),
        content,
      ],
    );
  }
}

class _PhaseHeading extends StatelessWidget {
  const _PhaseHeading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Text(
      label,
      style: AppTypeScale.labelSmall.copyWith(
        color: scheme.secondary,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _ParagraphView extends StatelessWidget {
  const _ParagraphView({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypeScale.bodyMedium.copyWith(
        color: context.appColors.textPrimary,
        height: 1.6,
      ),
    );
  }
}

class _BulletListView extends StatelessWidget {
  const _BulletListView({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      elevation: AppElevation.flat,
      radius: AppRadius.large,
      borderSide: BorderSide(color: ext.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: ext.successContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: AppIconSizes.xs,
                    color: ext.onSuccessContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    items[i],
                    style: AppTypeScale.bodyMedium.copyWith(
                      color: ext.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CodeBlockView extends StatelessWidget {
  const _CodeBlockView({required this.label, required this.code});

  final String? label;
  final String code;

  @override
  Widget build(BuildContext context) {
    return AppCodeBlock(
      label: label,
      code: code,
      onCopy: (_) {
        AppToast.show(
          context,
          title: 'Kode Disalin',
          message: 'Contoh kode sudah ada di clipboard.',
          severity: AppFeedbackSeverity.success,
        );
      },
    );
  }
}

class _TipView extends StatelessWidget {
  const _TipView({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: AppIconSizes.md,
            color: scheme.onSecondaryContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypeScale.bodyMedium.copyWith(
                color: scheme.onSecondaryContainer,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeadingView extends StatelessWidget {
  const _HeadingView({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        text,
        style: AppTypeScale.titleLarge.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SubheadingView extends StatelessWidget {
  const _SubheadingView({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: AppTypeScale.titleMedium.copyWith(
          color: context.appColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NumberedListView extends StatelessWidget {
  const _NumberedListView({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      elevation: AppElevation.flat,
      radius: AppRadius.large,
      borderSide: BorderSide(color: ext.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Text(
                    '${i + 1}',
                    style: AppTypeScale.labelMedium.copyWith(
                      color: ext.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    items[i],
                    style: AppTypeScale.bodyMedium.copyWith(
                      color: ext.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _WarningView extends StatelessWidget {
  const _WarningView({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: ext.warningContainer,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: AppIconSizes.md,
                color: ext.onWarningContainer,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'PERINGATAN',
                style: AppTypeScale.labelSmall.copyWith(
                  color: ext.onWarningContainer,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.md + AppSpacing.xs),
            child: Text(
              text,
              style: AppTypeScale.bodyMedium.copyWith(
                color: ext.onWarningContainer,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleView extends StatelessWidget {
  const _ExampleView({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      elevation: AppElevation.flat,
      radius: AppRadius.large,
      borderSide: BorderSide(color: ext.info),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_outlined,
                size: AppIconSizes.md,
                color: ext.info,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'CONTOH',
                style: AppTypeScale.labelSmall.copyWith(
                  color: ext.info,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.md + AppSpacing.xs),
            child: Text(
              text,
              style: AppTypeScale.bodyMedium.copyWith(
                color: ext.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.summarize_outlined,
                size: AppIconSizes.md,
                color: scheme.onSecondaryContainer,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'RANGKUMAN',
                style: AppTypeScale.labelSmall.copyWith(
                  color: scheme.onSecondaryContainer,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.md + AppSpacing.xs),
            child: Text(
              text,
              style: AppTypeScale.bodyMedium.copyWith(
                color: scheme.onSecondaryContainer,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistView extends StatelessWidget {
  const _ChecklistView({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return AppBaseCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      elevation: AppElevation.flat,
      radius: AppRadius.large,
      borderSide: BorderSide(color: ext.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) Divider(height: 1, color: ext.divider),
            SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_box_outline_blank_rounded,
                    size: AppIconSizes.sm,
                    color: ext.textSecondary,
                    semanticLabel: 'Belum selesai',
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      items[i],
                      style: AppTypeScale.bodyMedium.copyWith(
                        color: ext.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
