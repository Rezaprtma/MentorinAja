//**
// frontend/shared/enums/enums.dart
//
// frontend:
// Shared enumerations. Menyediakan common enums untuk features.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi enum usage dan coverage.
//**
library;

import 'package:flutter/material.dart';

import '../data/tech_brand_colors.dart';
import '../../core/assets/app_icons.dart';

enum LessonContentBlockType {
  paragraph,
  code,
  bulletList,
  tip,
  exercise,
  heading,
  subheading,
  numberedList,
  warning,
  example,
  summary,
  checklist,
}

enum LessonExerciseType {
  codeCompletion,
  codeCorrection,
  codeExplanation,
  codeWriting,
}

enum GameType {
  codeOrdering,
  tokenCompletion,
  multipleChoice,
  identifyError,
  outputPrediction,
}

enum ProgrammingLanguage {
  python('Python', 'python'),
  javascript('JavaScript', 'javascript'),
  typescript('TypeScript', 'typescript'),
  java('Java', 'java'),
  c('C', 'c'),
  cpp('C++', 'cpp'),
  csharp('C#', 'csharp'),
  dart('Dart', 'dart'),
  go('Go', 'go'),
  rust('Rust', 'rust'),
  php('PHP', 'php'),
  kotlin('Kotlin', 'kotlin'),
  swift('Swift', 'swift'),
  angular('Angular', 'angular'),
  css('CSS', 'css'),
  django('Django', 'django'),
  express('Express', 'express'),
  flutter('Flutter', 'flutter'),
  html('HTML', 'html'),
  kotlin_multiplatform('Kotlin Multiplatform', 'kotlin'),
  laravel('Laravel', 'laravel'),
  mysql('MySQL', 'mysql'),
  nextjs('Next.js', 'nextjs'),
  nodejs('Node.js', 'nodejs'),
  php_laravel('PHP Laravel', 'php'),
  postgresql('PostgreSQL', 'postgresql'),
  r('R', 'r'),
  react('React', 'react'),
  ruby('Ruby', 'ruby'),
  solidity('Solidity', 'solidity'),
  sql('SQL', 'sql'),
  sqlite('SQLite', 'sqllite'),
  terminal('Terminal', 'terminal'),
  vuejs('Vue.js', 'vuejs');

  const ProgrammingLanguage(this.displayName, this.iconKey);

  final String displayName;
  final String iconKey;

  String get iconPath {
    return switch (this) {
      ProgrammingLanguage.python => AppIconPaths.techPython,
      ProgrammingLanguage.javascript => AppIconPaths.techJavascript,
      ProgrammingLanguage.typescript => AppIconPaths.techTypescript,
      ProgrammingLanguage.java => AppIconPaths.techJava,
      ProgrammingLanguage.c => AppIconPaths.techC,
      ProgrammingLanguage.cpp => AppIconPaths.techCpp,
      ProgrammingLanguage.csharp => AppIconPaths.techCsharp,
      ProgrammingLanguage.dart => AppIconPaths.techDart,
      ProgrammingLanguage.go => AppIconPaths.techGo,
      ProgrammingLanguage.rust => AppIconPaths.techRust,
      ProgrammingLanguage.php => AppIconPaths.techPhp,
      ProgrammingLanguage.kotlin => AppIconPaths.techKotlin,
      ProgrammingLanguage.swift => AppIconPaths.techSwift,
      ProgrammingLanguage.angular => AppIconPaths.techAngular,
      ProgrammingLanguage.css => AppIconPaths.techCss,
      ProgrammingLanguage.django => AppIconPaths.techDjango,
      ProgrammingLanguage.express => AppIconPaths.techExpress,
      ProgrammingLanguage.flutter => AppIconPaths.techFlutter,
      ProgrammingLanguage.html => AppIconPaths.techHtml,
      ProgrammingLanguage.kotlin_multiplatform => AppIconPaths.techKotlin,
      ProgrammingLanguage.laravel => AppIconPaths.techLaravel,
      ProgrammingLanguage.mysql => AppIconPaths.techMysql,
      ProgrammingLanguage.nextjs => AppIconPaths.techNextjs,
      ProgrammingLanguage.nodejs => AppIconPaths.techNodejs,
      ProgrammingLanguage.php_laravel => AppIconPaths.techLaravel,
      ProgrammingLanguage.postgresql => AppIconPaths.techPostgresql,
      ProgrammingLanguage.r => AppIconPaths.techR,
      ProgrammingLanguage.react => AppIconPaths.techReact,
      ProgrammingLanguage.ruby => AppIconPaths.techRuby,
      ProgrammingLanguage.solidity => AppIconPaths.techSolidity,
      ProgrammingLanguage.sql => AppIconPaths.techSql,
      ProgrammingLanguage.sqlite => AppIconPaths.techSqllite,
      ProgrammingLanguage.terminal => AppIconPaths.techTerminal,
      ProgrammingLanguage.vuejs => AppIconPaths.techVuejs,
    };
  }

