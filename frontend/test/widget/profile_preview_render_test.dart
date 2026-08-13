import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/shared/design_system/design_system.dart';

/// Mirrors the widget tree built by `lib/main_profile_preview.dart` so the
/// preview entrypoint is validated in a headless render — same themes, same
/// [ThemeModeController] reactivity, same ProfilePage root.
Widget _previewApp() {
  return ListenableBuilder(
    listenable: ThemeModeController.instance,
    builder: (context, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeModeController.instance.mode,
      home: const ProfilePage(),
    ),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUp(() {
    ThemeModeController.instance.setMode(ThemeMode.system);
  });

  testWidgets('preview entrypoint renders Profile without overflow', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_previewApp());
    await tester.pump();

    expect(find.text('Profil'), findsOneWidget);
    expect(find.byType(ProfileIdentity), findsOneWidget);
    expect(find.text('Edit Profil'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Keluar'), 160);
    expect(find.text('Keluar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('preview entrypoint renders the Legal section', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_previewApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Kebijakan Pengguna'), 160);
    expect(find.text('LEGAL'), findsOneWidget);
    expect(find.text('Kebijakan Privasi'), findsOneWidget);
    expect(find.text('Kebijakan Pengguna'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('preview entrypoint renders in dark mode', (tester) async {
    _setSurface(tester, const Size(390, 844));
    ThemeModeController.instance.setMode(ThemeMode.dark);
    await tester.pumpWidget(_previewApp());
    await tester.pumpAndSettle();

    expect(
      Theme.of(tester.element(find.byType(ProfilePage))).brightness,
      Brightness.dark,
    );
    expect(find.text('Keluar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('preview entrypoint adapts to tablet width', (tester) async {
    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(_previewApp());
    await tester.pump();

    expect(find.byType(ProfileIdentity), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Keluar'), 160);
    expect(find.text('Keluar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
