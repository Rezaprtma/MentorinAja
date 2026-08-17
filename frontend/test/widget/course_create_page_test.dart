import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/course_authoring/course_authoring.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _app({CourseAuthoringRepository? repository}) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: CourseCreatePage(repository: repository),
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
  testWidgets('renders the creation form fields and disabled CTA', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app(repository: _EmptyRepository()));
    await tester.pump();

    expect(find.widgetWithText(AppAppBar, 'Buat Course'), findsOneWidget);
    expect(find.text('Nama Course'), findsOneWidget);
    expect(find.text('Deskripsi'), findsOneWidget);
    expect(find.text('Kategori'), findsOneWidget);
    expect(find.text('Bahasa Pemrograman'), findsOneWidget);
    expect(find.text('Level'), findsOneWidget);

    final button = tester.widget<AppButton>(
      find.widgetWithText(AppButton, 'Buat Course'),
    );
    expect(button.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('requires all fields before creating', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app(repository: _EmptyRepository()));
    await tester.pump();

    await tester.enterText(
      find.widgetWithText(AppTextField, 'Nama Course'),
      'Dasar Go',
    );
    await tester.pump();

    final button = tester.widget<AppButton>(
      find.widgetWithText(AppButton, 'Buat Course'),
    );
    expect(button.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('creates a draft and notifies when all fields are filled', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    final repo = _EmptyRepository();
    CourseAuthoringDraft? created;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: CourseCreatePage(
          repository: repo,
          onCreated: (draft) => created = draft,
        ),
      ),
    );
    await tester.pump();

    await tester.enterText(
      find.widgetWithText(AppTextField, 'Nama Course'),
      'Dasar Dart',
    );
    await tester.enterText(
      find.widgetWithText(AppTextField, 'Deskripsi'),
      'Pelajari bahasa Dart dari nol.',
    );
    await tester.pump();

    await tester.ensureVisible(find.byType(AppDropdownField<String>).at(0));
    await tester.tap(find.byType(AppDropdownField<String>).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pemrograman').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(AppDropdownField<String>).at(1));
    await tester.tap(find.byType(AppDropdownField<String>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dart').first);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(AppDropdownField<String>).at(2));
    await tester.tap(find.byType(AppDropdownField<String>).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pemula').last);
    await tester.pumpAndSettle();

    final button = tester.widget<AppButton>(
      find.widgetWithText(AppButton, 'Buat Course'),
    );
    expect(button.onPressed, isNotNull);

    await tester.ensureVisible(find.widgetWithText(AppButton, 'Buat Course'));
    await tester.tap(find.widgetWithText(AppButton, 'Buat Course'));
    await tester.pumpAndSettle();

    expect(created, isNotNull);
    expect(created!.title, 'Dasar Dart');
    expect(created!.description, 'Pelajari bahasa Dart dari nol.');
    expect(created!.category, 'Pemrograman');
    expect(created!.language, 'Dart');
    expect(created!.level, 'Pemula');
    expect(repo.allDrafts(), hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to narrow phones without overflow', (tester) async {
    _setSurface(tester, const Size(320, 640));
    await tester.pumpWidget(_app(repository: _EmptyRepository()));
    await tester.pump();

    expect(find.text('Informasi Course'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
