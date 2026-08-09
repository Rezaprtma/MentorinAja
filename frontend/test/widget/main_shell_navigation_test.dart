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
    expect(find.text('Good afternoon'), findsOneWidget);
    expect(
      find.textContaining('Rina, ready to continue learning?'),
      findsOneWidget,
    );
    expect(find.text('Your AI tutor'), findsOneWidget);
    expect(find.text('Continue learning'), findsOneWidget);
    expect(find.text('Continue lesson'), findsOneWidget);
    expect(find.text('Recommended for you'), findsOneWidget);

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
    expect(find.text('Explore courses'), findsOneWidget);

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

    expect(find.text('Continue learning'), findsOneWidget);
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

    expect(find.text('Product Thinking 101'), findsOneWidget);
    expect(find.text('Recommended for you'), findsOneWidget);
    expect(find.byType(AppFloatingBottomNav), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });
}