  TechBrandColors get brandColors {
    return switch (this) {
      ProgrammingLanguage.python => const TechBrandColors(
        background: Color(0xFFFFF7ED),
        accent: Color(0xFFF97316),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.javascript => const TechBrandColors(
        background: Color(0xFFFFF7ED),
        accent: Color(0xFFF97316),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.typescript => const TechBrandColors(
        background: Color(0xFFEFF6FF),
        accent: Color(0xFF3178C6),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.java => const TechBrandColors(
        background: Color(0xFFFFF0F0),
        accent: Color(0xFFF04438),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.c => const TechBrandColors(
        background: Color(0xFFEFF6FF),
        accent: Color(0xFF3178C6),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.cpp => const TechBrandColors(
        background: Color(0xFFEFF6FF),
        accent: Color(0xFF3178C6),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.csharp => const TechBrandColors(
        background: Color(0xFFFFF0F0),
        accent: Color(0xFF9B2DFF),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.dart => const TechBrandColors(
        background: Color(0xFFE8F5FF),
        accent: Color(0xFF00B4E6),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.go => const TechBrandColors(
        background: Color(0xFFE8F5FF),
        accent: Color(0xFF00ADD8),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.rust => const TechBrandColors(
        background: Color(0xFFFFF0E0),
        accent: Color(0xFFF79009),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.php => const TechBrandColors(
        background: Color(0xFFEFF0FF),
        accent: Color(0xFF777BB4),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.kotlin => const TechBrandColors(
        background: Color(0xFFFFEFF7),
        accent: Color(0xFF7F52FF),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.swift => const TechBrandColors(
        background: Color(0xFFFFF0E0),
        accent: Color(0xFFF79009),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.angular => const TechBrandColors(
        background: Color(0xFFFFF0F0),
        accent: Color(0xFFDD0031),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.css => const TechBrandColors(
        background: Color(0xFFE8F5FF),
        accent: Color(0xFF2965F1),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.django => const TechBrandColors(
        background: Color(0xFFE8FFE8),
        accent: Color(0xFF092E20),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.express => const TechBrandColors(
        background: Color(0xFFF5F5F5),
        accent: Color(0xFF000000),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.flutter => const TechBrandColors(
        background: Color(0xFFE8F5FF),
        accent: Color(0xFF00B4E6),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.html => const TechBrandColors(
        background: Color(0xFFFFF0E0),
        accent: Color(0xFFE44D26),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.kotlin_multiplatform => const TechBrandColors(
        background: Color(0xFFFFEFF7),
        accent: Color(0xFF7F52FF),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.laravel => const TechBrandColors(
        background: Color(0xFFFFF0F0),
        accent: Color(0xFFFF2D20),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.mysql => const TechBrandColors(
        background: Color(0xFFEFF6FF),
        accent: Color(0xFF4479A1),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.nextjs => const TechBrandColors(
        background: Color(0xFFF5F5F5),
        accent: Color(0xFF000000),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.nodejs => const TechBrandColors(
        background: Color(0xFFE8FFE8),
        accent: Color(0xFF339933),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.php_laravel => const TechBrandColors(
        background: Color(0xFFFFF0F0),
        accent: Color(0xFFFF2D20),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.postgresql => const TechBrandColors(
        background: Color(0xFFEFF6FF),
        accent: Color(0xFF4169E1),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.r => const TechBrandColors(
        background: Color(0xFFE8F5FF),
        accent: Color(0xFF276DC3),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.react => const TechBrandColors(
        background: Color(0xFFE8F5FF),
        accent: Color(0xFF61DAFB),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.ruby => const TechBrandColors(
        background: Color(0xFFFFF0F0),
        accent: Color(0xFFCC342D),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.solidity => const TechBrandColors(
        background: Color(0xFFEFF6FF),
        accent: Color(0xFF363636),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.sql => const TechBrandColors(
        background: Color(0xFFEFF6FF),
        accent: Color(0xFF4479A1),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.sqlite => const TechBrandColors(
        background: Color(0xFFE8FFE8),
        accent: Color(0xFF003B57),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.terminal => const TechBrandColors(
        background: Color(0xFFF5F5F5),
        accent: Color(0xFF333333),
        onAccent: Color(0xFFFFFFFF),
      ),
      ProgrammingLanguage.vuejs => const TechBrandColors(
        background: Color(0xFFE8FFE8),
        accent: Color(0xFF42B883),
        onAccent: Color(0xFFFFFFFF),
      ),
    };
  }

  static ProgrammingLanguage? fromString(String value) {
    for (final lang in ProgrammingLanguage.values) {
      if (lang.name == value.toLowerCase() ||
          lang.displayName.toLowerCase() == value.toLowerCase()) {
        return lang;
      }
    }
    return null;
  }
}
