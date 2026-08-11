import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/explore/explore.dart';
import 'package:frontend/features/home/home.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _homeHost() {
  return MaterialApp(
    theme: AppTheme.light(),
    home: const Scaffold(body: HomePage()),
  );
}

Widget _exploreHost() {
  return MaterialApp(
    theme: AppTheme.light(),
    home: const Scaffold(body: ExplorePage()),
  );
}

void main() {
  testWidgets('Home exposes a pull-to-refresh indicator', (tester) async {
    await tester.pumpWidget(_homeHost());
    await tester.pump();

    expect(find.byType(RefreshIndicator), findsOneWidget);
  });

  testWidgets('pulling Home triggers a refresh without exceptions', (
    tester,
  ) async {
    await tester.pumpWidget(_homeHost());
    await tester.pump();

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

    expect(find.text('Progres Saya'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Explore exposes a pull-to-refresh indicator', (tester) async {
    await tester.pumpWidget(_exploreHost());
    await tester.pump();

    expect(find.byType(RefreshIndicator), findsOneWidget);
  });

  testWidgets('pulling Explore triggers a refresh without exceptions', (
    tester,
  ) async {
    await tester.pumpWidget(_exploreHost());
    await tester.pump();

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 300));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Jelajahi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
