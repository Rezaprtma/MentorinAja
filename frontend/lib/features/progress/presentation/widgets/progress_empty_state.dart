//**
// frontend/features/progress/presentation/widgets/progress_empty_state.dart
//
// frontend:
// Reusable widget. Menampilkan komponen UI yang dapat digunakan di berbagai places.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import 'progress_category_switch.dart';

class ProgressEmptyState extends StatelessWidget {
  const ProgressEmptyState({
    super.key,
    this.category = ProgressCategory.studying,
    this.onExplore,
  });

  final ProgressCategory category;

  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    return switch (category) {
      ProgressCategory.studying => AppEmptyState(
        icon: Icons.school_outlined,
        title: 'Belum Ada Course',
        message: 'Mulai belajar dengan memilih course dari Explore.',
        actionLabel: 'Jelajahi Course',
        onAction: onExplore,
      ),
      ProgressCategory.completed => const AppEmptyState(
        icon: Icons.task_alt_outlined,
        title: 'Belum Ada Course Selesai',
        message: 'Course yang kamu selesaikan akan muncul di sini.',
      ),
    };
  }
}
