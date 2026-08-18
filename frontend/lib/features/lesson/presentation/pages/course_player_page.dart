//**
// frontend/features/lesson/presentation/pages/course_player_page.dart
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
import 'package:flutter/material.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/features/tutor/tutor.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../data/mock_module_content_generator.dart';
import '../../domain/entities/course_player_preview.dart';
import '../../domain/entities/lesson_exercise.dart';
import '../stages/game_stage.dart';
import '../stages/latihan_stage.dart';
import '../stages/materi_stage.dart';
import '../widgets/learning_navigation_bar.dart';
import '../widgets/lesson_stage_indicator.dart';

class CoursePlayerPage extends StatefulWidget {
  const CoursePlayerPage({
    super.key,
    required this.courseId,
    required this.lessonId,
    this.preview,
  });

  final String courseId;

  final String lessonId;

  final CoursePlayerPreview? preview;

  @override
  State<CoursePlayerPage> createState() => _CoursePlayerPageState();
}

class _CoursePlayerPageState extends State<CoursePlayerPage> {
  final CourseRepository _courses = MockCourseRepository();
  final LearningProgressController _progress =
      LearningProgressController.instance;

  int _stageIndex = 0;
  int _gameIndex = 0;

  final GlobalKey<LearningNavigationBarState> _learningControlsKey =
      GlobalKey<LearningNavigationBarState>();

  @override
  Widget build(BuildContext context) {
    final preview = widget.preview;
    final course = preview?.course ?? _courses.findById(widget.courseId);
    if (course == null) {
      return _missingScaffold(title: 'Pelajaran', body: const _CourseMissing());
    }

    return ListenableBuilder(
      listenable: _progress,
      builder: (context, _) {
        final lessons = preview?.lessons ?? _progress.lessonStates(course.id);
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

        final games =
            preview?.gameByLesson[lesson.id] ??
            MockModuleContentGenerator.generateGames(
              lessonId: lesson.id,
              title: lesson.title,
              language: _languageForCourse(course),
            );
        final latihanExercise =
            preview?.latihanByLesson[lesson.id] ??
            MockModuleContentGenerator.generateExercise(
              lessonId: lesson.id,
              title: lesson.title,
              language: _languageForCourse(course),
            );

        final stageView = switch (_stageIndex) {
          0 => MateriStageView(lesson: lesson),
          1 => GameStageView(
            lesson: lesson,
            lessonNumber: index + 1,
            games: games,
            gameIndex: _gameIndex,
          ),
          _ => LatihanStageView(
            lesson: lesson,
            exercise: latihanExercise,
            onSuccess: () {
              if (preview == null) {
                _progress.completeLesson(course.id, lesson.id);
              }
            },
          ),
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
                    key: ValueKey<String>('${_stageIndex}_$_gameIndex'),
                    child: stageView,
                  ),
                ),
              ),
              LearningNavigationBar(
                key: _learningControlsKey,
                stageIndex: _stageIndex,
                stageCount: 3,
                hasPrevious: index > 0 || _stageIndex > 0,
                isLast: isLast,
                isDone: isDone,
                onUndo: _undoHandler(course, index, games),
                onNext: () => _handleNext(course, index, isDone, isLast, games),
                onEnd: () => _showEndSessionDialog(context),
              ),
            ],
          ),
        );
      },
    );
  }

  VoidCallback? _undoHandler(
    CourseDetail course,
    int index,
    List<LessonExercise> games,
  ) {
    if (_stageIndex == 2) {
      return () => setState(() => _stageIndex = 1);
    }
    if (_stageIndex == 1) {
      return () => setState(() => _stageIndex = 0);
    }
    if (index > 0) {
      return () => _openLesson(course, _lessonStates(course)[index - 1]);
    }
    return null;
  }

  String get _stageContextTitle => switch (_stageIndex) {
    0 => 'materi',
    1 => 'tantangan Game',
    _ => 'latihan',
  };

  void _handleNext(
    CourseDetail course,
    int index,
    bool isDone,
    bool isLast,
    List<LessonExercise> games,
  ) {
    if (_stageIndex == 0) {
      setState(() => _stageIndex = 1);
      return;
    }
    if (_stageIndex == 1) {
      setState(() => _stageIndex = 2);
      return;
    }
    _onPrimary(course, index, isDone, isLast);
  }

  void _onPrimary(CourseDetail course, int index, bool isDone, bool isLast) {
    final preview = widget.preview;
    if (preview != null) {
      if (isLast) {
        AppToast.show(
          context,
          title: 'Pratinjau Selesai',
          message: 'Kamu sudah melihat seluruh pelajaran dalam pratinjau.',
          severity: AppFeedbackSeverity.success,
        );
        Navigator.of(context).pop();
        return;
      }
      _openLesson(course, preview.lessons[index + 1]);
      return;
    }

    final lessons = _lessonStates(course);
    final lesson = lessons[index];
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

    _openLesson(course, lessons[index + 1]);
  }

  void _openLesson(CourseDetail course, CourseLesson lesson) {
    final route = widget.preview != null
        ? AppRoutes.mentorLessonPreview
        : AppRoutes.lessonDetail;
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.resolve(route, {'courseId': course.id, 'lessonId': lesson.id}),
    );
  }

  List<CourseLesson> _lessonStates(CourseDetail course) {
    return widget.preview?.lessons ?? _progress.lessonStates(course.id);
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

String _languageForCourse(CourseDetail course) {
  final title = course.title.toLowerCase();
  if (title.contains('python')) return 'Python';
  if (title.contains('javascript')) return 'JavaScript';
  if (title.contains('typescript')) return 'TypeScript';
  if (title.contains('php') || title.contains('laravel')) return 'PHP';
  if (title.contains('flutter') || title.contains('dart')) return 'Dart';
  if (title.contains('kotlin') || title.contains('android')) return 'Kotlin';
  if (title.contains('swift') || title.contains('ios')) return 'Swift';
  if (title.contains('sql') ||
      title.contains('mysql') ||
      title.contains('postgres'))
    return 'SQL';
  if (title.contains('html') || title.contains('css')) return 'HTML';
  return 'Python';
}
