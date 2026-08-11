import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/explore/explore.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _buildApp({TextScaler textScaler = TextScaler.noScaling}) {
  return MaterialApp(
    theme: AppTheme.light(),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: const ExplorePage(),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('renders the discovery structure by default', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.text('Jelajahi'), findsOneWidget);
    expect(find.byType(AppSearchField), findsOneWidget);
    expect(find.text('Kursus Populer'), findsOneWidget);
    expect(find.text('Untuk Kamu'), findsOneWidget);

    expect(find.byType(CategoryDiscoveryCard), findsNWidgets(6));
    expect(find.text('Mobile App'), findsWidgets);
    expect(find.text('Website'), findsWidgets);
    expect(find.text('UI/UX'), findsWidgets);
    expect(find.text('Backend'), findsWidgets);
    expect(find.text('Database'), findsWidgets);
    expect(find.text('DevOps'), findsWidgets);

    expect(
      find.text('Bangun aplikasi mobile untuk Android dan iOS.'),
      findsOneWidget,
    );
    expect(
      find.text('Bangun website modern dari frontend hingga backend.'),
      findsOneWidget,
    );

    final cards = tester.widgetList<CategoryDiscoveryCard>(
      find.byType(CategoryDiscoveryCard),
    );
    for (final card in cards) {
      final size = tester.getSize(find.byWidget(card));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('supports large text scale without overflow', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _buildApp(textScaler: const TextScaler.linear(2.0)),
    );
    await tester.pump();

    expect(find.byType(CategoryDiscoveryCard), findsNWidgets(6));
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to narrow phones without overflow', (tester) async {
    _setSurface(tester, const Size(320, 640));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.byType(CategoryDiscoveryCard), findsNWidgets(6));
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to tablets without overflow', (tester) async {
    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.byType(CategoryDiscoveryCard), findsNWidgets(6));
    expect(tester.takeException(), isNull);
  });

  testWidgets('search switches the catalog into course results', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.enterText(find.byType(AppSearchField), 'flutter');
    await tester.pump();

    expect(find.text('Hasil Pencarian'), findsOneWidget);
    expect(find.text('Flutter untuk Pemula'), findsOneWidget);
    expect(find.text('Untuk Kamu'), findsNothing);
    expect(find.text('Kursus Populer'), findsNothing);

    expect(tester.takeException(), isNull);
  });
}
