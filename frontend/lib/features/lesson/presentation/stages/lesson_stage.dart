import 'package:flutter/material.dart';

/// The three stage views inside the Course Player flow.
///
/// A lesson is split into teaching (Materi), a hands-on challenge (Game) and
/// application exercises (Latihan). Each stage carries its own label, icon and
/// intro copy used by the stage intro card and the top indicator.
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
