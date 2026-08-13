import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/progress/progress.dart';
import 'package:frontend/shared/design_system/design_system.dart';

const _ringKey = Key('progress-donut-ring');

Widget _buildApp({TextScaler textScaler = TextScaler.noScaling}) {
  return MaterialApp(
    theme: AppTheme.light(),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: const ProgressPage(),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _selectCategory(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(
      of: find.byType(ProgressCategorySwitch),
      matching: find.text(label),
    ),
  );
  await tester.pump();
}

Future<Rect> _ringRect(WidgetTester tester) async {
  return tester.getRect(find.byKey(_ringKey));
}

Future<void> _tapRingAt(WidgetTester tester, Offset unitDirection) async {
  final rect = await _ringRect(tester);
  await tester.tapAt(rect.center + unitDirection * (rect.width / 2));
  await tester.pump();
}

void main() {
  testWidgets('renders the progress structure by default', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.text('Progres Belajar'), findsOneWidget);
    expect(find.text('Lihat perkembangan belajarmu.'), findsOneWidget);

    expect(find.byType(ProgressStatsPanel), findsOneWidget);
    expect(find.text('Ringkasan Belajar'), findsOneWidget);
    expect(find.text('Total Course'), findsNWidgets(2));
    expect(find.text('4'), findsNWidgets(2));
    expect(find.text('Sedang Dipelajari'), findsNWidgets(2));
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Selesai'), findsNWidgets(2));
    expect(find.text('1'), findsOneWidget);

    expect(find.byType(ProgressCategorySwitch), findsOneWidget);
    expect(find.byType(FilteredCourseList), findsOneWidget);
    expect(find.byType(ActiveCourseCard), findsNWidgets(3));
    expect(find.byType(CompletedCourseCard), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('the completed courses are not built while studying is active', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.text('Laravel untuk Pemula'), findsNothing);
    expect(find.text('Sudah Selesai'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('statistics derive from the mock catalog', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    final total =
        MockProgressData.activeCourses.length +
        MockProgressData.completedCourses.length;
    final completed = MockProgressData.completedCourses
        .where((course) => course.progress >= 1.0)
        .length;
    final active = MockProgressData.activeCourses
        .where((course) => course.progress > 0 && course.progress < 1.0)
        .length;

    expect(total, 4);
    expect(active, 3);
    expect(completed, 1);
    expect((completed / total * 100).round(), 25);
    expect((active / total * 100).round(), 75);
  });

  testWidgets(
    'chart center shows the total by default with no permanent legend',
    (tester) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CourseDistributionChart), findsOneWidget);
      expect(find.text('Total Course'), findsNWidgets(2));
      expect(find.text('75%'), findsNothing);
      expect(find.text('25%'), findsNothing);
      expect(find.text('4'), findsNWidgets(2));

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('chart center swaps to the studied slice on tap', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await _tapRingAt(tester, const Offset(0.8, 0.0));
    expect(find.text('3'), findsNWidgets(2));
    expect(find.text('75%'), findsOneWidget);

    await _tapRingAt(tester, const Offset(-0.7, -0.4));
    expect(find.text('1'), findsNWidgets(2));
    expect(find.text('25%'), findsOneWidget);
    expect(find.text('Selesai'), findsNWidgets(3));

    await tester.tapAt((await _ringRect(tester)).center);
    await tester.pump();
    expect(find.text('Total Course'), findsNWidgets(2));
    expect(find.text('4'), findsNWidgets(2));

    expect(tester.takeException(), isNull);
  });

  testWidgets('active course cards show percentage and lesson detail', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.text('72%'), findsOneWidget);
    expect(find.text('45%'), findsOneWidget);
    expect(find.text('28%'), findsOneWidget);
    expect(find.text('Pelajaran 12 dari 20 • Fungsi'), findsOneWidget);
    expect(find.text('Function Parameters'), findsOneWidget);
    expect(find.text('Lanjutkan'), findsNWidgets(3));

    expect(tester.takeException(), isNull);
  });

  testWidgets('default category is studying and only those cards render', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(
      find.descendant(
        of: find.byType(ProgressCategorySwitch),
        matching: find.text('Sedang Dipelajari'),
      ),
      findsOneWidget,
    );
    expect(find.text('Dasar Python'), findsOneWidget);
    expect(find.text('JavaScript Modern'), findsOneWidget);
    expect(find.text('MySQL Dasar'), findsOneWidget);
    expect(find.byType(ActiveCourseCard), findsNWidgets(3));
    expect(find.byType(CompletedCourseCard), findsNothing);
  });

  testWidgets('selecting Selesai renders only completed courses', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await _selectCategory(tester, 'Selesai');

    expect(find.byType(CompletedCourseCard), findsOneWidget);
    expect(find.text('Laravel untuk Pemula'), findsOneWidget);
    expect(find.text('15 dari 15 pelajaran'), findsOneWidget);
    expect(find.text('Selesai'), findsNWidgets(3));

    expect(find.byType(ActiveCourseCard), findsNothing);
    expect(find.text('Dasar Python'), findsNothing);
    expect(find.text('72%'), findsNothing);
    expect(find.text('Lanjutkan'), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('switching back displays the studying courses again', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await _selectCategory(tester, 'Selesai');
    expect(find.byType(CompletedCourseCard), findsOneWidget);

    await _selectCategory(tester, 'Sedang Dipelajari');
    expect(find.byType(ActiveCourseCard), findsNWidgets(3));
    expect(find.byType(CompletedCourseCard), findsNothing);
    expect(find.text('Dasar Python'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('stats panel shows zeros and an empty chart when no courses', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: ProgressStatsPanel(
            totalCount: 0,
            activeCount: 0,
            completedCount: 0,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('0'), findsNWidgets(4));
    expect(find.text('0%'), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('studying empty state offers an explore CTA', (tester) async {
    _setSurface(tester, const Size(390, 844));
    var explored = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: ProgressEmptyState(onExplore: () => explored = true),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ProgressEmptyState), findsOneWidget);
    expect(find.text('Belum Ada Course'), findsOneWidget);
    expect(
      find.text('Mulai belajar dengan memilih course dari Explore.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Jelajahi Course'));
    expect(explored, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('completed empty state is a quiet note without a CTA', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: ProgressEmptyState(category: ProgressCategory.completed),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Belum Ada Course Selesai'), findsOneWidget);
    expect(
      find.text('Course yang kamu selesaikan akan muncul di sini.'),
      findsOneWidget,
    );
    expect(find.text('Jelajahi Course'), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('filtered list builds only the selected collection', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: FilteredCourseList(
            category: ProgressCategory.completed,
            activeCourses: MockProgressData.activeCourses,
            completedCourses: MockProgressData.completedCourses,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CompletedCourseCard), findsOneWidget);
    expect(find.byType(ActiveCourseCard), findsNothing);
  });

  testWidgets('exposes pull-to-refresh without exceptions', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.byType(RefreshIndicator), findsOneWidget);

    await tester.drag(
      find
          .descendant(
            of: find.byType(RefreshIndicator),
            matching: find.byType(SingleChildScrollView),
          )
          .first,
      const Offset(0, 300),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Progres Belajar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports large text scale without overflow', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _buildApp(textScaler: const TextScaler.linear(2.0)),
    );
    await tester.pump();

    expect(find.byType(ProgressStatsPanel), findsOneWidget);
    expect(find.byType(ProgressCategorySwitch), findsOneWidget);
    expect(find.byType(ActiveCourseCard), findsNWidgets(3));
    expect(find.byType(CompletedCourseCard), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to narrow phones without overflow', (tester) async {
    _setSurface(tester, const Size(320, 640));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.byType(ProgressStatsPanel), findsOneWidget);
    expect(find.byType(ActiveCourseCard), findsNWidgets(3));
    expect(find.byType(CompletedCourseCard), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to tablets without overflow', (tester) async {
    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.byType(ProgressStatsPanel), findsOneWidget);
    expect(find.byType(ActiveCourseCard), findsNWidgets(3));
    expect(find.byType(CompletedCourseCard), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping a course invokes the provided callback', (tester) async {
    _setSurface(tester, const Size(390, 844));
    MockProgressCourse? tapped;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: ProgressPage(onCourseTap: (course) => tapped = course),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Dasar Python'));
    expect(tapped?.title, 'Dasar Python');
    expect(tester.takeException(), isNull);
  });
}
