import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/course_authoring/course_authoring.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/enums/enums.dart';

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _app({CourseAuthoringRepository? repository}) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: LessonEditorPage(
      courseId: 'draft-python-dasar',
      lessonId: 'lesson-1-hello',
      repository: repository ?? MockCourseAuthoringRepository(),
    ),
  );
}

void main() {
  testWidgets('renders header fields, tabs and Materi blocks', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('Edit Pelajaran'), findsOneWidget);
    expect(find.text('Hello World'), findsWidgets);
    expect(find.text('Simpan Perubahan'), findsOneWidget);
    expect(find.text('Materi'), findsOneWidget);
    expect(find.text('Game'), findsOneWidget);
    expect(find.text('Latihan'), findsOneWidget);
    expect(find.text('Apa itu Python?'), findsOneWidget);
    expect(
      find.text(
        'Python adalah bahasa pemrograman yang mudah dipelajari and banyak digunakan di berbagai bidang.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Game tab lists seeded games with type labels', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(find.text('Game'));
    await tester.pumpAndSettle();

    expect(find.text('Susun Kode'), findsOneWidget);
    expect(find.text('Pilihan Ganda'), findsOneWidget);
    expect(find.text('Potongan Kode (satu per baris)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Latihan tab lists seeded exercises', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(find.text('Latihan'));
    await tester.pumpAndSettle();

    expect(find.text('Lengkapi Kode'), findsOneWidget);
    expect(
      find.text('Lengkapi kode agar mencetak "Selamat Datang".'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('adding a material block persists through the repository', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    final repo = MockCourseAuthoringRepository();
    await tester.pumpWidget(_app(repository: repo));
    await tester.pump();

    await tester.ensureVisible(find.text('Tambah Blok Materi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tambah Blok Materi'));
    await tester.pumpAndSettle();

    final lesson = repo
        .findDraft('draft-python-dasar')!
        .lessons
        .firstWhere((l) => l.id == 'lesson-1-hello');
    expect(lesson.materialBlocks.length, 4);
    expect(lesson.materialBlocks.last.type, LessonContentBlockType.paragraph);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adding a game persists through the repository', (tester) async {
    _setSurface(tester, const Size(390, 844));
    final repo = MockCourseAuthoringRepository();
    await tester.pumpWidget(_app(repository: repo));
    await tester.pump();

    await tester.tap(find.text('Game'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tambah Game'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tambah Game'));
    await tester.pumpAndSettle();

    final lesson = repo
        .findDraft('draft-python-dasar')!
        .lessons
        .firstWhere((l) => l.id == 'lesson-1-hello');
    expect(lesson.games.length, 3);
    expect(tester.takeException(), isNull);
  });

  testWidgets('editing the lesson title persists the change', (tester) async {
    _setSurface(tester, const Size(390, 844));
    final repo = MockCourseAuthoringRepository();
    await tester.pumpWidget(_app(repository: repo));
    await tester.pump();

    await tester.enterText(
      find.widgetWithText(AppTextField, 'Judul Pelajaran'),
      'Hello World Lanjutan',
    );
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();

    final lesson = repo
        .findDraft('draft-python-dasar')!
        .lessons
        .firstWhere((l) => l.id == 'lesson-1-hello');
    expect(lesson.title, 'Hello World Lanjutan');
    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown lesson id shows an empty state', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const LessonEditorPage(
          courseId: 'draft-python-dasar',
          lessonId: 'unknown',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Pelajaran Tidak Ditemukan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to tablets without overflow', (tester) async {
    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('Apa itu Python?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
