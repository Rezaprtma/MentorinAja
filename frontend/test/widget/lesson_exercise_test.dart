import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/lesson/lesson.dart';
import 'package:frontend/shared/design_system/design_system.dart';

import 'package:frontend/features/lesson/presentation/widgets/exercises/exercise_feedback.dart';

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

  const correction = LessonExercise(
    type: LessonExerciseType.codeCorrection,
    title: 'Perbaiki kode berikut',
    instruction: 'Pilih perbaikan.',
    code: 'return total / len()',
    correctedCode: 'return total / len(nilai)',
    choices: [
      ExerciseChoice(label: 'len(nilai)', isCorrect: true),
      ExerciseChoice(label: 'len(total)', isCorrect: false),
    ],
    hint: 'len() butuh objek.',
    explanation: 'len(nilai) menghitung jumlah elemen nilai.',
  );

  const explanation = LessonExercise(
    type: LessonExerciseType.codeExplanation,
    title: 'Jelaskan baris kode ini',
    instruction: 'Apa fungsinya?',
    code: 'total = sum(nilai)',
    choices: [
      ExerciseChoice(label: 'Menghitung jumlah seluruh nilai', isCorrect: true),
      ExerciseChoice(label: 'Menghapus nilai', isCorrect: false),
    ],
    hint: 'sum berarti menjumlahkan.',
    explanation: 'sum(nilai) menjumlahkan semua angka.',
  );

  testWidgets('code completion accepts correct tokens', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _app(const LessonExerciseView(exercise: completion)),
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
    await tester.tap(find.text('Periksa Jawaban'));
    await tester.pumpAndSettle();

    expect(find.text('Tepat sekali! Kode kamu benar.'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ExerciseFeedbackPanel),
        matching: find.textContaining('nilai dipakai'),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('code completion shows hint after incorrect answer', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _app(const LessonExerciseView(exercise: completion)),
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
    await tester.tap(find.text('Periksa Jawaban'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Belum tepat'), findsOneWidget);
    await tester.tap(find.text('Lihat Petunjuk'));
    await tester.pumpAndSettle();
    expect(find.text('Gunakan nama daftar yang sama.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('code correction reveals corrected code', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _app(const LessonExerciseView(exercise: correction)),
    );
    await tester.pump();

    await tester.tap(find.text('len(nilai)'));
    await tester.pump();
    await tester.tap(find.text('Periksa Jawaban'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Benar'), findsOneWidget);
    expect(find.text('return total / len(nilai)'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('code explanation gives instant conceptual feedback', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _app(const LessonExerciseView(exercise: explanation)),
    );
    await tester.pump();

    await tester.tap(find.text('Menghitung jumlah seluruh nilai'));
    await tester.pump();
    await tester.tap(find.text('Periksa Jawaban'));
    await tester.pumpAndSettle();

    expect(find.text('Tepat. Kamu menangkap maksud kode ini.'), findsOneWidget);
    // Explanation text contains sum(nilai) inside feedback; ensure it's the feedback one
    expect(
      find.descendant(
        of: find.byType(ExerciseFeedbackPanel),
        matching: find.textContaining('sum(nilai)'),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('completion self-evaluates once all blanks are filled', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _app(const LessonExerciseView(exercise: completion, selfEvaluate: true)),
    );
    await tester.pump();

    expect(find.text('Periksa Jawaban'), findsNothing);

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

  testWidgets('completion self-evaluates incorrect and reveals a hint', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _app(const LessonExerciseView(exercise: completion, selfEvaluate: true)),
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
    await tester.tap(find.text('Lihat Petunjuk'));
    await tester.pumpAndSettle();
    expect(find.text('Gunakan nama daftar yang sama.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('correction self-evaluates on selection', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _app(const LessonExerciseView(exercise: correction, selfEvaluate: true)),
    );
    await tester.pump();

    expect(find.text('Periksa Jawaban'), findsNothing);

    await tester.tap(find.text('len(nilai)'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Benar'), findsOneWidget);
    expect(find.text('return total / len(nilai)'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('explanation self-evaluates and allows a retry after a miss', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _app(const LessonExerciseView(exercise: explanation, selfEvaluate: true)),
    );
    await tester.pump();

    expect(find.text('Periksa Jawaban'), findsNothing);

    await tester.tap(find.text('Menghapus nilai'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Belum tepat'), findsOneWidget);

    await tester.tap(find.text('Menghitung jumlah seluruh nilai'));
    await tester.pumpAndSettle();
    expect(find.text('Tepat. Kamu menangkap maksud kode ini.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
