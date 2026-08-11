import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/app/main_shell.dart';
import 'package:frontend/features/explore/explore.dart';
import 'package:frontend/features/home/home.dart';
import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/features/progress/progress.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _buildApp() {
  return MaterialApp(theme: AppTheme.light(), home: const MainShell());
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
    expect(find.text('Track your progress'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pump();
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Your profile'), findsOneWidget);
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
}
