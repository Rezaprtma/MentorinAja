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

void main() {
  const tokenCompletionExercise = LessonExercise(
    type: LessonExerciseType.codeCompletion,
    gameType: GameType.tokenCompletion,
  );

  const codeOrderingExercise = LessonExercise(
    type: LessonExerciseType.codeCompletion, // Not used by game view
    gameType: GameType.codeOrdering,
    options: ['print("', 'Hello', ' World")'],
    correctOrder: [0, 1, 2],
  );

  testWidgets('GameView dispatches to TokenCompletionGame', (tester) async {
    await tester.pumpWidget(
      _app(const GameView(exercise: tokenCompletionExercise)),
    );
    await tester.pump();

    expect(find.byType(TokenCompletionGame), findsOneWidget);
    expect(find.byType(CodeOrderingGame), findsNothing);
  });

  testWidgets('GameView dispatches to CodeOrderingGame', (tester) async {
    await tester.pumpWidget(
      _app(const GameView(exercise: codeOrderingExercise)),
    );
    await tester.pump();

    expect(find.byType(CodeOrderingGame), findsOneWidget);
    expect(find.byType(TokenCompletionGame), findsNothing);
  });

  testWidgets('GameView shows placeholder for unimplemented games', (
    tester,
  ) async {
    const multipleChoiceExercise = LessonExercise(
      type: LessonExerciseType.codeCompletion,
      gameType: GameType.multipleChoice,
    );

    await tester.pumpWidget(
      _app(const GameView(exercise: multipleChoiceExercise)),
    );
    await tester.pump();

    expect(find.text('Game multipleChoice belum tersedia.'), findsOneWidget);
  });
}
