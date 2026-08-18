//**
// frontend/features/home/mock_home_data.dart
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

enum CourseAccent { primary, secondary, neutral }

enum MockBannerKind { achievement, interest, discovery }

class MockBanner {
  const MockBanner({
    required this.kind,
    required this.title,
    required this.message,
    required this.ctaLabel,
    this.streakDays,
    this.iconPath,
    this.illustrationPath,
    this.progress,
    this.progressLabel,
    this.metricLabel,
  });

  final MockBannerKind kind;

  final String title;
  final String message;
  final String ctaLabel;

  final int? streakDays;

  final String? iconPath;

  final String? illustrationPath;

  final double? progress;

  final String? progressLabel;

  final String? metricLabel;
}

class MockCourse {
  const MockCourse({
    required this.title,
    required this.category,
    required this.lessonCount,
    required this.description,
    required this.iconPath,
    this.brand,
    this.rating = 4.5,
    this.accent = CourseAccent.neutral,
  });

  final String title;
  final String category;
  final int lessonCount;

  final String description;

  final String iconPath;

  final TechBrandColors? brand;

  final double rating;

  final CourseAccent accent;

  String get courseId => CourseIdentifier.slug(title);
}

abstract final class MockHomeData {
  static const String displayName = 'Rina';

  static const String courseTitle = 'Dasar Python';

  static const String lessonLabel = 'Pelajaran 12 dari 20 • Fungsi';

  static const double courseProgress = 0.72;

  static const int dayStreak = 7;

  static const List<MockBanner> homeBanners = [
    MockBanner(
      kind: MockBannerKind.achievement,
      title: 'Tingkatkan Kemampuanmu',
      message: 'Belajar lebih terarah dengan mentor dan AI.',
      ctaLabel: 'Mulai Sekarang',
      streakDays: dayStreak,
    ),
    MockBanner(
      kind: MockBannerKind.interest,
      title: 'Kamu Tertarik dengan Backend?',
      message: 'Lanjutkan belajarmu dan capai target berikutnya.',
      ctaLabel: 'Lihat Sekarang',
      progress: courseProgress,
      progressLabel: 'Kemajuan kamu',
    ),
    MockBanner(
      kind: MockBannerKind.discovery,
      title: 'Temukan Materi Baru',
      message: 'Eksplorasi topik baru dan perluas keterampilanmu.',
      ctaLabel: 'Lihat Sekarang',
      illustrationPath: AppIconPaths.banner3,
    ),
  ];

  static const List<MockCourse> recommendedCourses = [
    MockCourse(
      title: 'Dasar Python',
      category: 'Pemrograman',
      lessonCount: 20,
      description: 'Pelajari sintaks dan konsep dasar Python.',
      iconPath: AppIconPaths.techPython,
      rating: 4.9,
      brand: TechBrandColors(
        background: Color(0xFFE8F0FE),
        accent: Color(0xFF3776AB),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    MockCourse(
      title: 'JavaScript Modern',
      category: 'Frontend',
      lessonCount: 18,
      description: 'Bangun interaksi web dengan JavaScript.',
      iconPath: AppIconPaths.techJavascript,
      rating: 4.8,
      brand: TechBrandColors(
        background: Color(0xFFFFF9E0),
        accent: Color(0xFFF7DF1E),
        onAccent: Color(0xFF3D3200),
      ),
    ),
    MockCourse(
      title: 'PHP untuk Pemula',
      category: 'Backend',
      lessonCount: 14,
      description: 'Bangun aplikasi web dengan PHP.',
      iconPath: AppIconPaths.techPhp,
      rating: 4.7,
      brand: TechBrandColors(
        background: Color(0xFFEDE7F6),
        accent: Color(0xFF777BB4),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    MockCourse(
      title: 'MySQL Dasar',
      category: 'Database',
      lessonCount: 16,
      description: 'Pelajari database dan query SQL.',
      iconPath: AppIconPaths.techMysql,
      rating: 4.9,
      brand: TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF00758F),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    MockCourse(
      title: 'Dasar HTML & CSS',
      category: 'Frontend',
      lessonCount: 12,
      description: 'Susun struktur dan gaya halaman web.',
      iconPath: AppIconPaths.techCss,
      rating: 4.8,
      brand: TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF264DE4),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    MockCourse(
      title: 'Laravel untuk Pemula',
      category: 'Backend',
      lessonCount: 15,
      description: 'Kembangkan aplikasi web dengan Laravel.',
      iconPath: AppIconPaths.techLaravel,
      rating: 4.6,
      brand: TechBrandColors(
        background: Color(0xFFFCE4EC),
        accent: Color(0xFFF05340),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
  ];
}
