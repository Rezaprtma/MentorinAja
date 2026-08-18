//**
// frontend/features/course_authoring/presentation/pages/course_editor_page.dart
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

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';
import 'package:frontend/shared/enums/enums.dart';

import '../../data/mock_course_authoring_repository.dart';
import '../../domain/entities/course_authoring_draft.dart';
import '../../domain/entities/draft_status.dart';
import '../../domain/entities/lesson_draft.dart';
import '../../domain/entities/publish_validation.dart';
import '../../domain/repositories/course_authoring_repository.dart';
import '../widgets/course_lesson_tile.dart';
import '../widgets/publish_validation_panel.dart';

class CourseEditorPage extends StatefulWidget {
  const CourseEditorPage({
    super.key,
    required this.courseId,
    this.repository,
    this.onOpenLesson,
  });

  final String courseId;

  final CourseAuthoringRepository? repository;

  final void Function(String courseId, String lessonId)? onOpenLesson;

  @override
  State<CourseEditorPage> createState() => _CourseEditorPageState();
}

class _CourseEditorPageState extends State<CourseEditorPage> {
  static const List<String> _categories = [
    'Pemrograman',
    'Mobile',
    'Web',
    'Data Science',
    'Desain',
  ];

  static const List<String> _levels = ['Pemula', 'Menengah', 'Mahir'];

  late final CourseAuthoringRepository _repository =
      widget.repository ?? MockCourseAuthoringRepository.instance;

  CourseAuthoringDraft? get _draft => _repository.findDraft(widget.courseId);

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  String? _category;
  String? _level;
  ProgrammingLanguage? _language;

