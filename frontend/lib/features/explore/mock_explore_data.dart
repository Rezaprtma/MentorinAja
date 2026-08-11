import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/shared/data/tech_brand_colors.dart';

/// A learning area a learner can browse.
///
/// Carries a domain name, a short description and the supporting technology
/// stack so discovery reads by area of study rather than by individual course.
/// A technology mark (SVG or Material icon) drives the category chip.
class ExploreCategory {
  const ExploreCategory({
    required this.name,
    this.description = '',
    this.stack = const [],
    this.iconPath,
    this.icon,
    required this.brand,
  });

  /// Display name of the learning area.
  final String name;

  /// One-line invitation describing what is learned inside the area.
  final String description;

  /// SVG asset paths of the technologies taught in the area.
  final List<String> stack;

  /// SVG asset of the leading technology logo, when available.
  final String? iconPath;

  /// Fallback Material icon used when no technology logo applies.
  final IconData? icon;

  /// Brand colors driving the chip's active state and card band.
  final TechBrandColors brand;
}

/// A course available for discovery in the Explore surface.
class ExploreCourse {
  const ExploreCourse({
    required this.title,
    required this.category,
    required this.description,
    required this.iconPath,
    required this.lessonCount,
    required this.rating,
    required this.brand,
  });

  final String title;
  final String category;
  final String description;
  final String iconPath;
  final int lessonCount;
  final double rating;
  final TechBrandColors brand;
}

