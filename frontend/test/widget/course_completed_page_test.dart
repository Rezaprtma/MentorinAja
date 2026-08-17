import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/features/lesson/lesson.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _buildApp(String courseId) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: CourseCompletedPage(courseId: courseId),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUp(() {
    LearningProgressController.instance.resetAll();
  });

  testWidgets('shows the completion summary and course identity', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('laravel-untuk-pemula'));
    await tester.pump();

    expect(find.text('Selamat, Course Selesai!'), findsOneWidget);
    expect(find.text('Laravel untuk Pemula'), findsOneWidget);
    expect(find.text('15 pelajaran'), findsOneWidget);
    expect(find.text('Lihat Course'), findsOneWidget);
    expect(find.text('Kembali ke Home'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown course id shows an empty state', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('tidak-ada'));
    await tester.pump();

    expect(find.text('Course Tidak Ditemukan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to narrow phones without overflow', (tester) async {
    _setSurface(tester, const Size(320, 640));
    await tester.pumpWidget(_buildApp('laravel-untuk-pemula'));
    await tester.pump();

    expect(find.text('Selamat, Course Selesai!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to tablets without overflow', (tester) async {
    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(_buildApp('laravel-untuk-pemula'));
    await tester.pump();

    expect(find.text('Selamat, Course Selesai!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
