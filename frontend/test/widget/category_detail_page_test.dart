import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/features/explore/explore.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _buildApp(String category) {
  return MaterialApp(
    theme: AppTheme.light(),
    onGenerateRoute: (settings) {
      final name = settings.name ?? '';
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => name.startsWith('/course/')
            ? const CourseDetailPage(courseId: 'flutter-untuk-pemula')
            : const SizedBox.shrink(),
      );
    },
    home: CategoryDetailPage(categoryName: category),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('renders the hero, course count and category courses', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('Mobile App'));
    await tester.pump();

    expect(find.text('Kategori'), findsOneWidget);
    expect(find.text('Mobile App'), findsWidgets);
    expect(
      find.text('Bangun aplikasi mobile untuk Android dan iOS.'),
      findsOneWidget,
    );
    expect(find.text('3 course tersedia'), findsOneWidget);

    expect(find.text('Flutter untuk Pemula'), findsOneWidget);
    expect(find.text('Android dengan Kotlin'), findsOneWidget);
    expect(find.text('iOS dengan Swift'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping a course card opens the course detail page', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('Mobile App'));
    await tester.pump();

    await tester.tap(find.text('Flutter untuk Pemula'));
    await tester.pumpAndSettle();

    expect(find.byType(CourseDetailPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown category shows an empty state', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp('Tidak Ada'));
    await tester.pump();

    expect(find.text('Kategori Tidak Ditemukan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to narrow phones and tablets without overflow', (
    tester,
  ) async {
    _setSurface(tester, const Size(320, 640));
    await tester.pumpWidget(_buildApp('Mobile App'));
    await tester.pump();
    expect(find.text('Flutter untuk Pemula'), findsOneWidget);
    expect(tester.takeException(), isNull);

    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(_buildApp('Mobile App'));
    await tester.pump();
    expect(find.text('Flutter untuk Pemula'), findsOneWidget);
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
        home: const CategoryDetailPage(categoryName: 'Mobile App'),
      ),
    );
    await tester.pump();

    expect(find.text('Mobile App'), findsWidgets);
    expect(find.text('Flutter untuk Pemula'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
