/// Mentor lesson editor — one lesson inside a course draft.
///
/// Edits the lesson header (title and description) and splits content authoring
/// across three tabs: Materi, Game and Latihan. Each tab edits its own payload
/// and persists changes through [CourseAuthoringRepository] on every update, so
/// the course outline always reflects the latest draft state.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../data/mock_course_authoring_repository.dart';
import '../../domain/entities/lesson_draft.dart';
import '../../domain/repositories/course_authoring_repository.dart';
import '../widgets/exercise_editor.dart';
import '../widgets/game_editor.dart';
import '../widgets/material_block_editor.dart';

class LessonEditorPage extends StatefulWidget {
  const LessonEditorPage({
    super.key,
    required this.courseId,
    required this.lessonId,
    this.repository,
  });

  final String courseId;
  final String lessonId;

  /// Injected for tests; defaults to the shared in-memory mock repository.
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

  void _saveHeader() {
    final lesson = _lesson;
    if (lesson == null) return;
    _repository.updateLesson(
      widget.courseId,
      lesson.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      ),
    );
    setState(() {});
  }

  void _saveLesson(LessonDraft updated) {
    _repository.updateLesson(widget.courseId, updated);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final lesson = _lesson;

    if (lesson == null) {
      return Scaffold(
        backgroundColor: ext.background,
        appBar: const AppAppBar(title: 'Edit Pelajaran'),
        body: const AppEmptyState(
          icon: Icons.search_off_rounded,
          title: 'Pelajaran Tidak Ditemukan',
          message: 'Pelajaran yang kamu cari tidak tersedia.',
        ),
      );
    }

    return Scaffold(
      backgroundColor: ext.background,
      appBar: const AppAppBar(title: 'Edit Pelajaran'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: ResponsiveContainer(
              maxWidth: 720,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _titleController,
                    label: 'Judul Pelajaran',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    controller: _descriptionController,
                    label: 'Deskripsi',
                    maxLines: 3,
                    minLines: 2,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: 'Simpan Perubahan',
                    variant: AppButtonVariant.secondary,
                    isFullWidth: true,
                    onPressed: _saveHeader,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(text: 'Materi'),
                      Tab(text: 'Game'),
                      Tab(text: 'Latihan'),
                    ],
                    labelColor: ext.textPrimary,
                    unselectedLabelColor: ext.textSecondary,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    labelStyle: AppTypeScale.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: AppTypeScale.labelLarge,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _TabEditor(
                          lesson: lesson,
                          builder: (lesson) => MaterialBlockEditor(
                            blocks: lesson.materialBlocks,
                            onChanged: (blocks) => _saveLesson(
                              lesson.copyWith(materialBlocks: blocks),
                            ),
                          ),
                        ),
                        _TabEditor(
                          lesson: lesson,
                          builder: (lesson) => GameEditor(
                            games: lesson.games,
                            onChanged: (games) =>
                                _saveLesson(lesson.copyWith(games: games)),
                          ),
                        ),
                        _TabEditor(
                          lesson: lesson,
                          builder: (lesson) => ExerciseEditor(
                            exercises: lesson.exercises,
                            onChanged: (exercises) => _saveLesson(
                              lesson.copyWith(exercises: exercises),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Scrollable wrapper that keeps tab content aligned and scrollable.
class _TabEditor extends StatelessWidget {
  const _TabEditor({required this.lesson, required this.builder});

  final LessonDraft lesson;
  final Widget Function(LessonDraft lesson) builder;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xxxl,
      ),
      child: ResponsiveContainer(maxWidth: 720, child: builder(lesson)),
    );
  }
}
