import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _buildApp(String courseId) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: CourseDetailPage(courseId: courseId),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('renders identity, description, outcomes and outline', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python'));
    await tester.pump();

    expect(find.text('Detail Course'), findsOneWidget);
    expect(find.text('Dasar Python'), findsOneWidget);
    expect(
      find.text('Pelajari sintaks dan konsep dasar Python.'),
      findsOneWidget,
    );
    expect(find.text('Tentang Course Ini'), findsOneWidget);
    expect(find.text('Yang Akan Kamu Pelajari'), findsOneWidget);
    expect(find.text('Materi Course'), findsOneWidget);
    expect(find.text('20 pelajaran'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Proyek: Analisis Data Dasar'),
      300,
    );
    expect(find.text('Proyek: Analisis Data Dasar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('enrolled course shows progress and a continue action', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python'));
    await tester.pump();

    expect(find.text('60%'), findsOneWidget);
    expect(find.text('Lanjutkan Course'), findsOneWidget);
    expect(find.text('Mulai Course'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('new course shows a start action without progress', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('flutter-untuk-pemula'));
    await tester.pump();

    expect(find.text('Mulai Course'), findsOneWidget);
    expect(find.text('Lanjutkan Course'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saving the course surfaces a success toast', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('dasar-python'));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.bookmark_border_rounded));
    await tester.pump();

    expect(find.text('Course Disimpan'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 4500));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown course id shows an empty state', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('tidak-ada'));
    await tester.pump();

    expect(find.text('Course Tidak Ditemukan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports large text scale without overflow', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2.0)),
          child: child!,
        ),
        home: const CourseDetailPage(courseId: 'dasar-python'),
      ),
    );
    await tester.pump();

    expect(find.text('Detail Course'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to narrow phones without overflow', (tester) async {
    _setSurface(tester, const Size(320, 640));
    await tester.pumpWidget(_buildApp('dasar-python'));
    await tester.pump();

    expect(find.text('Dasar Python'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to tablets without overflow', (tester) async {
    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(_buildApp('dasar-python'));
    await tester.pump();

    expect(find.text('Dasar Python'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
