//**
// frontend/shared/data/tech_brand_colors.dart
//
// frontend:
// Shared data. Menyediakan common mock data dan utilities.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi data coverage dan edge cases.
//**
import 'package:flutter/material.dart';

class TechBrandColors {
  const TechBrandColors({
    required this.background,
    required this.accent,
    required this.onAccent,
  });

  final Color background;
  final Color accent;
  final Color onAccent;
}
