//**
// frontend/main_code_correction_preview.dart
//
// frontend:
// Development preview entrypoint. Untuk preview UI secara standalone.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi preview rendering.
//**
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
                type: LessonExerciseType.codeCorrection,
                title: 'Perbaiki kode berikut',
                instruction: 'Pilih perbaikan yang tepat.',
                code:
                    'def hitung(nilai):\n    total = sum(nilai)\n    return total / len()',
                correctedCode:
                    'def hitung(nilai):\n    total = sum(nilai)\n    return total / len(nilai)',
                choices: [
                  ExerciseChoice(label: 'len(nilai)', isCorrect: true),
                  ExerciseChoice(label: 'len(total)', isCorrect: false),
                  ExerciseChoice(
                    label: 'Tidak ada kesalahan',
                    isCorrect: false,
                  ),
                ],
                hint: 'len() membutuhkan objek yang dihitung jumlah elemennya.',
                explanation:
                    'len(nilai) menghitung jumlah elemen pada daftar nilai.',
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
