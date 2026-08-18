//**
// frontend/features/lesson/presentation/stages/lesson_stage.dart
//
// frontend:
// Source file. Bagian dari MentorinAja frontend.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi file behavior sesuai dengan purpose.
//**
import 'package:flutter/material.dart';

enum LessonStage {
  materi(
    label: 'MATERI',
    icon: Icons.menu_book_rounded,
    description: 'Pelajari konsep inti lewat penjelasan, contoh kode dan tips.',
  ),
  game(
    label: 'GAME',
    icon: Icons.sports_esports_rounded,
    description: 'Selesaikan tantangan kode untuk menguatkan pemahamanmu.',
  ),
  latihan(
    label: 'LATIHAN',
    icon: Icons.fact_check_rounded,
    description: 'Terapkan pemahamanmu lewat soal-soal aplikasi.',
  );

  const LessonStage({
    required this.label,
    required this.icon,
    required this.description,
  });

  final String label;
  final IconData icon;
  final String description;
}
