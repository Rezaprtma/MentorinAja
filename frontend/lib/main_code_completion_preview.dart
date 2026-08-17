import 'package:flutter/material.dart';

import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/lesson/lesson.dart';
import 'package:frontend/shared/design_system/design_system.dart';

void main() {
  runApp(
    ListenableBuilder(
      listenable: ThemeModeController.instance,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeModeController.instance.mode,
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: LessonExerciseView(
              exercise: LessonExercise(
                type: LessonExerciseType.codeCompletion,
                title: 'Lengkapi function hitung',
                instruction: 'Pilih token yang tepat untuk tiap bagian kosong.',
                code:
                    'def hitung(____):\n    total = sum(____)\n    return total / len(nilai)',
                blanks: [
                  CodeCompletionBlank(token: 'nilai'),
                  CodeCompletionBlank(token: 'nilai'),
                ],
                options: ['nilai', 'total', 'print', 'len'],
                hint:
                    'Parameter dan argumen sum() harus menunjuk data yang sama.',
                explanation:
                    'nilai menerima daftar angka yang dihitung rata-ratanya.',
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
