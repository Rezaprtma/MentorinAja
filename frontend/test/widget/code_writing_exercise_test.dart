import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/lesson/lesson.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _app(Widget child, {double textScaler = 1.0}) {
  return MaterialApp(
    theme: AppTheme.light(),
    builder: (context, widget) {
      return MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScaler)),
        child: widget!,
      );
    },
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  const writing = LessonExercise(
    type: LessonExerciseType.codeWriting,
    title: 'Tulis kode',
    instruction: 'Tulis kode yang menampilkan Hello World.',
    code: 'def main():\n  pass',
    expectedAnswer: 'print("Hello World")',
    hint: 'Gunakan print().',
    explanation: 'print mencetak teks ke layar.',
  );

  testWidgets(
    'initial rendering displays title, instruction, context code and disabled submit button',
    (tester) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(const LessonExerciseView(exercise: writing)),
      );
      await tester.pump();

      expect(find.text('COBA SENDIRI'), findsOneWidget);
      expect(find.text('Tulis kode'), findsOneWidget);
      expect(
        find.text('Tulis kode yang menampilkan Hello World.'),
        findsOneWidget,
      );
      expect(find.text('def main():\n  pass'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      final buttonFinder = find.widgetWithText(AppButton, 'Periksa Jawaban');
      expect(buttonFinder, findsOneWidget);
      final button = tester.widget<AppButton>(buttonFinder);
      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'code input enables submit button and permits empty submission check',
    (tester) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(const LessonExerciseView(exercise: writing)),
      );
      await tester.pump();

      final editor = find.byType(TextField);
      await tester.enterText(editor, '  ');
      await tester.pump();

      // Button should still be disabled for whitespace only
      var button = tester.widget<AppButton>(
        find.widgetWithText(AppButton, 'Periksa Jawaban'),
      );
      expect(button.onPressed, isNull);

      await tester.enterText(editor, 'print');
      await tester.pump();
      button = tester.widget<AppButton>(
        find.widgetWithText(AppButton, 'Periksa Jawaban'),
      );
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets('correct answer shows success feedback panel and explanation', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app(const LessonExerciseView(exercise: writing)));
    await tester.pump();

    final editor = find.byType(TextField);
    await tester.enterText(editor, 'print("Hello World")');
    await tester.pump();

    await tester.tap(find.text('Periksa Jawaban'));
    await tester.pumpAndSettle();

    expect(find.text('Bagus! Kode kamu benar.'), findsOneWidget);
    expect(
      find.textContaining('print mencetak teks ke layar.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'incorrect answer shows error feedback, hint button, and supports retry',
    (tester) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(const LessonExerciseView(exercise: writing)),
      );
      await tester.pump();

      final editor = find.byType(TextField);
      await tester.enterText(editor, 'wrong code');
      await tester.pump();

      await tester.tap(find.text('Periksa Jawaban'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Belum tepat'), findsOneWidget);

      // Show hint
      await tester.tap(find.text('Lihat Petunjuk'));
      await tester.pumpAndSettle();
      expect(find.text('Gunakan print().'), findsOneWidget);

      // Retry resets field and clear errors
      await tester.tap(find.text('Coba Lagi'));
      await tester.pumpAndSettle();

      final clearedField = tester.widget<TextField>(editor);
      expect(clearedField.controller?.text, isEmpty);
      expect(find.textContaining('Belum tepat'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('responsive layout on narrow screen (320px)', (tester) async {
    _setSurface(tester, const Size(320, 568));
    await tester.pumpWidget(_app(const LessonExerciseView(exercise: writing)));
    await tester.pump();

    expect(find.text('Tulis kode'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports 2.0x text scale without overflowing', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _app(const LessonExerciseView(exercise: writing), textScaler: 2.0),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tulis kode'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('accessibility and semantics check', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(_app(const LessonExerciseView(exercise: writing)));
    await tester.pump();

    final semantics = tester.getSemantics(find.byType(TextField));
    expect(semantics.label, contains('Editor kode'));
    expect(tester.takeException(), isNull);
  });
}
