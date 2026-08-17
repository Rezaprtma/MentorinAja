import 'package:flutter/material.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/features/tutor/tutor.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../data/mock_lesson_content.dart';
import '../../data/mock_lesson_exercises.dart';
import '../stages/game_stage.dart';
import '../stages/latihan_stage.dart';
import '../stages/materi_stage.dart';
import '../widgets/learning_navigation_bar.dart';
import '../widgets/lesson_stage_indicator.dart';

/// Full-screen lesson experience for a single course lesson.
///
/// Splits the lesson into three stage views — Materi, Game, Latihan — swapped
/// through an animated switch. The floating control bar moves between stages
/// first and across lessons once the last stage is reached. Completing the
/// last lesson routes to the course completion page.
class CoursePlayerPage extends StatefulWidget {
  const CoursePlayerPage({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  /// Stable course identifier (see [CourseIdentifier]).
  final String courseId;

  /// Stable lesson identifier within the course.
  final String lessonId;

  @override
  State<CoursePlayerPage> createState() => _CoursePlayerPageState();
}

class _CoursePlayerPageState extends State<CoursePlayerPage> {
  final CourseRepository _courses = MockCourseRepository();
  final LearningProgressController _progress =
      LearningProgressController.instance;

  int _stageIndex = 0;

  final GlobalKey<LearningNavigationBarState> _learningControlsKey =
      GlobalKey<LearningNavigationBarState>();

  @override
  Widget build(BuildContext context) {
    final course = _courses.findById(widget.courseId);
    if (course == null) {
      return _missingScaffold(title: 'Pelajaran', body: const _CourseMissing());
    }

    return ListenableBuilder(
      listenable: _progress,
      builder: (context, _) {
        final lessons = _progress.lessonStates(course.id);
        final index = lessons.indexWhere((l) => l.id == widget.lessonId);
        if (index < 0) {
          return _missingScaffold(
            title: course.title,
            body: _LessonMissing(onBack: () => Navigator.of(context).pop()),
          );
        }

        final lesson = lessons[index];
        final isLast = index == lessons.length - 1;
        final isDone = lesson.state == CourseLessonState.completed;
        final code = MockLessonContent.snippetFor(course, lesson);
        final materiBlocks = MockLessonContent.materiBlocks(
          course,
          lesson,
          index: index,
          total: lessons.length,
        );
        final gameExercise = MockLessonExercises.gameExercise(course, code);
        final latihanExercises = MockLessonExercises.latihanExercises(
          course,
          code,
        );

        final stageView = switch (_stageIndex) {
          0 => MateriStageView(lesson: lesson, blocks: materiBlocks),
          1 => GameStageView(
            lesson: lesson,
            lessonNumber: index + 1,
            exercise: gameExercise,
          ),
          _ => LatihanStageView(lesson: lesson, exercises: latihanExercises),
        };

        return Scaffold(
          backgroundColor: context.appColors.background,
          appBar: AppAppBar(
            centerTitle: true,
            titleWidget: _PlayerTitle(
              courseTitle: course.title,
              lessonTitle: lesson.title,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(44),
              child: Container(
                color: context.appColors.background,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsivePadding.horizontal(context),
                ),
                child: LessonStageIndicator(current: _stageIndex),
              ),
            ),
            actions: [
              AppIconButton(
                icon: Icons.chat_bubble_outline_rounded,
                tooltip: 'Buka Mentorin AI',
                onPressed: () => showAiTutorPanel(
                  context,
                  lessonContext: TutorLessonContext(
                    courseId: course.id,
                    courseTitle: course.title,
                    lessonId: lesson.id,
                    lessonTitle: lesson.title,
                    stageTitle: _stageContextTitle,
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Listener(
                onPointerDown: (_) => _learningControlsKey.currentState?.poke(),
                child: AnimatedSwitcher(
                  duration: AppDurations.medium,
                  child: KeyedSubtree(
                    key: ValueKey<int>(_stageIndex),
                    child: stageView,
                  ),
                ),
              ),
              LearningNavigationBar(
                key: _learningControlsKey,
                stageIndex: _stageIndex,
                stageCount: 3,
                hasPrevious: index > 0,
                isLast: isLast,
                isDone: isDone,
                onUndo: _undoHandler(course, index),
                onNext: () => _handleNext(course, index, isDone, isLast),
                onEnd: () => _showEndSessionDialog(context),
              ),
            ],
          ),
        );
      },
    );
  }

  VoidCallback? _undoHandler(CourseDetail course, int index) {
    if (_stageIndex > 0) {
      return () => setState(() => _stageIndex -= 1);
    }
    if (index > 0) {
      return () =>
          _openLesson(course, _progress.lessonStates(course.id)[index - 1]);
    }
    return null;
  }

  /// Friendly name of the active stage, used to contextualize the AI Tutor.
  String get _stageContextTitle => switch (_stageIndex) {
    0 => 'materi',
    1 => 'tantangan Game',
    _ => 'latihan',
  };

  void _handleNext(CourseDetail course, int index, bool isDone, bool isLast) {
    if (_stageIndex < 2) {
      setState(() => _stageIndex += 1);
      return;
    }
    _onPrimary(course, index, isDone, isLast);
  }

  void _onPrimary(CourseDetail course, int index, bool isDone, bool isLast) {
    final lesson = _progress.lessonStates(course.id)[index];
    if (!isDone) {
      _progress.completeLesson(course.id, lesson.id);
      if (!isLast) {
        AppToast.show(
          context,
          title: 'Pelajaran Selesai',
          message: 'Lanjut ke pelajaran berikutnya.',
          severity: AppFeedbackSeverity.success,
        );
      }
    }

    if (isLast) {
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.resolve(AppRoutes.courseCompleted, {'courseId': course.id}),
      );
      return;
    }

    final next = _progress.lessonStates(course.id)[index + 1];
    _openLesson(course, next);
  }

  void _openLesson(CourseDetail course, CourseLesson lesson) {
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.resolve(AppRoutes.lessonDetail, {
        'courseId': course.id,
        'lessonId': lesson.id,
      }),
    );
  }

  Future<void> _showEndSessionDialog(BuildContext context) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Keluar dari Sesi?',
      message:
          'Kamu bisa melanjutkan pelajaran ini kapan saja. Progress akan tersimpan otomatis.',
      confirmLabel: 'Keluar',
      cancelLabel: 'Batal',
    );
    if (confirmed && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _missingScaffold({required String title, required Widget body}) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppAppBar(title: title),
      body: body,
    );
  }
}

/// Compact centered identity for the private-tutor lesson top bar.
class _PlayerTitle extends StatelessWidget {
  const _PlayerTitle({required this.courseTitle, required this.lessonTitle});

  final String courseTitle;
  final String lessonTitle;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          courseTitle,
          style: AppTypeScale.titleSmall.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w800,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          lessonTitle,
          style: AppTypeScale.labelSmall.copyWith(color: ext.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Shown when the course id does not resolve in the catalog.
class _CourseMissing extends StatelessWidget {
  const _CourseMissing();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppEmptyState(
        icon: Icons.search_off_rounded,
        title: 'Course Tidak Ditemukan',
        message: 'Course ini belum tersedia. Coba pilih course lain.',
        actionLabel: 'Kembali',
        onAction: () => Navigator.of(context).maybePop(),
      ),
    );
  }
}

/// Shown when the lesson id does not exist inside the course.
class _LessonMissing extends StatelessWidget {
  const _LessonMissing({this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppEmptyState(
        icon: Icons.menu_book_outlined,
        title: 'Pelajaran Tidak Ditemukan',
        message: 'Pelajaran ini belum tersedia dalam course.',
        actionLabel: 'Lihat Materi',
        onAction: onBack,
      ),
    );
  }
}
