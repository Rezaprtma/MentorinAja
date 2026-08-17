import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/shared/design_system/design_system.dart';

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('renders the FAQ accordion', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const HelpCenterPage()),
    );
    await tester.pump();

    expect(find.text('Pusat Bantuan'), findsOneWidget);
    expect(find.byType(AppSearchField), findsOneWidget);
    expect(find.text('Bagaimana cara mulai belajar?'), findsOneWidget);
    expect(find.text('Bagaimana cara menghubungi mentor?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('expanding a question reveals its answer', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const HelpCenterPage()),
    );
    await tester.pump();

    await tester.tap(find.text('Bagaimana cara mulai belajar?'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Mulai Course'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('search filters the FAQ list by question or answer', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const HelpCenterPage()),
    );
    await tester.pump();

    await tester.enterText(find.byType(AppSearchField), 'mentor');
    await tester.pump();

    expect(find.text('Bagaimana cara menghubungi mentor?'), findsOneWidget);
    expect(find.text('Bagaimana cara mulai belajar?'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a search without matches shows the no-results state', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const HelpCenterPage()),
    );
    await tester.pump();

    await tester.enterText(find.byType(AppSearchField), 'xyz');
    await tester.pump();

    expect(find.text('Tidak Ditemukan'), findsOneWidget);
    expect(find.text('Bagaimana cara mulai belajar?'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'adapts to narrow phones, tablets and large text without overflow',
    (tester) async {
      _setSurface(tester, const Size(320, 640));
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light(), home: const HelpCenterPage()),
      );
      await tester.pump();
      expect(find.text('Bagaimana cara mulai belajar?'), findsOneWidget);
      expect(tester.takeException(), isNull);

      _setSurface(tester, const Size(1024, 1366));
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light(), home: const HelpCenterPage()),
      );
      await tester.pump();
      expect(find.text('Bagaimana cara mulai belajar?'), findsOneWidget);
      expect(tester.takeException(), isNull);

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
          home: const HelpCenterPage(),
        ),
      );
      await tester.pump();
      expect(find.text('Bagaimana cara mulai belajar?'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
