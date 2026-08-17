import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/lesson/lesson.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _app(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  const completion = LessonExercise(
    type: LessonExerciseType.codeCompletion,
    title: 'Lengkapi function hitung',
    instruction: 'Pilih token yang tepat.',
    code: 'def hitung(____):\n  return sum(____)',
    blanks: [
      CodeCompletionBlank(token: 'nilai'),
      CodeCompletionBlank(token: 'nilai'),
    ],
    options: ['nilai', 'total', 'print', 'len'],
    hint: 'Gunakan nama daftar yang sama.',
    explanation: 'nilai dipakai sebagai parameter dan data yang dijumlahkan.',
  );

  const ordering = LessonExercise(
    type: LessonExerciseType.codeCompletion,
    title: 'Susun kode function hitung',
    instruction: 'Susun token agar kode berfungsi.',
    code: 'return sum(nilai)',
    options: ['return', 'sum', '(nilai)'],
    correctOrder: [0, 1, 2],
    hint: 'Mulai dari return.',
    explanation: 'return sum(nilai) mengembalikan jumlah seluruh nilai.',
  );

  group('TokenCompletionGame', () {
    testWidgets('renders code surface, tokens and submit button', (
      tester,
    ) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(const TokenCompletionGame(exercise: completion)),
      );
      await tester.pump();

      expect(find.text('Pilih token'), findsOneWidget);
      expect(find.text('Selesai'), findsOneWidget);
      for (final token in completion.options) {
        expect(find.text(token), findsWidgets);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('accepts correct tokens and shows success feedback', (
      tester,
    ) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(const TokenCompletionGame(exercise: completion)),
      );
      await tester.pump();

      final chip = find.descendant(
        of: find.byType(Wrap),
        matching: find.text('nilai'),
      );
      await tester.tap(chip);
      await tester.pump();
      await tester.tap(chip);
      await tester.pump();
      await tester.tap(find.text('Selesai'));
      await tester.pumpAndSettle();

      expect(find.text('Tepat sekali! Kode kamu benar.'), findsOneWidget);
      expect(find.textContaining('nilai dipakai'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('rejects wrong tokens and reveals a hint on request', (
      tester,
    ) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(const TokenCompletionGame(exercise: completion)),
      );
      await tester.pump();

      await tester.tap(
        find.descendant(of: find.byType(Wrap), matching: find.text('total')),
      );
      await tester.pump();
      await tester.tap(
        find.descendant(of: find.byType(Wrap), matching: find.text('print')),
      );
      await tester.pump();
      await tester.tap(find.text('Selesai'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Belum tepat'), findsOneWidget);
      await tester.tap(find.text('Lihat Petunjuk'));
      await tester.pumpAndSettle();
      expect(find.text('Gunakan nama daftar yang sama.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('self-evaluates once all blanks are filled', (tester) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(
          const TokenCompletionGame(exercise: completion, selfEvaluate: true),
        ),
      );
      await tester.pump();

      expect(find.text('Selesai'), findsNothing);

      final chip = find.descendant(
        of: find.byType(Wrap),
        matching: find.text('nilai'),
      );
      await tester.tap(chip);
      await tester.pump();
      await tester.tap(chip);
      await tester.pumpAndSettle();

      expect(find.text('Tepat sekali! Kode kamu benar.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('self-evaluates wrong and allows clearing a blank', (
      tester,
    ) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(
          const TokenCompletionGame(exercise: completion, selfEvaluate: true),
        ),
      );
      await tester.pump();

      await tester.tap(
        find.descendant(of: find.byType(Wrap), matching: find.text('total')),
      );
      await tester.pump();
      await tester.tap(
        find.descendant(of: find.byType(Wrap), matching: find.text('print')),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Belum tepat'), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(SingleChildScrollView),
          matching: find.text('print'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(SingleChildScrollView),
          matching: find.text('total'),
        ),
      );
      await tester.pumpAndSettle();

      final chip = find.descendant(
        of: find.byType(Wrap),
        matching: find.text('nilai'),
      );
      await tester.tap(chip);
      await tester.pump();
      await tester.tap(chip);
      await tester.pumpAndSettle();

      expect(find.text('Tepat sekali! Kode kamu benar.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('CodeOrderingGame', () {
    testWidgets('renders tokens, empty answer area and submit button', (
      tester,
    ) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(_app(const CodeOrderingGame(exercise: ordering)));
      await tester.pump();

      expect(find.text('Susun kode'), findsOneWidget);
      expect(find.text('Urutan kamu:'), findsOneWidget);
      expect(find.text('Periksa Jawaban'), findsOneWidget);
      for (final token in ordering.options) {
        expect(find.text(token), findsWidgets);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('accepts the correct order and shows success feedback', (
      tester,
    ) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(_app(const CodeOrderingGame(exercise: ordering)));
      await tester.pump();

      for (final token in ordering.options) {
        await tester.tap(
          find.descendant(of: find.byType(Wrap), matching: find.text(token)),
        );
        await tester.pump();
      }
      await tester.tap(find.text('Periksa Jawaban'));
      await tester.pumpAndSettle();

      expect(
        find.text('Benar. Kamu menyusun kodenya dengan tepat.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('rejects a wrong order and allows a retry', (tester) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(_app(const CodeOrderingGame(exercise: ordering)));
      await tester.pump();

      await tester.tap(
        find.descendant(of: find.byType(Wrap), matching: find.text('sum')),
      );
      await tester.pump();
      await tester.tap(
        find.descendant(of: find.byType(Wrap), matching: find.text('return')),
      );
      await tester.pump();
      await tester.tap(
        find.descendant(of: find.byType(Wrap), matching: find.text('(nilai)')),
      );
      await tester.pump();
      await tester.tap(find.text('Periksa Jawaban'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Belum tepat'), findsOneWidget);

      for (final token in ordering.options) {
        await tester.tap(
          find
              .descendant(of: find.byType(Wrap), matching: find.text(token))
              .last,
        );
        await tester.pump();
      }

      for (final token in ordering.options) {
        await tester.tap(
          find.descendant(of: find.byType(Wrap), matching: find.text(token)),
        );
        await tester.pump();
      }
      await tester.tap(find.text('Periksa Jawaban'));
      await tester.pumpAndSettle();

      expect(
        find.text('Benar. Kamu menyusun kodenya dengan tepat.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('self-evaluates once the full order is selected', (
      tester,
    ) async {
      _setSurface(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(const CodeOrderingGame(exercise: ordering, selfEvaluate: true)),
      );
      await tester.pump();

      expect(find.text('Periksa Jawaban'), findsNothing);

      for (final token in ordering.options) {
        await tester.tap(
          find.descendant(of: find.byType(Wrap), matching: find.text(token)),
        );
        await tester.pumpAndSettle();
      }

      expect(
        find.text('Benar. Kamu menyusun kodenya dengan tepat.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
