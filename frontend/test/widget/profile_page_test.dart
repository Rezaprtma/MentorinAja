import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

Map<String, WidgetBuilder> _subPageRoutes() => {
  AppRoutes.feedback: (_) => const FeedbackPage(),
  AppRoutes.helpCenter: (_) => const HelpCenterPage(),
  AppRoutes.about: (_) => const AboutPage(),
  AppRoutes.privacyPolicy: (_) => const PrivacyPolicyPage(),
  AppRoutes.userPolicy: (_) => const UserPolicyPage(),
  AppRoutes.editProfile: (_) => const EditProfilePage(),
  AppRoutes.mentorCourses: (_) =>
      const Scaffold(body: Center(child: Text('Mentor Courses'))),
};

Widget _buildApp() {
  return AnimatedBuilder(
    animation: ThemeModeController.instance,
    builder: (context, _) => MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeModeController.instance.mode,
      routes: _subPageRoutes(),
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
    ProfileController.instance.reset();
  });

  testWidgets('renders identity, preference, support and legal sections', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Kelola akun dan preferensi belajarmu.'), findsOneWidget);

    expect(find.text('MENTOR'), findsOneWidget);
    expect(find.text('Kelola Course'), findsOneWidget);

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

  testWidgets('mentor course row opens the mentor courses route', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Kelola Course'));
    await tester.pumpAndSettle();

    expect(find.text('Mentor Courses'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('feedback row opens the feedback form', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Masukan & Saran'), 120);
    await tester.tap(find.text('Masukan & Saran'));
    await tester.pumpAndSettle();

    expect(find.byType(FeedbackPage), findsOneWidget);
    expect(find.text('Kirim Masukan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('privacy policy row opens the privacy page', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Kebijakan Privasi'), 120);
    await tester.tap(find.text('Kebijakan Privasi'));
    await tester.pumpAndSettle();

    expect(find.byType(PrivacyPolicyPage), findsOneWidget);
    expect(find.text('Data yang Kami Kumpulkan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('user policy row opens the user policy page', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Kebijakan Pengguna'), 120);
    await tester.tap(find.text('Kebijakan Pengguna'));
    await tester.pumpAndSettle();

    expect(find.byType(UserPolicyPage), findsOneWidget);
    expect(find.text('Akun dan Penggunaan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('help center row opens the FAQ page', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Pusat Bantuan'), 120);
    await tester.tap(find.text('Pusat Bantuan'));
    await tester.pumpAndSettle();

    expect(find.byType(HelpCenterPage), findsOneWidget);
    expect(find.text('Bagaimana cara mulai belajar?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('edit profile action opens the edit profile page', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Edit Profil'));
    await tester.pumpAndSettle();

    expect(find.byType(EditProfilePage), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('theme row opens the theme bottom sheet listing the modes', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Tema'));
    await tester.pumpAndSettle();

    expect(find.byType(AppBottomSheet), findsOneWidget);
    expect(find.text('Terang'), findsWidgets);
    expect(find.text('Gelap'), findsWidgets);
    expect(find.text('Ikuti Sistem'), findsWidgets);
  });

  testWidgets('theme sheet has a single title hierarchy without a label', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Tema'));
    await tester.pumpAndSettle();

    expect(find.text('Tema'), findsWidgets);
    expect(find.text('Pilih tampilan aplikasi.'), findsOneWidget);
    expect(find.text('Mode tampilan'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('theme sheet replaces radio buttons with semantic icons', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Tema'));
    await tester.pumpAndSettle();

    expect(find.byType(Radio<dynamic>), findsNothing);
    expect(find.byType(Radio<String>), findsNothing);
    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
    expect(find.byIcon(Icons.brightness_auto_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selected theme icon uses the brand active color', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Tema'));
    await tester.pumpAndSettle();

    final scheme = Theme.of(
      tester.element(find.byType(AppBottomSheet)),
    ).colorScheme;

    final activeIcon = tester.widget<Icon>(
      find.byIcon(Icons.brightness_auto_rounded),
    );
    expect(activeIcon.color, scheme.primary);

    final idleIcon = tester.widget<Icon>(find.byIcon(Icons.light_mode_rounded));
    expect(idleIcon.color, isNot(scheme.primary));
    expect(tester.takeException(), isNull);
  });

  testWidgets('selecting Gelap in the theme sheet switches to dark', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Tema'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gelap').last);
    await tester.pumpAndSettle();

    expect(ThemeModeController.instance.mode, ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.byType(AppBottomSheet))).brightness,
      Brightness.dark,
    );
  });

  testWidgets('notification row opens the notification sheet with toggles', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Notifikasi'));
    await tester.pumpAndSettle();

    expect(find.byType(AppBottomSheet), findsOneWidget);
    expect(find.text('Pembaruan Course'), findsOneWidget);
    expect(find.text('Pengingat Belajar'), findsOneWidget);
    expect(find.text('Pencapaian & Progress'), findsOneWidget);
    expect(find.text('Kabar Terbaru'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('notification sheet toggles update local switch state', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Notifikasi'));
    await tester.pumpAndSettle();

    final newsSwitch = tester.widget<SwitchListTile>(
      find.ancestor(
        of: find.text('Kabar Terbaru'),
        matching: find.byType(SwitchListTile),
      ),
    );
    expect(newsSwitch.value, isFalse);

    await tester.tap(find.text('Kabar Terbaru'));
    await tester.pump();

    final toggled = tester.widget<SwitchListTile>(
      find.ancestor(
        of: find.text('Kabar Terbaru'),
        matching: find.byType(SwitchListTile),
      ),
    );
    expect(toggled.value, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('language row opens the language sheet', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.tap(find.text('Bahasa'));
    await tester.pumpAndSettle();

    expect(find.byType(AppBottomSheet), findsOneWidget);
    expect(find.text('Bahasa Indonesia'), findsWidgets);
    expect(find.text('English'), findsOneWidget);
    expect(tester.takeException(), isNull);
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

  testWidgets('about row opens the about page with product information', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Tentang MentorinAja'), 200);
    await tester.tap(find.text('Tentang MentorinAja'));
    await tester.pumpAndSettle();

    expect(find.byType(AboutPage), findsOneWidget);
    expect(find.text('Versi 1.0.0'), findsOneWidget);
    expect(
      find.text(
        'Platform pembelajaran Indonesia dengan dukungan mentor dan AI.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('about page uses a single Tentang title hierarchy', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Tentang MentorinAja'), 200);
    await tester.tap(find.text('Tentang MentorinAja'));
    await tester.pumpAndSettle();

    expect(find.text('Tentang'), findsOneWidget);
    expect(find.text('Tentang MentorinAja'), findsNothing);
    expect(find.text('MentorinAja'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('about page uses the brand asset on the colored surface', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildApp());
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Tentang MentorinAja'), 200);
    await tester.tap(find.text('Tentang MentorinAja'));
    await tester.pumpAndSettle();

    final logo = tester.widget<AppSvg>(find.byType(AppSvg));
    expect(logo.assetPath, AppLogo.onBrand);
    expect(tester.takeException(), isNull);
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
