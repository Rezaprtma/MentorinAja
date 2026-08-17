import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/features/course/course.dart';
import 'package:frontend/features/lesson/lesson.dart';
import 'package:frontend/features/tutor/tutor.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

Widget _buildApp(String courseId, String lessonId) {
  return MaterialApp(
    theme: AppTheme.light(),
    onGenerateRoute: (settings) {
      final name = settings.name ?? '';
      final parts = name.split('/');
      if (name.contains('/lesson/')) {
        return MaterialPageRoute<void>(
          builder: (_) => CoursePlayerPage(
            courseId: parts.length > 2 ? parts[2] : courseId,
            lessonId: parts.length > 4 ? parts[4] : lessonId,
          ),
        );
      }
      if (name.endsWith('/completed')) {
        return MaterialPageRoute<void>(
          builder: (_) => CourseCompletedPage(courseId: courseId),
        );
      }
      return MaterialPageRoute<void>(builder: (_) => const Scaffold());
    },
    home: CoursePlayerPage(courseId: courseId, lessonId: lessonId),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _advanceToLatihan(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Pelajaran berikutnya'));
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip('Pelajaran berikutnya'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    LearningProgressController.instance.resetAll();
  });

  testWidgets('renders the Materi stage with lesson structure', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    expect(find.text('Dasar Python'), findsWidgets);
    expect(find.text('Pelajaran 13 dari 20'), findsNothing);
    expect(find.text('Modularitas dan Import'), findsWidgets);
    expect(find.byType(LessonStageIndicator), findsOneWidget);
    expect(find.byType(LearningNavigationBar), findsOneWidget);
    expect(find.byTooltip('Pelajaran berikutnya'), findsOneWidget);
    expect(find.byTooltip('Buka Mentorin AI'), findsOneWidget);
    expect(find.text('PELAJARI'), findsOneWidget);
    expect(find.text('LIHAT CONTOH'), findsOneWidget);

    expect(find.text('Selanjutnya'), findsNothing);
    expect(find.text('Kontrol Belajar'), findsNothing);
    expect(find.text('Tandai Selesai'), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('renders exactly four icon-only controls in order', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    expect(find.byTooltip('Pelajaran sebelumnya'), findsOneWidget);
    expect(find.byTooltip('Pelajaran berikutnya'), findsOneWidget);
    expect(find.byTooltip('Microphone nonaktif'), findsOneWidget);
    expect(find.byTooltip('Akhiri sesi belajar'), findsOneWidget);

    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
    expect(find.byIcon(Icons.mic_off_rounded), findsOneWidget);
    expect(find.byIcon(Icons.logout_rounded), findsOneWidget);

    final buttons = tester
        .widgetList<IconButton>(
          find.descendant(
            of: find.byType(LearningNavigationBar),
            matching: find.byType(IconButton),
          ),
        )
        .toList();
    final icons = buttons
        .map((button) => button.icon)
        .whereType<Icon>()
        .map((icon) => icon.icon)
        .toList();
    expect(icons, <IconData>[
      Icons.arrow_back_rounded,
      Icons.arrow_forward_rounded,
      Icons.mic_off_rounded,
      Icons.logout_rounded,
    ]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stage navigation advances through Materi, Game, Latihan', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();

    expect(find.text('Level 13'), findsOneWidget);
    expect(find.text('TANTANGAN'), findsOneWidget);
    expect(find.text('Lengkapi function hitung'), findsOneWidget);
    expect(find.text('Perbaiki kode berikut'), findsNothing);
    expect(find.text('Periksa Jawaban'), findsNothing);
    expect(find.text('Periksa Lagi'), findsNothing);

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();

    expect(find.text('Perbaiki kode berikut'), findsOneWidget);
    expect(find.text('Jelaskan baris kode ini'), findsOneWidget);
    expect(find.text('Lengkapi function hitung'), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('undo returns to the previous stage then the previous lesson', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();
    expect(find.text('Level 13'), findsOneWidget);

    await tester.tap(find.byTooltip('Pelajaran sebelumnya'));
    await tester.pumpAndSettle();
    expect(find.text('Level 13'), findsNothing);

    await tester.tap(find.byTooltip('Pelajaran sebelumnya'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Scope dan Closure'), findsWidgets);
    expect(find.text('Pelajaran 12 dari 20'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('completing a lesson advances to the next one', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    await _advanceToLatihan(tester);

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Pelajaran Selesai'), findsOneWidget);
    expect(find.text('Error Handling'), findsWidgets);
    expect(find.text('Pelajaran 14 dari 20'), findsNothing);

    await tester.pump(const Duration(milliseconds: 4500));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('AI Tutor panel opens and replies locally', (tester) async {
    _setSurface(tester, const Size(430, 932));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();
    await tester.tap(find.byTooltip('Buka Mentorin AI'));
    await tester.pumpAndSettle();

    expect(find.text('Mentorin AI'), findsOneWidget);
    expect(find.text('Jelaskan bagian ini'), findsOneWidget);
    expect(find.byTooltip('Kirim pertanyaan'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Kenapa kode ini error?');
    await tester.pump();
    await tester.tap(find.byTooltip('Kirim pertanyaan'));
    await tester.pumpAndSettle();

    expect(find.text('Kenapa kode ini error?'), findsOneWidget);
    expect(find.textContaining('Biasanya error muncul'), findsOneWidget);
    expect(find.text('Jelaskan bagian ini'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AI Tutor composer enables send only after typing', (
    tester,
  ) async {
    _setSurface(tester, const Size(430, 932));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();
    await tester.tap(find.byTooltip('Buka Mentorin AI'));
    await tester.pumpAndSettle();

    // A disabled send does not submit anything.
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Mentorin AI sedang menyusun jawaban...'), findsNothing);
    expect(find.textContaining('Biasanya error muncul'), findsNothing);

    await tester.enterText(find.byType(TextField), 'Kenapa kode ini error?');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AiTutorPanel),
        matching: find.text('Kenapa kode ini error?'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AiTutorPanel),
        matching: find.textContaining('Biasanya error muncul'),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('AI Tutor header reflects the active stage context', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Buka Mentorin AI'));
    await tester.pumpAndSettle();

    expect(find.text('Mentorin AI'), findsOneWidget);
    expect(find.text('Membantu tantangan Game'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AiTutorPanel),
        matching: find.byType(AppSvg),
      ),
      findsOneWidget,
    );
    final logo = tester.widget<AppSvg>(
      find.descendant(
        of: find.byType(AiTutorPanel),
        matching: find.byType(AppSvg),
      ),
    );
    expect(logo.assetPath, AppLogo.onBrand);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AI Tutor renders reusable code blocks in assistant replies', (
    tester,
  ) async {
    _setSurface(tester, const Size(430, 932));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();
    await tester.tap(find.byTooltip('Buka Mentorin AI'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Kasih contoh kode');
    await tester.pump();
    await tester.tap(find.byTooltip('Kirim pertanyaan'));
    await tester.pumpAndSettle();

    expect(find.byType(AiTutorPanel), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AiTutorPanel),
        matching: find.byType(AppCodeBlock),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AiTutorPanel),
        matching: find.textContaining('def hitung_rata_rata'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AiTutorPanel),
        matching: find.byTooltip('Salin kode'),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('course progress header stays absent across every stage', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    expect(find.text('Pelajaran 13 dari 20'), findsNothing);

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();
    expect(find.text('Pelajaran 13 dari 20'), findsNothing);

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();
    expect(find.text('Pelajaran 13 dari 20'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Game completion challenge self-evaluates without a submit', (
    tester,
  ) async {
    _setSurface(tester, const Size(430, 1100));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();

    expect(find.text('Periksa Jawaban'), findsNothing);
    expect(find.text('Periksa Lagi'), findsNothing);

    final chip = find.descendant(
      of: find.byType(Wrap),
      matching: find.text('nilai'),
    );
    await tester.tap(chip);
    await tester.pump();
    await tester.tap(chip);
    await tester.pumpAndSettle();

    expect(find.text('Tepat sekali! Kode kamu benar.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AI Tutor opens without overflow at compact and tablet widths', (
    tester,
  ) async {
    for (final size in const [
      Size(320, 568),
      Size(360, 640),
      Size(390, 844),
      Size(430, 932),
      Size(1024, 1366),
    ]) {
      _setSurface(tester, size);
      await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
      await tester.pump();
      await tester.tap(find.byTooltip('Buka Mentorin AI'));
      await tester.pumpAndSettle();

      expect(find.byType(AiTutorPanel), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byTooltip('Tutup Mentorin AI'));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('AI Tutor stays usable at large text scale', (tester) async {
    _setSurface(tester, const Size(390, 844));
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();
    await tester.tap(find.byTooltip('Buka Mentorin AI'));
    await tester.pumpAndSettle();

    expect(find.byType(AiTutorPanel), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('composer floats above the bottom safe-area inset', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    tester.view.padding = const FakeViewPadding(bottom: 34);
    addTearDown(tester.view.resetPadding);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: AiTutorPanel(
            controller: TutorController(
              context: const TutorLessonContext(
                courseId: 'dasar-python',
                courseTitle: 'Dasar Python',
                lessonId: 'lesson-13',
                lessonTitle: 'Modularitas dan Import',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final panelRect = tester.getRect(find.byType(AiTutorPanel));
    final composerRect = tester.getRect(find.byType(TextField));
    expect(panelRect.bottom - composerRect.bottom, greaterThanOrEqualTo(34));
    expect(tester.takeException(), isNull);
  });

  testWidgets('chat entry and composer expose semantic labels', (tester) async {
    _setSurface(tester, const Size(430, 932));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    expect(find.byTooltip('Buka Mentorin AI'), findsOneWidget);

    await tester.tap(find.byTooltip('Buka Mentorin AI'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Tutup Mentorin AI'), findsOneWidget);
    expect(find.byTooltip('Kirim pertanyaan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('completing the last lesson routes to the completed page', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-20'));
    await tester.pump();

    await _advanceToLatihan(tester);

    expect(find.byTooltip('Pelajaran berikutnya'), findsOneWidget);

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Selamat, Course Selesai!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'an already finished course shows the completion state at the last stage',
    (tester) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(_buildApp('laravel-untuk-pemula', 'lesson-15'));
      await tester.pump();

      await _advanceToLatihan(tester);

      expect(find.byTooltip('Pelajaran berikutnya'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('unknown course id shows an empty state', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('tidak-ada', 'lesson-1'));
    await tester.pump();

    expect(find.text('Course Tidak Ditemukan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown lesson id shows an empty state', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-99'));
    await tester.pump();

    expect(find.text('Pelajaran Tidak Ditemukan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('control bar auto hides and shows a collapsed chevron', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    expect(find.byTooltip('Pelajaran berikutnya'), findsOneWidget);

    await tester.pump(
      LearningNavigationBarState.inactivityDelay +
          const Duration(milliseconds: 100),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Pelajaran berikutnya'), findsNothing);
    expect(find.byTooltip('Tampilkan kontrol belajar'), findsOneWidget);
    expect(find.text('Kontrol Belajar'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping the lesson content restores the controls', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    await tester.pump(
      LearningNavigationBarState.inactivityDelay +
          const Duration(milliseconds: 100),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('Tampilkan kontrol belajar'), findsOneWidget);

    await tester.tapAt(const Offset(200, 400));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Pelajaran berikutnya'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('collapsed chevron restores the controls', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    await tester.pump(
      LearningNavigationBarState.inactivityDelay +
          const Duration(milliseconds: 100),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Tampilkan kontrol belajar'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Pelajaran berikutnya'), findsOneWidget);
    expect(find.byTooltip('Tampilkan kontrol belajar'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  double barBottom(WidgetTester tester) {
    final rect = tester.getRect(find.byType(LearningNavigationBar));
    final height =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    return height - rect.bottom;
  }

  Rect barRect(WidgetTester tester) =>
      tester.getRect(find.byType(LearningNavigationBar));

  Finder pillFinder() => find.byWidgetPredicate(
    (w) => w is Material && w.elevation == AppElevation.md,
  );

  void expectSameRect(Rect a, Rect b) {
    expect(a.left, moreOrLessEquals(b.left, epsilon: 0.5));
    expect(a.top, moreOrLessEquals(b.top, epsilon: 0.5));
    expect(a.right, moreOrLessEquals(b.right, epsilon: 0.5));
    expect(a.bottom, moreOrLessEquals(b.bottom, epsilon: 0.5));
  }

  Finder stageScroll(String marker) => find.ancestor(
    of: find.text(marker),
    matching: find.byType(SingleChildScrollView),
  );

  Future<void> scrollStage(WidgetTester tester, String marker) async {
    await tester.drag(stageScroll(marker), const Offset(0, -600));
    await tester.pumpAndSettle();
  }

  testWidgets('learning controls stay viewport-fixed while Materi scrolls', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    final before = barBottom(tester);
    await scrollStage(tester, 'PELAJARI');
    final after = barBottom(tester);

    expect(after, before);
    expect(tester.takeException(), isNull);
  });

  testWidgets('learning controls stay viewport-fixed while Game scrolls', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();
    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();
    expect(find.text('Level 13'), findsOneWidget);

    final before = barBottom(tester);
    await scrollStage(tester, 'Level 13');
    final after = barBottom(tester);

    expect(after, before);
    expect(tester.takeException(), isNull);
  });

  testWidgets('learning controls stay viewport-fixed while Latihan scrolls', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();
    await _advanceToLatihan(tester);
    expect(find.text('Perbaiki kode berikut'), findsOneWidget);

    final before = barBottom(tester);
    await scrollStage(tester, 'Perbaiki kode berikut');
    final after = barBottom(tester);

    expect(after, before);
    expect(tester.takeException(), isNull);
  });

  testWidgets('collapsed and expanded controls share the same bottom anchor', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    final expandedGap = barBottom(tester);

    await tester.pump(
      LearningNavigationBarState.inactivityDelay +
          const Duration(milliseconds: 100),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('Tampilkan kontrol belajar'), findsOneWidget);

    final collapsedGap = barBottom(tester);
    expect(collapsedGap, moreOrLessEquals(expandedGap, epsilon: 0.5));

    await scrollStage(tester, 'PELAJARI');
    expect(barBottom(tester), moreOrLessEquals(collapsedGap, epsilon: 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'learning controls keep a fixed viewport position across widths',
    (tester) async {
      for (final size in const [
        Size(320, 568),
        Size(360, 640),
        Size(390, 844),
        Size(430, 932),
        Size(1024, 1366),
      ]) {
        _setSurface(tester, size);
        await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
        await tester.pump();

        final before = barBottom(tester);
        await scrollStage(tester, 'PELAJARI');
        expect(barBottom(tester), before);
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets('learning controls stay fixed at large text scale', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    final before = barBottom(tester);
    await scrollStage(tester, 'PELAJARI');
    expect(barBottom(tester), before);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'control bar is a viewport sibling, not a child of scroll content',
    (tester) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
      await tester.pump();

      expect(stageScroll('PELAJARI'), findsOneWidget);
      expect(
        find.descendant(
          of: stageScroll('PELAJARI'),
          matching: find.byType(LearningNavigationBar),
        ),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Materi, Game and Latihan share one viewport anchor', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    final materi = barRect(tester);

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();
    final game = barRect(tester);

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();
    final latihan = barRect(tester);

    expectSameRect(game, materi);
    expectSameRect(latihan, materi);
    expect(tester.takeException(), isNull);
  });

  testWidgets('expanded pill keeps identical geometry on every stage', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    final materi = tester.getRect(pillFinder());

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();
    final game = tester.getRect(pillFinder());

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();
    final latihan = tester.getRect(pillFinder());

    expectSameRect(game, materi);
    expectSameRect(latihan, materi);
    expect(tester.takeException(), isNull);
  });

  testWidgets('collapsed chevron shares the same anchor on every stage', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    Future<void> hide() async {
      await tester.pump(
        LearningNavigationBarState.inactivityDelay +
            const Duration(milliseconds: 100),
      );
      await tester.pumpAndSettle();
    }

    final restore = find.byTooltip('Tampilkan kontrol belajar');

    await hide();
    final materi = tester.getRect(restore);

    await tester.tap(restore);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();
    await hide();
    final game = tester.getRect(restore);

    await tester.tap(restore);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();
    await hide();
    final latihan = tester.getRect(restore);

    expectSameRect(game, materi);
    expectSameRect(latihan, materi);
    expect(tester.takeException(), isNull);
  });

  testWidgets('expanded and collapsed share the same visual bottom anchor', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    final expandedBottom = tester.getRect(pillFinder()).bottom;

    await tester.pump(
      LearningNavigationBarState.inactivityDelay +
          const Duration(milliseconds: 100),
    );
    await tester.pumpAndSettle();
    final collapsedBottom = tester
        .getRect(find.byTooltip('Tampilkan kontrol belajar'))
        .bottom;

    expect(expandedBottom, moreOrLessEquals(collapsedBottom, epsilon: 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('every stage reserves content clearance above the floating bar', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    SingleChildScrollView scrollFor(String marker) =>
        tester.widget<SingleChildScrollView>(stageScroll(marker));

    double reservedFor(String marker) =>
        scrollFor(marker).padding!.resolve(TextDirection.ltr).bottom;

    expect(reservedFor('PELAJARI'), LearningNavigationBar.reservedContentSpace);

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();
    expect(reservedFor('Level 13'), LearningNavigationBar.reservedContentSpace);

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();
    expect(
      reservedFor('Perbaiki kode berikut'),
      LearningNavigationBar.reservedContentSpace,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'control bar stays anchored through top, middle and bottom scroll',
    (tester) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
      await tester.pump();
      await _advanceToLatihan(tester);
      expect(find.text('Perbaiki kode berikut'), findsOneWidget);

      final top = barRect(tester);

      await tester.drag(
        stageScroll('Perbaiki kode berikut'),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();
      final middle = barRect(tester);

      await tester.drag(
        stageScroll('Perbaiki kode berikut'),
        const Offset(0, -3000),
      );
      await tester.pumpAndSettle();
      final bottom = barRect(tester);

      expectSameRect(middle, top);
      expectSameRect(bottom, top);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('microphone toggles between active and muted states', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    expect(find.byTooltip('Microphone nonaktif'), findsOneWidget);
    expect(find.byIcon(Icons.mic_off_rounded), findsOneWidget);

    await tester.tap(find.byTooltip('Microphone nonaktif'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Microphone aktif'), findsOneWidget);
    expect(find.byIcon(Icons.mic_rounded), findsOneWidget);

    await tester.tap(find.byTooltip('Microphone aktif'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Microphone nonaktif'), findsOneWidget);
    expect(find.byIcon(Icons.mic_off_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('camera control is absent from the session bar', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    expect(find.byIcon(Icons.videocam_rounded), findsNothing);
    expect(find.byIcon(Icons.videocam_off_rounded), findsNothing);
    expect(find.byTooltip('Kamera nonaktif'), findsNothing);
    expect(find.byTooltip('Kamera aktif'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('end control confirms and keeps the progress preserved', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    await _advanceToLatihan(tester);

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Pelajaran 14 dari 20'), findsNothing);
    expect(find.text('Error Handling'), findsWidgets);

    await tester.tap(find.byTooltip('Akhiri sesi belajar'));
    await tester.pumpAndSettle();

    expect(find.text('Keluar dari Sesi?'), findsOneWidget);

    await tester.tap(find.widgetWithText(AppButton, 'Keluar'));
    await tester.pumpAndSettle();

    final lessons = LearningProgressController.instance.lessonStates(
      'dasar-python',
    );
    expect(
      lessons.firstWhere((lesson) => lesson.id == 'lesson-13').state,
      CourseLessonState.completed,
    );

    await tester.pump(const Duration(milliseconds: 4500));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('does not render text-based navigation controls', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    expect(find.text('Selanjutnya'), findsNothing);
    expect(find.text('Kontrol Belajar'), findsNothing);
    expect(find.text('Tandai Selesai'), findsNothing);
    expect(find.text('Selesaikan Course'), findsNothing);
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsNothing);
    expect(find.byIcon(Icons.call_end_rounded), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to narrow phones without overflow', (tester) async {
    _setSurface(tester, const Size(320, 640));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    expect(find.byType(LearningNavigationBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to tablets without overflow', (tester) async {
    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    expect(find.byType(LearningNavigationBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('large text scale keeps the stage flow usable', (tester) async {
    _setSurface(tester, const Size(390, 844));
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(_buildApp('dasar-python', 'lesson-13'));
    await tester.pump();

    expect(find.byType(LearningNavigationBar), findsOneWidget);
    expect(find.text('PELAJARI'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();

    expect(find.text('Level 13'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Pelajaran berikutnya'));
    await tester.pumpAndSettle();

    expect(find.text('Perbaiki kode berikut'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
