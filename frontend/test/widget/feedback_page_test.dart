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
  testWidgets('renders categories, message field and submit button', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const FeedbackPage()),
    );
    await tester.pump();

    expect(find.text('Masukan & Saran'), findsOneWidget);
    expect(find.text('Course'), findsOneWidget);
    expect(find.text('Aplikasi'), findsOneWidget);
    expect(find.text('Mentor'), findsOneWidget);
    expect(find.text('Lainnya'), findsOneWidget);
    expect(find.byType(AppMultilineField), findsOneWidget);

    final submit = tester.widget<AppButton>(find.byType(AppButton));
    expect(submit.enabled, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('submitting swaps the form for a success state and resets', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const FeedbackPage()),
    );
    await tester.pump();

    await tester.enterText(
      find.byType(AppMultilineField),
      'Saran untuk fitur baru',
    );
    await tester.pump();

    await tester.tap(find.text('Kirim Masukan'));
    await tester.pumpAndSettle();

    expect(find.text('Masukan Terkirim'), findsOneWidget);
    expect(find.byType(AppMultilineField), findsNothing);

    await tester.tap(find.text('Kirim Masukan Lagi'));
    await tester.pump();

    expect(find.byType(AppMultilineField), findsOneWidget);
    expect(find.text('Masukan Terkirim'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'adapts to narrow phones, tablets and large text without overflow',
    (tester) async {
      _setSurface(tester, const Size(320, 640));
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light(), home: const FeedbackPage()),
      );
      await tester.pump();
      expect(find.text('Kirim Masukan'), findsOneWidget);
      expect(tester.takeException(), isNull);

      _setSurface(tester, const Size(1024, 1366));
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light(), home: const FeedbackPage()),
      );
      await tester.pump();
      expect(find.text('Kirim Masukan'), findsOneWidget);
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
          home: const FeedbackPage(),
        ),
      );
      await tester.pump();
      expect(find.text('Kirim Masukan'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