/// Temporary local data powering the Explore screen.
abstract final class MockExploreData {
  /// Learning areas, always led by an "all" option.
  static const List<ExploreCategory> categories = [
    ExploreCategory(
      name: 'Semua',
      icon: Icons.grid_view_rounded,
      brand: TechBrandColors(
        background: AppColors.secondaryContainer,
        accent: AppColors.secondary,
        onAccent: AppColors.onSecondary,
      ),
    ),
    ExploreCategory(
      name: 'Mobile App',
      description: 'Bangun aplikasi mobile untuk Android dan iOS.',
      stack: [
        AppIconPaths.techFlutter,
        AppIconPaths.techDart,
        AppIconPaths.techKotlin,
        AppIconPaths.techSwift,
      ],
      iconPath: AppIconPaths.techFlutter,
      brand: TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF0468D7),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCategory(
      name: 'Website',
      description: 'Bangun website modern dari frontend hingga backend.',
      stack: [
        AppIconPaths.techJavascript,
        AppIconPaths.techTypescript,
        AppIconPaths.techCss,
        AppIconPaths.techPhp,
      ],
      iconPath: AppIconPaths.techJavascript,
      brand: TechBrandColors(
        background: Color(0xFFFFF9E0),
        accent: Color(0xFFF7DF1E),
        onAccent: Color(0xFF3D3200),
      ),
    ),
    ExploreCategory(
      name: 'UI/UX',
      description: 'Pelajari cara merancang interface yang intuitif.',
      stack: [
        AppIconPaths.techCss,
        AppIconPaths.techJavascript,
        AppIconPaths.techTypescript,
      ],
      icon: Icons.palette_outlined,
      brand: TechBrandColors(
        background: AppColors.secondaryContainer,
        accent: AppColors.secondary,
        onAccent: AppColors.onSecondary,
      ),
    ),
    ExploreCategory(
      name: 'Backend',
      description: 'Bangun server dan API untuk aplikasi modern.',
      stack: [
        AppIconPaths.techPhp,
        AppIconPaths.techLaravel,
        AppIconPaths.techNodejs,
      ],
      iconPath: AppIconPaths.techPhp,
      brand: TechBrandColors(
        background: Color(0xFFEDE7F6),
        accent: Color(0xFF777BB4),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCategory(
      name: 'Database',
      description: 'Kelola dan pahami data aplikasi dengan benar.',
      stack: [
        AppIconPaths.techMysql,
        AppIconPaths.techPostgresql,
        AppIconPaths.techSqllite,
      ],
      iconPath: AppIconPaths.techMysql,
      brand: TechBrandColors(
        background: Color(0xFFE4F3F6),
        accent: Color(0xFF00758F),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCategory(
      name: 'DevOps',
      description: 'Automasi pipeline dan kelola infrastruktur aplikasi.',
      stack: [
        AppIconPaths.techPython,
        AppIconPaths.techGo,
        AppIconPaths.techNodejs,
      ],
      iconPath: AppIconPaths.techPython,
      brand: TechBrandColors(
        background: Color(0xFFE8F0FE),
        accent: Color(0xFF3776AB),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
  ];

  /// Learning areas shown in the "Untuk Kamu" discovery section.
  static List<ExploreCategory> get discoveryCategories =>
      categories.where((category) => category.name != 'Semua').toList();

  /// Courses shown in the horizontal "Kursus Populer" rail.
  static List<ExploreCourse> get popularCourses => allCourses.take(6).toList();

  /// Full catalog used by search and category filtering.
  static const List<ExploreCourse> allCourses = [
    ExploreCourse(
      title: 'Flutter untuk Pemula',
      category: 'Mobile App',
      description: 'Buat aplikasi mobile lintas platform dengan Flutter.',
      iconPath: AppIconPaths.techFlutter,
      lessonCount: 21,
      rating: 4.8,
      brand: TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF0468D7),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCourse(
      title: 'Laravel untuk Pemula',
      category: 'Backend',
      description: 'Bangun aplikasi web modern dengan framework Laravel.',
      iconPath: AppIconPaths.techLaravel,
      lessonCount: 15,
      rating: 4.6,
      brand: TechBrandColors(
        background: Color(0xFFFCE4EC),
        accent: Color(0xFFF05340),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCourse(
      title: 'HTML & CSS Modern',
      category: 'Website',
      description: 'Susun struktur dan gaya halaman web dari nol.',
      iconPath: AppIconPaths.techCss,
      lessonCount: 12,
      rating: 4.8,
      brand: TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF264DE4),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCourse(
      title: 'MySQL Dasar',
      category: 'Database',
      description: 'Pelajari database relasional dan query SQL.',
      iconPath: AppIconPaths.techMysql,
      lessonCount: 16,
      rating: 4.9,
      brand: TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF00758F),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCourse(
      title: 'Otomatisasi dengan Python',
      category: 'DevOps',
      description: 'Automasi tugas berulang dengan skrip Python.',
      iconPath: AppIconPaths.techPython,
      lessonCount: 13,
      rating: 4.6,
      brand: TechBrandColors(
        background: Color(0xFFE8F0FE),
        accent: Color(0xFF3776AB),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCourse(
      title: 'Desain Web dengan CSS',
      category: 'UI/UX',
      description: 'Kuasai tata letak, warna, dan tipografi untuk UI.',
      iconPath: AppIconPaths.techCss,
      lessonCount: 11,
      rating: 4.7,
      brand: TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF264DE4),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCourse(
      title: 'Android dengan Kotlin',
      category: 'Mobile App',
      description: 'Kembangkan aplikasi Android native dengan Kotlin.',
      iconPath: AppIconPaths.techKotlin,
      lessonCount: 16,
      rating: 4.7,
      brand: TechBrandColors(
        background: Color(0xFFF3EFFF),
        accent: Color(0xFF7F52FF),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCourse(
      title: 'iOS dengan Swift',
      category: 'Mobile App',
      description: 'Bangun aplikasi iOS dengan Swift modern.',
      iconPath: AppIconPaths.techSwift,
      lessonCount: 14,
      rating: 4.6,
      brand: TechBrandColors(
        background: Color(0xFFFEEDEA),
        accent: Color(0xFFF05138),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCourse(
      title: 'JavaScript Interaktif',
      category: 'Website',
      description: 'Bangun interaksi web yang dinamis dengan JavaScript.',
      iconPath: AppIconPaths.techJavascript,
      lessonCount: 18,
      rating: 4.8,
      brand: TechBrandColors(
        background: Color(0xFFFFF9E0),
        accent: Color(0xFFF7DF1E),
        onAccent: Color(0xFF3D3200),
      ),
    ),
    ExploreCourse(
      title: 'TypeScript Praktis',
      category: 'Website',
      description: 'Tulis JavaScript yang aman dengan tipe data.',
      iconPath: AppIconPaths.techTypescript,
      lessonCount: 15,
      rating: 4.7,
      brand: TechBrandColors(
        background: Color(0xFFEAF2FD),
        accent: Color(0xFF3178C6),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCourse(
      title: 'PHP untuk Pemula',
      category: 'Backend',
      description: 'Kembangkan aplikasi web dari sisi server dengan PHP.',
      iconPath: AppIconPaths.techPhp,
      lessonCount: 14,
      rating: 4.7,
      brand: TechBrandColors(
        background: Color(0xFFEDE7F6),
        accent: Color(0xFF777BB4),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCourse(
      title: 'Node.js & Express',
      category: 'Backend',
      description: 'Bangun API cepat dengan Node.js dan Express.',
      iconPath: AppIconPaths.techNodejs,
      lessonCount: 17,
      rating: 4.7,
      brand: TechBrandColors(
        background: Color(0xFFE9F7E6),
        accent: Color(0xFF3C873A),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
    ExploreCourse(
      title: 'PostgreSQL Lanjutan',
      category: 'Database',
      description: 'Kelola data skalabel dengan PostgreSQL.',
      iconPath: AppIconPaths.techPostgresql,
      lessonCount: 15,
      rating: 4.8,
      brand: TechBrandColors(
        background: Color(0xFFE7EEF6),
        accent: Color(0xFF336791),
        onAccent: Color(0xFFFFFFFF),
      ),
    ),
  ];
}
