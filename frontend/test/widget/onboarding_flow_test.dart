import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/features/onboarding/onboarding.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

Widget _buildApp() {
  return MaterialApp(
    theme: AppTheme.light(),
    routes: {
      AppRoutes.authentication: (_) =>
          const Scaffold(body: Center(child: Text('Auth'))),
    },
    home: const OnboardingScreen(),
  );
}

/// Mimics a phone viewport so the onboarding pages fit without scrolling.
void _usePhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

/// Pumps enough frames to complete a 350ms page transition.
Future<void> _pumpTransition(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Reads the brand logo asset the currently built page renders.
String _logoAsset(WidgetTester tester) {
  final svgs = tester.widgetList<AppSvg>(
    find.descendant(
      of: find.byType(OnboardingPage),
      matching: find.byType(AppSvg),
    ),
  );
  return svgs
      .firstWhere(
        (svg) =>
            svg.assetPath == AppLogo.onLight ||
            svg.assetPath == AppLogo.onBrand,
      )
      .assetPath;
}

/// Reads the page background color from its root [Container].
Color _pageBackground(WidgetTester tester) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(OnboardingPage),
          matching: find.byType(Container),
        )
        .first,
  );
  return (container.decoration! as BoxDecoration).color!;
}

const _nextIcon = Icons.arrow_forward_ios;

void main() {
  testWidgets(
    'first chapter shows the indigo page, pale logo and compact Next',
    (tester) async {
      _usePhoneViewport(tester);
      await tester.pumpWidget(_buildApp());

      expect(find.text('Belajar Tanpa Batas.'), findsOneWidget);
      expect(_pageBackground(tester), const Color(0xFF514AF8));
      expect(_logoAsset(tester), AppLogo.onBrand);
      expect(find.text('Skip'), findsOneWidget);
      expect(find.byIcon(_nextIcon), findsOneWidget);
      expect(find.text('Mulai Belajar'), findsNothing);
    },
  );

  testWidgets('second chapter swaps to the white background and orange logo', (
    tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(_buildApp());

    await tester.tap(find.byIcon(_nextIcon));
    await _pumpTransition(tester);

    expect(find.text('Belajar yang Menyesuaikan Dirimu.'), findsOneWidget);
    expect(_pageBackground(tester), const Color(0xFFFFFFFF));
    expect(_logoAsset(tester), AppLogo.onLight);
    expect(find.byIcon(_nextIcon), findsOneWidget);
    expect(find.text('Mulai Belajar'), findsNothing);
  });

  testWidgets(
    'third chapter replaces the compact circle with a wide primary CTA',
    (tester) async {
      _usePhoneViewport(tester);
      await tester.pumpWidget(_buildApp());

      await tester.tap(find.byIcon(_nextIcon));
      await _pumpTransition(tester);
      await tester.tap(find.byIcon(_nextIcon));
      await _pumpTransition(tester);

      expect(find.text('Mulai Hari Ini.'), findsOneWidget);
      expect(_pageBackground(tester), const Color(0xFFF97316));
      expect(_logoAsset(tester), AppLogo.onBrand);
      expect(find.byIcon(_nextIcon), findsNothing);
      expect(find.text('Skip'), findsNothing);
      expect(find.text('Mulai Belajar'), findsOneWidget);
    },
  );

  testWidgets('completing the flow routes into authentication', (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(_buildApp());

    await tester.tap(find.byIcon(_nextIcon));
    await _pumpTransition(tester);
    await tester.tap(find.byIcon(_nextIcon));
    await _pumpTransition(tester);

    await tester.tap(find.text('Mulai Belajar'));
    await _pumpTransition(tester);

    expect(find.text('Auth'), findsOneWidget);
  });
}
