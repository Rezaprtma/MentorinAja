import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/course_authoring/course_authoring.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _app({CourseAuthoringRepository? repository}) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: CourseListPage(repository: repository),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

class _EmptyRepository implements CourseAuthoringRepository {
  final List<CourseAuthoringDraft> _drafts = [];

  @override
  List<CourseAuthoringDraft> allDrafts() => List.unmodifiable(_drafts);

  @override
  CourseAuthoringDraft? findDraft(String id) {
    for (final d in _drafts) {
      if (d.id == id) return d;
    }
    return null;
  }

  @override
  CourseAuthoringDraft createDraft(CourseAuthoringDraft draft) {
    _drafts.add(draft);
    return draft;
  }

  @override
  CourseAuthoringDraft updateDraft(CourseAuthoringDraft draft) {
    final index = _drafts.indexWhere((d) => d.id == draft.id);
    if (index == -1) throw StateError('Draft tidak ditemukan');
    _drafts[index] = draft;
    return draft;
  }

  @override
  void deleteDraft(String id) {
    _drafts.removeWhere((d) => d.id == id);
  }

  @override
  CourseAuthoringDraft addLesson(String courseId, LessonDraft lesson) {
    throw UnimplementedError();
  }

  @override
  CourseAuthoringDraft deleteLesson(String courseId, String lessonId) {
    throw UnimplementedError();
  }

  @override
  CourseAuthoringDraft reorderLessons(String courseId, List<String> lessonIds) {
    throw UnimplementedError();
  }

  @override
  CourseAuthoringDraft publishCourse(String id) {
    throw UnimplementedError();
  }

  @override
  CourseAuthoringDraft unpublishCourse(String id) {
    throw UnimplementedError();
  }

  @override
  CourseAuthoringDraft updateLesson(String courseId, LessonDraft lesson) {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('renders the draft courses with title, count and status', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('Kelola Course'), findsOneWidget);
    expect(find.text('Course Kamu'), findsOneWidget);
    expect(find.text('Dasar Python'), findsOneWidget);
    expect(find.text('2 Pelajaran'), findsOneWidget);
    expect(find.text('Draft'), findsOneWidget);
    expect(find.text('Buat Course'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows an empty state when no drafts exist', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app(repository: _EmptyRepository()));
    await tester.pump();

    expect(find.text('Belum Ada Course'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping a draft card opens the course editor', (tester) async {
    _setSurface(tester, const Size(390, 844));
    String? openedId;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: CourseListPage(onOpenCourse: (id) => openedId = id),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Dasar Python'));
    await tester.pump();

    expect(openedId, 'draft-python-dasar');
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a published badge when the draft is published', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    final repo = _EmptyRepository();
    repo.createDraft(
      CourseAuthoringDraft(
        id: 'draft-1',
        title: 'Flutter Dasar',
        description: 'Belajar Flutter dari nol.',
        category: 'Mobile',
        language: 'Dart',
        level: 'Pemula',
        targetAudience: 'Pelajar',
        status: DraftStatus.published,
        updatedAt: DateTime(2026, 8, 1),
      ),
    );
    await tester.pumpWidget(_app(repository: repo));
    await tester.pump();

    expect(find.text('Flutter Dasar'), findsOneWidget);
    expect(find.text('Published'), findsOneWidget);
    expect(find.text('0 Pelajaran'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to tablets without overflow', (tester) async {
    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('Dasar Python'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
