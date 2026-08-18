//**
// frontend/main_code_explanation_preview.dart
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
                type: LessonExerciseType.codeExplanation,
                title: 'Jelaskan baris kode ini',
                instruction: 'Apa fungsi baris kode berikut?',
                code: 'total = sum(nilai)',
                choices: [
                  ExerciseChoice(
                    label: 'Menghitung jumlah seluruh nilai',
                    isCorrect: true,
                  ),
                  ExerciseChoice(
                    label: 'Menghitung jumlah elemen',
                    isCorrect: false,
                  ),
                  ExerciseChoice(label: 'Menampilkan nilai', isCorrect: false),
                ],
                hint: 'sum() berhubungan dengan penjumlahan.',
                explanation:
                    'sum(nilai) menjumlahkan semua angka di daftar nilai.',
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
