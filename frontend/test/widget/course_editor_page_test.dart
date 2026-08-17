import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/course_authoring/course_authoring.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _app({CourseAuthoringRepository? repository}) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: CourseEditorPage(
      courseId: 'draft-python-dasar',
      repository: repository ?? MockCourseAuthoringRepository(),
    ),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('renders header fields, objectives and lesson list', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('Edit Course'), findsOneWidget);
    expect(find.text('Dasar Python'), findsWidgets);
    expect(find.text('Pemrograman'), findsOneWidget);
    expect(find.text('Simpan Perubahan'), findsOneWidget);
    expect(find.text('TUJUAN PEMBELAJARAN'), findsOneWidget);
    expect(find.text('Memahami sintaks dasar Python'), findsOneWidget);
    expect(find.text('PELAJARAN'), findsOneWidget);
    expect(find.text('Hello World'), findsOneWidget);
    expect(find.text('Variabel dan Tipe Data'), findsOneWidget);
    expect(find.text('Tambah Pelajaran'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adding an objective appends it to the draft', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.enterText(
      find.widgetWithText(AppTextField, 'Tujuan baru'),
      'Mampu membaca kode orang lain',
    );
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    expect(find.text('Mampu membaca kode orang lain'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('removing an objective updates the draft', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('Memahami sintaks dasar Python'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('Memahami sintaks dasar Python'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saving the header persists the changes', (tester) async {
    _setSurface(tester, const Size(390, 844));
    final repo = MockCourseAuthoringRepository();
    await tester.pumpWidget(_app(repository: repo));
    await tester.pump();

    await tester.enterText(
      find.widgetWithText(AppTextField, 'Nama Course'),
      'Dasar Python Tingkat Lanjut',
    );
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();

    expect(
      repo.findDraft('draft-python-dasar')?.title,
      'Dasar Python Tingkat Lanjut',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping a lesson opens the lesson editor', (tester) async {
    _setSurface(tester, const Size(390, 844));
    String? openedCourse;
    String? openedLesson;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: CourseEditorPage(
          courseId: 'draft-python-dasar',
          repository: MockCourseAuthoringRepository(),
          onOpenLesson: (courseId, lessonId) {
            openedCourse = courseId;
            openedLesson = lessonId;
          },
        ),
      ),
    );
    await tester.pump();

    await tester.ensureVisible(find.text('Hello World'));
    await tester.tap(find.text('Hello World'));
    await tester.pump();

    expect(openedCourse, 'draft-python-dasar');
    expect(openedLesson, 'lesson-1-hello');
    expect(tester.takeException(), isNull);
  });

  testWidgets('adding a lesson creates and opens it', (tester) async {
    _setSurface(tester, const Size(390, 844));
    String? openedLesson;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: CourseEditorPage(
          courseId: 'draft-python-dasar',
          repository: MockCourseAuthoringRepository(),
          onOpenLesson: (courseId, lessonId) => openedLesson = lessonId,
        ),
      ),
    );
    await tester.pump();

    await tester.ensureVisible(find.text('Tambah Pelajaran'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tambah Pelajaran'));
    await tester.pumpAndSettle();

    expect(openedLesson, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown course id shows an empty state', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const CourseEditorPage(courseId: 'unknown'),
      ),
    );
    await tester.pump();

    expect(find.text('Course Tidak Ditemukan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to tablets without overflow', (tester) async {
    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('Hello World'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
