//**
// frontend/features/profile/presentation/widgets/document_section_list.dart
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

typedef DocumentSection = ({String heading, List<String> paragraphs});

class DocumentSectionList extends StatelessWidget {
  const DocumentSectionList({super.key, required this.sections});

  final List<DocumentSection> sections;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      elevation: AppElevation.flat,
      radius: AppRadius.large,
      borderSide: BorderSide(color: ext.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, section) in sections.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.lg),
            Text(
              section.heading,
              style: AppTypeScale.titleMedium.copyWith(
                color: ext.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            for (final (i, paragraph) in section.paragraphs.indexed) ...[
              if (i > 0) const SizedBox(height: AppSpacing.sm),
              Text(
                paragraph,
                style: AppTypeScale.bodyMedium.copyWith(
                  color: ext.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
