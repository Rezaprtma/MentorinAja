/// Mentor course editor — the command center for one course draft.
///
/// Edits the course header (title and description), maintains the objectives
/// list, and lists the course lessons with their readiness status. Each lesson
/// opens its dedicated editor; a "Tambah Pelajaran" action creates a fresh
/// lesson and jumps straight into it. Changes persist through
/// [CourseAuthoringRepository].
library;

import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../data/mock_course_authoring_repository.dart';
import '../../domain/entities/course_authoring_draft.dart';
import '../../domain/entities/lesson_draft.dart';
import '../../domain/repositories/course_authoring_repository.dart';
import '../widgets/course_objective_editor.dart';
import '../widgets/course_lesson_tile.dart';

class CourseEditorPage extends StatefulWidget {
  const CourseEditorPage({
    super.key,
    required this.courseId,
    this.repository,
    this.onOpenLesson,
  });

  final String courseId;

  /// Injected for tests; defaults to the shared in-memory mock repository.
  final CourseAuthoringRepository? repository;

  /// Overrides lesson navigation (used by tests).
  final void Function(String courseId, String lessonId)? onOpenLesson;

  @override
  State<CourseEditorPage> createState() => _CourseEditorPageState();
}

class _CourseEditorPageState extends State<CourseEditorPage> {
  late final CourseAuthoringRepository _repository =
      widget.repository ?? MockCourseAuthoringRepository.instance;

  CourseAuthoringDraft? get _draft => _repository.findDraft(widget.courseId);

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final draft = _draft;
    _titleController = TextEditingController(text: draft?.title ?? '');
    _descriptionController = TextEditingController(
      text: draft?.description ?? '',
    );
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
        updatedAt: DateTime.now(),
      ),
    );
    AppToast.show(
      context,
      title: 'Course diperbarui.',
      message: 'Perubahan header course sudah disimpan.',
      severity: AppFeedbackSeverity.success,
    );
  }

  void _addObjective(String value) {
    final draft = _draft;
    if (draft == null || value.trim().isEmpty) return;
    _repository.updateDraft(
      draft.copyWith(
        objectives: [...draft.objectives, value.trim()],
        updatedAt: DateTime.now(),
      ),
    );
    setState(() {});
  }

  void _removeObjective(int index) {
    final draft = _draft;
    if (draft == null) return;
    final objectives = [...draft.objectives]..removeAt(index);
    _repository.updateDraft(
      draft.copyWith(objectives: objectives, updatedAt: DateTime.now()),
    );
    setState(() {});
  }

  void _addLesson() {
    final draft = _draft;
    if (draft == null) return;
    final lesson = LessonDraft(
      id: 'lesson-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Pelajaran Baru',
      description: 'Deskripsi pelajaran baru.',
      order: draft.lessons.length,
    );
    final updated = _repository.addLesson(draft.id, lesson);
    setState(() {});
    _openLesson(updated.id, lesson.id);
  }

  void _removeLesson(LessonDraft lesson) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Hapus Pelajaran?',
      message: 'Pelajaran "${lesson.title}" akan dihapus dari course.',
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

    return Scaffold(
      backgroundColor: ext.background,
      appBar: const AppAppBar(title: 'Edit Course'),
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
                AppButton(
                  label: 'Simpan Perubahan',
                  variant: AppButtonVariant.secondary,
                  isFullWidth: true,
                  onPressed: _saveHeader,
                ),
                const SizedBox(height: AppSpacing.xl),
                CourseObjectiveEditor(
                  objectives: draft.objectives,
                  onAdd: _addObjective,
                  onRemove: _removeObjective,
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'PELAJARAN',
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
                    title: 'Belum Ada Pelajaran',
                    message: 'Tambahkan pelajaran pertama untuk course ini.',
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
                  label: 'Tambah Pelajaran',
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
