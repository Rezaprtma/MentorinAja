import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/shared/data/tech_brand_colors.dart';

/// Accent role that drives the surface tint of a course card.
enum CourseAccent {
  /// Warm primary tint for highlighted courses.
  primary,

  /// Cool secondary tint for supporting courses.
  secondary,

  /// Neutral white surface with a soft border.
  neutral,
}

/// Purpose-driven variant that selects the hero banner's visual treatment.
enum MockBannerKind {
  /// Achievement banner highlighting a daily-learning streak.
  achievement,

  /// Banner surfacing the learner's personalized interest progress.
  interest,

  /// Banner inviting exploration of new learning material.
  discovery,
}

/// Promotional page shown inside the hero banner carousel.
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

  /// Which visual treatment this banner renders.
  final MockBannerKind kind;

  final String title;
  final String message;
  final String ctaLabel;

  /// Consecutive learning days used by the achievement banner.
  final int? streakDays;

  /// Technology logo asset path used by course and discovery banners.
  final String? iconPath;

  /// Full illustration asset path used by the discovery banner.
  final String? illustrationPath;

  /// Normalized progress (0–1) used by the interest banner's ring.
  final double? progress;

  /// Short summary shown under the interest banner's ring.
  final String? progressLabel;

  /// Short metric (e.g. "6 kursus") used by legacy discovery layouts.
  final String? metricLabel;
}

/// Recommended course preview shown on the Home screen.
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

  /// One short line summarizing what the course teaches.
  final String description;

  /// SVG asset path of the real technology logo (see [AppIconPaths]).
  final String iconPath;

  /// Technology-brand-derived card colors. When non-null the card uses these
  /// instead of the generic [accent] palette.
  final TechBrandColors? brand;

  /// Learner rating displayed on the card.
  final double rating;

  /// Determines the card's tinted surface (fallback when [brand] is null).
  final CourseAccent accent;
}

/// Temporary local data powering the Home screen.
///
/// These values are mock data used only for UI development. They are replaced
/// by authentication, catalog and progress endpoints in a later phase, so
/// screens must never branch on this module's specifics.
abstract final class MockHomeData {
  /// Mock learner identity shown in the greeting.
  static const String displayName = 'Rina';

  /// In-progress course shown in the "Progres Saya" card.
  static const String courseTitle = 'Dasar Python';

  /// Current lesson summary shown under the course title.
  static const String lessonLabel = 'Pelajaran 12 dari 20 • Fungsi';

  /// Normalized course completion in the range 0.0–1.0.
  static const double courseProgress = 0.72;

  /// Consecutive learning days in the current streak.
  static const int dayStreak = 7;

  /// Promotional banners rendered as the swipeable hero carousel.
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

  /// Courses surfaced in the horizontally scrolling recommendation rail.
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
