//**
// frontend/features/lesson/presentation/stages/materi_stage.dart
//
// frontend:
// Source file. Bagian dari MentorinAja frontend.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi file behavior sesuai dengan purpose.
//**
library;

import 'package:flutter/material.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../widgets/learning_navigation_bar.dart';

class MateriStageView extends StatelessWidget {
  const MateriStageView({
    super.key,
    required this.lesson,
    this.blocks = const [],
  });

  final CourseLesson lesson;
  final List<dynamic> blocks;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final fileName = 'Modul_${lesson.title.replaceAll(' ', '_')}.pdf';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        ResponsivePadding.horizontal(context),
        AppSpacing.md,
        ResponsivePadding.horizontal(context),
        LearningNavigationBar.reservedContentSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1D2126) : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border.all(color: ext.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // PDF Reader Header Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF17191D)
                        : scheme.surfaceContainer,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.large - 1),
                      topRight: Radius.circular(AppRadius.large - 1),
                    ),
                    border: Border(bottom: BorderSide(color: ext.border)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.picture_as_pdf_rounded,
                        color: scheme.error,
                        size: AppIconSizes.md,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          fileName,
                          style: AppTypeScale.labelLarge.copyWith(
                            color: ext.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '1.2 MB',
                        style: AppTypeScale.labelSmall.copyWith(
                          color: ext.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        Icons.download_rounded,
                        color: ext.textSecondary,
                        size: AppIconSizes.sm,
                      ),
                    ],
                  ),
                ),

                // Document Content Sheet
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          lesson.title.toUpperCase(),
                          style: AppTypeScale.titleMedium.copyWith(
                            color: ext.textPrimary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Center(
                        child: Container(
                          width: 60,
                          height: 2,
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        lesson.summary ??
                            'Materi pembelajaran untuk modul ini.',
                        style: AppTypeScale.bodyMedium.copyWith(
                          color: ext.textPrimary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        'PELAJARI',
                        style: AppTypeScale.labelMedium.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Divider(height: 16),
                      Text(
                        '1. Pahami konsep utama dari topik "${lesson.title}".\n'
                        '2. Analisis bagaimana kode disusun dan dijalankan.\n'
                        '3. Selesaikan game tantangan setelah membaca modul ini.',
                        style: AppTypeScale.bodySmall.copyWith(
                          color: ext.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        'LIHAT CONTOH',
                        style: AppTypeScale.labelMedium.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Divider(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: const Color(0xFF17191D),
                          borderRadius: BorderRadius.circular(AppRadius.small),
                          border: Border.all(color: const Color(0xFF33383F)),
                        ),
                        child: Text(
                          lesson.title.toLowerCase().contains('hello')
                              ? 'print("Hello, World!")'
                              : lesson.title.toLowerCase().contains('variabel')
                              ? 'nama = "Budi"\numur = 17'
                              : 'x = 10\nif x > 5:\n    print("Besar")',
                          style: AppTypeScale.code.copyWith(
                            color: const Color(0xFFEDEFF2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // PDF Reader Footer
                Container(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  alignment: Alignment.center,
                  child: Text(
                    'Halaman 1 dari 1',
                    style: AppTypeScale.labelSmall.copyWith(
                      color: ext.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
