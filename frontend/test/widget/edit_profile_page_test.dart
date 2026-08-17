import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';

/// Widget tests for the Edit Profil flow.
///
/// Exercises the focused username + profile photo editor: prefilled values,
/// live validation, the disabled/active save toggle, local photo preview,
/// discard confirmation and the single source of truth shared with the
/// Profile page through [ProfileController].
Map<String, WidgetBuilder> _routes() => {
  AppRoutes.editProfile: (_) => const EditProfilePage(),
};

Widget _buildApp() {
  return MaterialApp(
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    routes: _routes(),
    home: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.editProfile),
            child: const Text('Buka Edit Profil'),
          ),
        ),
      ),
    ),
  );
}

Widget _buildProfileApp() {
  return MaterialApp(
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    routes: _routes(),
    home: const ProfilePage(),
  );
}

Future<void> _openEditPage(WidgetTester tester) async {
  await tester.pumpWidget(_buildApp());
  await tester.tap(find.text('Buka Edit Profil'));
  await tester.pumpAndSettle();
}

Future<void> _dismissToast(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 4500));
  await tester.pump(const Duration(milliseconds: 400));
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUp(() {
    ProfileController.instance.reset();
  });

  testWidgets('renders the edit profile form', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await _openEditPage(tester);

    expect(find.byType(EditProfilePage), findsOneWidget);
    expect(find.text('Edit Profil'), findsOneWidget);
    expect(find.byType(ProfilePhotoAvatar), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.widgetWithText(AppButton, 'Simpan Perubahan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('prefills the current username', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await _openEditPage(tester);

    expect(find.text('Rina'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('allows editing the username without saving yet', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await _openEditPage(tester);

    await tester.enterText(find.byType(TextFormField), 'Rina Putri');
    await tester.pump();

    expect(find.text('Rina Putri'), findsOneWidget);
    expect(ProfileController.instance.username, 'Rina');
    expect(tester.takeException(), isNull);
  });

  testWidgets('rejects an empty username', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await _openEditPage(tester);

    await tester.enterText(find.byType(TextFormField), '');
    await tester.pump();

    expect(find.text('Username tidak boleh kosong.'), findsOneWidget);
    expect(tester.widget<AppButton>(find.byType(AppButton)).enabled, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps save disabled when nothing changed', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await _openEditPage(tester);

    expect(tester.widget<AppButton>(find.byType(AppButton)).enabled, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('enables save after a username change', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await _openEditPage(tester);

    await tester.enterText(find.byType(TextFormField), 'Rina Putri');
    await tester.pump();

    expect(tester.widget<AppButton>(find.byType(AppButton)).enabled, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('save trims, updates the profile state and confirms', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await _openEditPage(tester);

    await tester.enterText(find.byType(TextFormField), '  Rina Putri  ');
    await tester.pump();
    await tester.tap(find.widgetWithText(AppButton, 'Simpan Perubahan'));
    await tester.pumpAndSettle();

    expect(ProfileController.instance.username, 'Rina Putri');
    expect(find.text('Profil berhasil diperbarui.'), findsOneWidget);

    await _dismissToast(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('updated username appears on the profile page', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_buildProfileApp());
    await tester.pump();
    expect(find.text('Rina'), findsWidgets);

    await tester.tap(find.text('Edit Profil'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'Rina Putri');
    await tester.pump();
    await tester.tap(find.widgetWithText(AppButton, 'Simpan Perubahan'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Rina Putri'), findsWidgets);
    expect(find.text('Profil berhasil diperbarui.'), findsOneWidget);

    await _dismissToast(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('avatar edit opens the photo selection sheet', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await _openEditPage(tester);

    await tester.tap(find.byTooltip('Ubah foto profil'));
    await tester.pumpAndSettle();

    expect(find.text('Pilih dari Galeri'), findsOneWidget);
    expect(find.text('Ambil Foto'), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selecting a gallery photo updates the avatar preview', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await _openEditPage(tester);

    await tester.tap(find.byTooltip('Ubah foto profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pilih dari Galeri'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('profile-photo-gallery')), findsOneWidget);
    expect(ProfileController.instance.photoUrl, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('back exits immediately without changes', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await _openEditPage(tester);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.byType(EditProfilePage), findsNothing);
    expect(find.text('Batalkan perubahan?'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('back with unsaved changes shows confirmation', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await _openEditPage(tester);

    await tester.enterText(find.byType(TextFormField), 'Rina Putri');
    await tester.pump();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Batalkan perubahan?'), findsOneWidget);
    expect(
      find.text('Perubahan yang kamu buat belum disimpan.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('discarding returns without modifying the profile', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await _openEditPage(tester);

    await tester.enterText(find.byType(TextFormField), 'Rina Putri');
    await tester.pump();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(AppButton, 'Buang Perubahan'));
    await tester.pumpAndSettle();

    expect(find.byType(EditProfilePage), findsNothing);
    expect(ProfileController.instance.username, 'Rina');
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts across widths without overflow', (tester) async {
    for (final size in const [
      Size(320, 568),
      Size(360, 640),
      Size(390, 844),
      Size(430, 932),
      Size(1024, 1366),
    ]) {
      _setSurface(tester, size);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          home: const EditProfilePage(),
        ),
      );
      await tester.pump();

      expect(find.byType(EditProfilePage), findsOneWidget);
      expect(
        find.widgetWithText(AppButton, 'Simpan Perubahan'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('supports 2x text scale without overflow', (tester) async {
    _setSurface(tester, const Size(390, 844));
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const EditProfilePage(),
      ),
    );
    await tester.pump();

    expect(find.byType(EditProfilePage), findsOneWidget);
    expect(find.widgetWithText(AppButton, 'Simpan Perubahan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
