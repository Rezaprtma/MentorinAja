//**
// frontend/features/course_authoring/logic/authoring_preview_adapter.dart
//
// frontend:
// Controller. Mengelola state dan business logic untuk feature.
//
// backend:
// Future: akan membutuhkan backend persistence dan API integration.
//
// api:
// Future: akan melakukan API calls melalui repositories.
//
// qa:
// QA perlu memvalidasi state transitions dan edge cases.
//**
library;

import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/features/course/course.dart';
import 'package:frontend/features/lesson/lesson.dart';
import 'package:frontend/shared/data/tech_brand_colors.dart';
import 'package:frontend/shared/enums/enums.dart';

import '../domain/entities/course_authoring_draft.dart';
import '../domain/entities/lesson_draft.dart';

class AuthoringPreviewAdapter {
  const AuthoringPreviewAdapter();

  CoursePlayerPreview toPreview(CourseAuthoringDraft draft) {
    final lessons = _ordered(draft.lessons);
    return CoursePlayerPreview(
      course: toCourseDetail(draft),
      lessons: lessons.map(toCourseLesson).toList(),
      materiByLesson: {for (final lesson in lessons) lesson.id: const []},
      gameByLesson: {
        for (final lesson in lessons)
          lesson.id: MockModuleContentGenerator.generateGames(
            lessonId: lesson.id,
            title: lesson.title,
            language: draft.language,
          ),
      },
      latihanByLesson: {
        for (final lesson in lessons)
          lesson.id: MockModuleContentGenerator.generateExercise(
            lessonId: lesson.id,
            title: lesson.title,
            language: draft.language,
          ),
      },
    );
  }

  CourseDetail toCourseDetail(CourseAuthoringDraft draft) {
    final lang = ProgrammingLanguage.fromString(draft.language);
    return CourseDetail(
      id: draft.id,
      title: draft.title,
      category: draft.category,
      shortDescription: draft.description,
      description: draft.description,
      learningOutcomes: draft.objectives,
      lessons: _ordered(draft.lessons).map(toCourseLesson).toList(),
      iconPath: lang?.iconPath ?? _iconFor(draft.language),
      brand: lang?.brandColors ?? _brandFor(draft.language),
      rating: 0,
      level: draft.level,
      estimatedMinutes: draft.estimatedMinutes,
    );
  }

  CourseLesson toCourseLesson(LessonDraft lesson) {
    return CourseLesson(
      id: lesson.id,
      title: lesson.title,
      durationMinutes: lesson.estimatedMinutes,
      summary: lesson.description,
      state: CourseLessonState.available,
      materialPdfPath: lesson.materialPdfPath,
    );
  }

  static String _iconFor(String language) {
    return switch (language.toLowerCase()) {
      'python' => AppIconPaths.techPython,
      'javascript' || 'nodejs' => AppIconPaths.techJavascript,
      'typescript' => AppIconPaths.techTypescript,
      'php' || 'laravel' => AppIconPaths.techPhp,
      'mysql' => AppIconPaths.techMysql,
      'postgresql' || 'sql' => AppIconPaths.techPostgresql,
      'flutter' || 'dart' => AppIconPaths.techFlutter,
      'kotlin' => AppIconPaths.techKotlin,
      'swift' => AppIconPaths.techSwift,
      'html' || 'css' => AppIconPaths.techCss,
      'c' || 'c++' => AppIconPaths.techCpp,
      'java' => AppIconPaths.techJava,
      'go' => AppIconPaths.techGo,
      _ => AppImages.coursePlaceholder,
    };
  }

  static const TechBrandColors _neutralBrand = TechBrandColors(
    background: Color(0xFFEEEDFF),
    accent: Color(0xFF514AF8),
    onAccent: Color(0xFFFFFFFF),
  );

  static TechBrandColors _brandFor(String language) => _neutralBrand;

  static List<T> _ordered<T extends Object>(List<T> items) {
    if (items.isEmpty) return const [];
    return [...items]..sort((a, b) => _orderOf(a).compareTo(_orderOf(b)));
  }

  static int _orderOf(Object item) {
    return switch (item) {
      LessonDraft(order: final order) => order,
      _ => 0,
    };
  }
}
