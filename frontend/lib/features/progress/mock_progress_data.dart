//**
// frontend/features/progress/mock_progress_data.dart
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

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/shared/data/tech_brand_colors.dart';
import 'package:frontend/shared/models/course_identifier.dart';

class MockProgressCourse {
  const MockProgressCourse({
    required this.title,
    required this.completedLessons,
    required this.lessonCount,
    required this.currentLesson,
    required this.nextLesson,
    required this.progress,
    required this.iconPath,
    required this.brand,
  });

  final String title;

  final int completedLessons;

  final int lessonCount;

  final String currentLesson;

  final String nextLesson;

  final double progress;

  final String iconPath;

  final TechBrandColors brand;

  String get lessonLabel =>
      'Pelajaran $completedLessons dari $lessonCount • $currentLesson';

  String get courseId => CourseIdentifier.slug(title);
}

abstract final class MockProgressData {
  static const List<MockProgressCourse> activeCourses = [
    MockProgressCourse(
      title: 'Dasar Python',
      completedLessons: 12,
      lessonCount: 20,
      currentLesson: 'Fungsi',
      nextLesson: 'Function Parameters',
      progress: 0.72,
      iconPath: AppIconPaths.techPython,
      brand: TechBrandColors(
        background: Color(0xFFE8F0FE),
        accent: Color(0xFF3776AB),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    MockProgressCourse(
      title: 'JavaScript Modern',
      completedLessons: 8,
      lessonCount: 18,
      currentLesson: 'Array Methods',
      nextLesson: 'DOM Manipulation',
      progress: 0.45,
      iconPath: AppIconPaths.techJavascript,
      brand: TechBrandColors(
        background: Color(0xFFFFF9E0),
        accent: Color(0xFFF7DF1E),
        onAccent: Color(0xFF3D3200),
      ),
    ),
    MockProgressCourse(
      title: 'MySQL Dasar',
      completedLessons: 4,
      lessonCount: 16,
      currentLesson: 'Query Dasar',
      nextLesson: 'Filtering Data',
      progress: 0.28,
      iconPath: AppIconPaths.techMysql,
      brand: TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF00758F),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
  ];

  static const List<MockProgressCourse> completedCourses = [
    MockProgressCourse(
      title: 'Laravel untuk Pemula',
      completedLessons: 15,
      lessonCount: 15,
      currentLesson: 'Membuat Proyek Pertama',
      nextLesson: '',
      progress: 1.0,
      iconPath: AppIconPaths.techLaravel,
      brand: TechBrandColors(
        background: Color(0xFFFCE4EC),
        accent: Color(0xFFF05340),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
  ];
}
