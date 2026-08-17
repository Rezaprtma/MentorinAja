import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/features/explore/explore.dart';
import 'package:frontend/features/notifications/notifications.dart';
import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/shared/design_system/design_system.dart';

/// Mirrors the preview entrypoints in `lib/main_*_preview.dart` so each new
/// screen is validated headlessly at phone and tablet widths.
void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _app(Widget home) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light(),
    home: home,
  );
}

void main() {
  testWidgets('course detail preview renders without overflow', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _app(const CourseDetailPage(courseId: 'dasar-python')),
    );
    await tester.pump();

    expect(find.text('Dasar Python'), findsOneWidget);
    expect(find.text('Lanjutkan Course'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('notifications preview renders without overflow', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app(const NotificationPage()));
    await tester.pump();

    expect(find.text('Hari Ini'), findsOneWidget);
    expect(find.text('Course Python Dasar diperbarui'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('category preview renders without overflow', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _app(const CategoryDetailPage(categoryName: 'Mobile App')),
    );
    await tester.pump();

    expect(find.text('3 course tersedia'), findsOneWidget);
    expect(find.text('Flutter untuk Pemula'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('category preview adapts to tablet width', (tester) async {
    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(
      _app(const CategoryDetailPage(categoryName: 'Database')),
    );
    await tester.pump();

    expect(find.text('2 course tersedia'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('feedback preview renders without overflow', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app(const FeedbackPage()));
    await tester.pump();

    expect(find.text('Kirim Masukan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('help center preview renders without overflow', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app(const HelpCenterPage()));
    await tester.pump();

    expect(find.text('Bagaimana cara mulai belajar?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
