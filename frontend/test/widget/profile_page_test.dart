import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _buildApp() {
  return AnimatedBuilder(
    animation: ThemeModeController.instance,
    builder: (context, _) => MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeModeController.instance.mode,
      home: const ProfilePage(),
    ),
  );
}

Widget _buildAppWithSignOut({required VoidCallback onSignOut}) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: ProfilePage(onSignOut: onSignOut),
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

  testWidgets('renders identity, preference, support and legal sections', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Kelola akun dan preferensi belajarmu.'), findsOneWidget);

    expect(find.byType(ProfileIdentity), findsOneWidget);
    expect(find.text('Rina'), findsWidgets);
    expect(find.text('rina@mentorinaja.id'), findsOneWidget);
    expect(find.widgetWithText(AppButton, 'Edit Profil'), findsOneWidget);

    expect(find.text('Akun'), findsNothing);
    expect(find.text('Kelola Profil'), findsNothing);

    expect(find.text('Preferensi'), findsNothing);
    expect(find.text('PREFERENSI'), findsOneWidget);
    expect(find.text('Tema'), findsOneWidget);
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Bahasa'), findsOneWidget);

    final preferensi = find
        .ancestor(
          of: find.text('Tema'),
          matching: find.byType(ProfileSettingsSection),
        )
        .first;
    expect(
      find.descendant(of: preferensi, matching: find.text('Notifikasi')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: preferensi, matching: find.text('Bahasa')),
      findsOneWidget,
    );

    expect(find.text('DUKUNGAN'), findsOneWidget);
    expect(find.text('Masukan & Saran'), findsOneWidget);
    expect(find.text('Pusat Bantuan'), findsOneWidget);
    expect(find.text('Tentang MentorinAja'), findsOneWidget);

    final dukungan = find
        .ancestor(
          of: find.text('Pusat Bantuan'),
          matching: find.byType(ProfileSettingsSection),
        )
        .first;
    expect(
      find.descendant(of: dukungan, matching: find.text('Masukan & Saran')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dukungan, matching: find.text('Tentang MentorinAja')),
      findsOneWidget,
    );

    expect(find.text('LEGAL'), findsOneWidget);
    expect(find.text('Kebijakan Privasi'), findsOneWidget);
    expect(find.text('Kebijakan Pengguna'), findsOneWidget);

    final legal = find
        .ancestor(
          of: find.text('Kebijakan Privasi'),
          matching: find.byType(ProfileSettingsSection),
        )
        .first;
    expect(
      find.descendant(of: legal, matching: find.text('Kebijakan Pengguna')),
      findsOneWidget,
    );

    expect(find.text('Keluar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('theme row reports the active mode and updates live', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.text('Ikuti Sistem'), findsOneWidget);

    ThemeModeController.instance.setMode(ThemeMode.dark);
    await tester.pumpAndSettle();

    expect(find.text('Gelap'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(ProfilePage))).brightness,
      Brightness.dark,
    );

    ThemeModeController.instance.setMode(ThemeMode.light);
    await tester.pumpAndSettle();

    expect(find.text('Terang'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('language row reports the current language', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.text('Bahasa Indonesia'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('feedback row surfaces the mock action', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Masukan & Saran'), 120);
    await tester.tap(find.text('Masukan & Saran'));
    await tester.pump();

    expect(find.text('Fitur ini sedang dalam pengembangan.'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 4500));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('privacy policy row renders without an invented endpoint', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Kebijakan Privasi'), 120);
    await tester.tap(find.text('Kebijakan Privasi'));
    await tester.pump();

    expect(find.text('Fitur ini sedang dalam pengembangan.'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 4500));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('user policy row renders without an invented endpoint', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Kebijakan Pengguna'), 120);
    await tester.tap(find.text('Kebijakan Pengguna'));
    await tester.pump();

    expect(find.text('Fitur ini sedang dalam pengembangan.'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 4500));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('mock actions surface an info toast', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Pusat Bantuan'), 120);
    await tester.tap(find.text('Pusat Bantuan'));
    await tester.pump();

    expect(find.text('Fitur ini sedang dalam pengembangan.'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 4500));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('edit profile action surfaces an info toast', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Edit Profil'));
    await tester.pump();

    expect(find.text('Fitur ini sedang dalam pengembangan.'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 4500));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('opening the theme sheet lists the three color modes', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Tema'));
    await tester.pumpAndSettle();

    expect(find.text('Terang'), findsWidgets);
    expect(find.text('Gelap'), findsWidgets);
    expect(find.text('Ikuti Sistem'), findsWidgets);
  });

  testWidgets('selecting Gelap switches the theme mode to dark', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Tema'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Radio<String>).at(1));
    await tester.pumpAndSettle();

    expect(ThemeModeController.instance.mode, ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.byType(ProfilePage))).brightness,
      Brightness.dark,
    );
  });

  testWidgets('signing out opens confirmation and invokes the callback', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    var signedOut = false;

    await tester.pumpWidget(
      _buildAppWithSignOut(onSignOut: () => signedOut = true),
    );
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Keluar'), 200);
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();

    expect(find.text('Keluar dari Akun?'), findsOneWidget);

    await tester.tap(find.widgetWithText(AppButton, 'Keluar'));
    await tester.pumpAndSettle();

    expect(signedOut, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cancelling sign-out keeps the page and does not sign out', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    var signedOut = false;

    await tester.pumpWidget(
      _buildAppWithSignOut(onSignOut: () => signedOut = true),
    );
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Keluar'), 200);
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Batal'));
    await tester.pumpAndSettle();

    expect(signedOut, isFalse);
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opening the about sheet shows product information', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Tentang MentorinAja'), 200);
    await tester.tap(find.text('Tentang MentorinAja'));
    await tester.pumpAndSettle();

    expect(find.text('Versi 1.0.0'), findsOneWidget);
    expect(
      find.text(
        'Platform pembelajaran Indonesia dengan dukungan mentor dan AI.',
      ),
      findsOneWidget,
    );
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

    expect(find.text('Profil'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports large text scale without overflow', (tester) async {
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
        home: const ProfilePage(),
      ),
    );
    await tester.pump();

    expect(find.byType(ProfileIdentity), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to narrow phones without overflow', (tester) async {
    _setSurface(tester, const Size(320, 640));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.byType(ProfileIdentity), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to tablets without overflow', (tester) async {
    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.byType(ProfileIdentity), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