  @override
  void initState() {
    super.initState();
    final draft = _draft;
    _titleController = TextEditingController(text: draft?.title ?? '');
    _descriptionController = TextEditingController(
      text: draft?.description ?? '',
    );
    _category = draft?.category;
    _level = draft?.level;
    _language = ProgrammingLanguage.fromString(draft?.language ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveHeader() {
    final draft = _draft;
    if (draft == null) return;
    _repository.updateDraft(
      draft.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category,
        level: _level,
        language: _language?.displayName ?? draft.language,
        updatedAt: DateTime.now(),
      ),
    );
    AppToast.show(
      context,
      title: 'Course diperbarui.',
      message: 'Perubahan header course sudah disimpan.',
      severity: AppFeedbackSeverity.success,
    );
    setState(() {});
  }

  void _addLesson() {
    final draft = _draft;
    if (draft == null) return;
    final lesson = LessonDraft(
      id: 'lesson-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Modul Baru',
      description: 'Deskripsi modul baru.',
      order: draft.lessons.length,
    );
    final updated = _repository.addLesson(draft.id, lesson);
    setState(() {});
    _openLesson(updated.id, lesson.id);
  }

  void _removeLesson(LessonDraft lesson) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Hapus Modul?',
      message: 'Modul "${lesson.title}" akan dihapus dari course.',
      confirmLabel: 'Hapus',
      cancelLabel: 'Batal',
      isDestructive: true,
    );
    if (!confirmed || !mounted) return;
    setState(() => _repository.deleteLesson(widget.courseId, lesson.id));
  }

  void _openLesson(String courseId, String lessonId) {
    if (widget.onOpenLesson != null) {
      widget.onOpenLesson!(courseId, lessonId);
      return;
    }
    Navigator.of(context).pushNamed(
      AppRoutes.resolve(AppRoutes.mentorLessonEditor, {
        'courseId': courseId,
        'lessonId': lessonId,
      }),
    );
  }

  void _openPreview() {
    Navigator.of(context).pushNamed(
      AppRoutes.resolve(AppRoutes.mentorCoursePreview, {
        'courseId': widget.courseId,
      }),
    );
  }

  void _handlePublish() {
    final draft = _draft;
    if (draft == null) return;

    if (draft.status == DraftStatus.published) {
      setState(() => _repository.unpublishCourse(draft.id));
      AppToast.show(
        context,
        title: 'Course diturunkan.',
        message: 'Course kembali menjadi draft.',
        severity: AppFeedbackSeverity.warning,
      );
      return;
    }

    final validation = PublishValidator.validate(draft);
    if (!validation.isValid) {
      AppBottomSheet.show(
        context,
        title: 'Belum Siap Publikasi',
        subtitle: 'Lengkapi persyaratan berikut sebelum mempublikasikan.',
        child: PublishValidationPanel(validation: validation),
      );
      return;
    }

    setState(() => _repository.publishCourse(draft.id));
    AppToast.show(
      context,
      title: 'Course dipublikasikan.',
      message: 'Course sekarang terlihat oleh siswa.',
      severity: AppFeedbackSeverity.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final draft = _draft;

    if (draft == null) {
      return Scaffold(
        backgroundColor: ext.background,
        appBar: const AppAppBar(title: 'Edit Course'),
        body: const AppEmptyState(
          icon: Icons.search_off_rounded,
          title: 'Course Tidak Ditemukan',
          message: 'Course yang kamu cari tidak tersedia.',
        ),
      );
    }

    final lessons = draft.lessons..sort((a, b) => a.order.compareTo(b.order));
    final published = draft.status == DraftStatus.published;

    return Scaffold(
      backgroundColor: ext.background,
      appBar: AppAppBar(
        title: 'Edit Course',
        actions: [
          AppIconButton(
            icon: Icons.visibility_outlined,
            tooltip: 'Pratinjau',
            onPressed: _openPreview,
          ),
          AppIconButton(
            icon: published
                ? Icons.unpublished_outlined
                : Icons.publish_outlined,
            tooltip: published ? 'Tarik Publikasi' : 'Publikasikan',
            onPressed: _handlePublish,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.sm,
          bottom: AppSpacing.xxxl,
        ),
        children: [
          ResponsiveContainer(
            maxWidth: 720,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppPageHeader(title: draft.title, subtitle: draft.category),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _titleController,
                  label: 'Nama Course',
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _descriptionController,
                  label: 'Deskripsi',
                  maxLines: 3,
                  minLines: 2,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppDropdownField.strings(
                        initialValue: _category,
                        items: _categories,
                        label: 'Kategori',
                        hint: 'Pilih kategori',
                        onChanged: (value) => setState(() => _category = value),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppDropdownField.strings(
                        initialValue: _level,
                        items: _levels,
                        label: 'Level',
                        hint: 'Pilih level',
                        onChanged: (value) => setState(() => _level = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppDropdownField<ProgrammingLanguage>(
                  initialValue: _language,
                  items: ProgrammingLanguage.values
                      .map(
                        (lang) => DropdownMenuItem<ProgrammingLanguage>(
                          value: lang,
                          child: Text(lang.displayName),
                        ),
                      )
                      .toList(),
                  label: 'Bahasa Pemrograman',
                  hint: 'Pilih bahasa',
                  onChanged: (value) => setState(() => _language = value),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Simpan Perubahan',
                  variant: AppButtonVariant.secondary,
                  isFullWidth: true,
                  onPressed: _saveHeader,
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'MODUL BELAJAR',
                        style: AppTypeScale.labelMedium.copyWith(
                          color: ext.textSecondary,
                          letterSpacing: 1.25,
                        ),
                      ),
                    ),
                    Text(
                      '${lessons.length}',
                      style: AppTypeScale.labelMedium.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (lessons.isEmpty)
                  const AppEmptyState(
                    compact: true,
                    icon: Icons.play_lesson_outlined,
                    title: 'Belum Ada Modul',
                    message: 'Tambahkan modul pertama untuk course ini.',
                  )
                else
                  for (var i = 0; i < lessons.length; i++) ...[
                    CourseLessonTile(
                      lesson: lessons[i],
                      onTap: () => _openLesson(draft.id, lessons[i].id),
                      onDelete: () => _removeLesson(lessons[i]),
                    ),
                    if (i < lessons.length - 1)
                      const SizedBox(height: AppSpacing.sm),
                  ],
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Tambah Modul',
                  leadingIcon: Icons.add,
                  variant: AppButtonVariant.outlined,
                  isFullWidth: true,
                  onPressed: _addLesson,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
