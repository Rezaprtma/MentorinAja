//**
// frontend/features/course_authoring/presentation/pages/lesson_editor_page.dart
//
// frontend:
// Screen/page. Menampilkan UI dan menerima user interactions.
//
// backend:
// Future: akan membutuhkan backend data dan API calls.
//
// api:
// Future: akan melakukan API calls melalui controllers/repositories.
//
// qa:
// QA perlu memvalidasi UI rendering, user interactions, dan navigation.
//**
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../data/mock_course_authoring_repository.dart';
import '../../domain/entities/lesson_draft.dart';
import '../../domain/repositories/course_authoring_repository.dart';

class LessonEditorPage extends StatefulWidget {
  const LessonEditorPage({
    super.key,
    required this.courseId,
    required this.lessonId,
    this.repository,
  });

  final String courseId;
  final String lessonId;

  final CourseAuthoringRepository? repository;

  @override
  State<LessonEditorPage> createState() => _LessonEditorPageState();
}

class _LessonEditorPageState extends State<LessonEditorPage> {
  late final CourseAuthoringRepository _repository =
      widget.repository ?? MockCourseAuthoringRepository.instance;

  LessonDraft? get _lesson {
    final draft = _repository.findDraft(widget.courseId);
    if (draft == null) return null;
    for (final lesson in draft.lessons) {
      if (lesson.id == widget.lessonId) return lesson;
    }
    return null;
  }

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final lesson = _lesson;
    _titleController = TextEditingController(text: lesson?.title ?? '');
    _descriptionController = TextEditingController(
      text: lesson?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveModule() {
    final lesson = _lesson;
    if (lesson == null) return;
    _repository.updateLesson(
      widget.courseId,
      lesson.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      ),
    );
    AppToast.show(
      context,
      title: 'Modul disimpan.',
      message: 'Perubahan pada modul berhasil disimpan.',
      severity: AppFeedbackSeverity.success,
    );
    setState(() {});
  }

  void _simulatePdfUpload() {
    final lesson = _lesson;
    if (lesson == null) return;

    final name = _titleController.text
        .trim()
        .replaceAll(' ', '_')
        .toLowerCase();
    final sanitizedName = name.isEmpty ? 'modul_baru' : name;
    final path = 'assets/pdfs/$sanitizedName.pdf';

    _repository.updateLesson(
      widget.courseId,
      lesson.copyWith(materialPdfPath: path),
    );
    setState(() {});

    AppToast.show(
      context,
      title: 'File dipilih.',
      message: 'Dokumen PDF berhasil ditambahkan.',
      severity: AppFeedbackSeverity.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final lesson = _lesson;

    if (lesson == null) {
      return Scaffold(
        backgroundColor: ext.background,
        appBar: const AppAppBar(title: 'Edit Modul'),
        body: const AppEmptyState(
          icon: Icons.search_off_rounded,
          title: 'Modul Tidak Ditemukan',
          message: 'Modul yang kamu cari tidak tersedia.',
        ),
      );
    }

    return Scaffold(
      backgroundColor: ext.background,
      appBar: const AppAppBar(title: 'Edit Modul'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ResponsiveContainer(
          maxWidth: 720,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppPageHeader(
                title: 'Informasi Modul',
                subtitle: 'Edit metadata dan unggah dokumen materi (PDF).',
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _titleController,
                label: 'Judul Modul',
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _descriptionController,
                label: 'Deskripsi Modul',
                maxLines: 3,
                minLines: 2,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Simpan Info Modul',
                variant: AppButtonVariant.secondary,
                isFullWidth: true,
                onPressed: _saveModule,
              ),
              const SizedBox(height: AppSpacing.xl),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              Text(
                'DOKUMEN MATERI (PDF)',
                style: AppTypeScale.labelMedium.copyWith(
                  color: ext.textSecondary,
                  letterSpacing: 1.25,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Unggah dokumen berformat PDF yang akan dibaca oleh siswa. Sistem AI akan menggunakan dokumen ini untuk menghasilkan game dan latihan interaktif.',
                style: AppTypeScale.bodySmall.copyWith(
                  color: ext.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  border: Border.all(color: ext.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: ext.card,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        border: Border.all(color: ext.border),
                      ),
                      child: Icon(
                        Icons.picture_as_pdf_rounded,
                        color: lesson.materialPdfPath != null
                            ? scheme.error
                            : ext.textDisabled,
                        size: AppIconSizes.xl,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.materialPdfPath != null
                                ? lesson.materialPdfPath!.split('/').last
                                : 'Belum ada file',
                            style: AppTypeScale.titleSmall.copyWith(
                              color: lesson.materialPdfPath != null
                                  ? ext.textPrimary
                                  : ext.textDisabled,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            lesson.materialPdfPath != null
                                ? 'Format: PDF • Ukuran: 1.2 MB'
                                : 'Upload file PDF maksimal 10MB',
                            style: AppTypeScale.bodySmall.copyWith(
                              color: ext.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    AppButton(
                      label: lesson.materialPdfPath != null
                          ? 'Ganti File'
                          : 'Pilih File',
                      variant: lesson.materialPdfPath != null
                          ? AppButtonVariant.outlined
                          : AppButtonVariant.primary,
                      onPressed: _simulatePdfUpload,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
