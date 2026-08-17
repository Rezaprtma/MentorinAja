import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/app/main_shell.dart';
import 'package:frontend/features/course/course.dart';
import 'package:frontend/features/explore/explore.dart';
import 'package:frontend/features/home/home.dart';
import 'package:frontend/features/lesson/lesson.dart';
import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/features/progress/progress.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _buildApp() {
  return MaterialApp(theme: AppTheme.light(), home: const MainShell());
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Resolves the lesson and course routes so Progress resume can be asserted.
Widget _buildAppWithRoutes() {
  return MaterialApp(
    theme: AppTheme.light(),
    onGenerateRoute: (settings) {
      final name = settings.name ?? '';
      final parts = name.split('/');
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          if (name.contains('/lesson/')) {
            return CoursePlayerPage(
              courseId: parts.length > 2 ? parts[2] : '',
              lessonId: parts.length > 4 ? parts[4] : '',
            );
          }
          if (name.startsWith('/course/')) {
            return CourseDetailPage(courseId: parts.last);
          }
          return const Scaffold(body: SizedBox.shrink());
        },
      );
    },
    home: const MainShell(),
  );
}

void main() {
  testWidgets('renders the Home tab by default with key sections', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp());

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Selamat siang'), findsOneWidget);
    expect(find.textContaining('Rina, siap lanjut belajar?'), findsOneWidget);
    expect(find.text('Tingkatkan Kemampuanmu'), findsOneWidget);
    expect(find.text('Mulai Sekarang'), findsOneWidget);
    expect(find.text('Progres Saya'), findsOneWidget);
    expect(find.text('Pelajaran 12 dari 20 • Fungsi'), findsOneWidget);
    expect(find.text('Untuk Kamu'), findsOneWidget);

    expect(find.byType(AppFloatingBottomNav), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('switching tabs renders the matching page', (tester) async {
    await tester.pumpWidget(_buildApp());

    await tester.tap(find.text('Explore'));
    await tester.pump();
    expect(find.byType(ExplorePage), findsOneWidget);
    expect(find.text('Jelajahi'), findsOneWidget);

    await tester.tap(find.text('Progress'));
    await tester.pump();
    expect(find.byType(ProgressPage), findsOneWidget);
    expect(find.text('Progres Belajar'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pump();
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  testWidgets('keeps tab state alive across switches via IndexedStack', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp());

    await tester.tap(find.text('Profile'));
    await tester.pump();
    await tester.tap(find.text('Home'));
    await tester.pump();

    expect(find.text('Progres Saya'), findsOneWidget);
  });

  testWidgets('floating nav reports the tapped destination index', (
    tester,
  ) async {
    var tapped = -1;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          bottomNavigationBar: AppFloatingBottomNav(
            currentIndex: 0,
            onDestinationSelected: (index) => tapped = index,
            destinations: const [
              AppNavDestination(icon: Icons.home_outlined, label: 'Home'),
              AppNavDestination(icon: Icons.search, label: 'Explore'),
              AppNavDestination(
                icon: Icons.bar_chart_outlined,
                label: 'Progress',
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Progress'));
    await tester.pump();

    expect(tapped, 2);
  });

  testWidgets('content scrolls and the floating nav stays visible', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp());

    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -600),
    );
    await tester.pump();

    expect(find.text('Untuk Kamu'), findsOneWidget);
    expect(find.byType(AppFloatingBottomNav), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('Progress resume opens the current lesson directly', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildAppWithRoutes());

    await tester.tap(find.text('Progress'));
    await tester.pump();

    await tester.scrollUntilVisible(
      find.text('Lanjutkan').first,
      200,
      scrollable: find
          .descendant(
            of: find.byType(ProgressPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.text('Lanjutkan').first);
    await tester.pumpAndSettle();

    expect(find.byType(CoursePlayerPage), findsOneWidget);
    expect(find.byType(CourseDetailPage), findsNothing);
    expect(find.text('Dasar Python'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
