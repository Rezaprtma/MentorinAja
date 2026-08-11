import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/home/home.dart';
import 'package:frontend/shared/design_system/design_system.dart';

void main() {
  Widget host() {
    return MaterialApp(
      theme: AppTheme.light(),
      home: const Scaffold(
        body: SingleChildScrollView(
          child: HeroBannerCarousel(banners: MockHomeData.homeBanners),
        ),
      ),
    );
  }

  testWidgets('every banner page renders without exceptions', (tester) async {
    await tester.pumpWidget(host());

    for (var i = 0; i < MockHomeData.homeBanners.length; i++) {
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('banners render single-column on a narrow viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(300, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    for (var i = 0; i < MockHomeData.homeBanners.length; i++) {
      await tester.drag(find.byType(PageView), const Offset(-200, 0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('recommended course rail renders all cards', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: RecommendedSection()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(RecommendedCourseCard), findsNWidgets(6));
    expect(find.text('Untuk Kamu'), findsOneWidget);
    expect(find.text('Dasar Python'), findsWidgets);
    expect(find.text('JavaScript Modern'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
