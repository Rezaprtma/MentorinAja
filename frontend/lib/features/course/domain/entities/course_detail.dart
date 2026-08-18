//**
// frontend/features/course/domain/entities/course_detail.dart
//
// frontend:
// Entity/model. Mendefinisikan data structures untuk feature.
//
// backend:
// Future: akan sesuai dengan backend data models.
//
// api:
// Future: akan menjadi frontend expected contract untuk APIs.
//
// qa:
// QA perlu memvalidasi data validation dan edge cases.
//**
import 'package:frontend/shared/data/tech_brand_colors.dart';

import 'course_lesson.dart';

class CourseDetail {
  const CourseDetail({
    required this.id,
    required this.title,
    required this.category,
    required this.shortDescription,
    required this.description,
    required this.learningOutcomes,
    required this.lessons,
    required this.iconPath,
    required this.brand,
    required this.rating,
    this.level,
    this.studentCount,
    this.estimatedMinutes,
    this.progress,
  });

  final String id;

  final String title;

  final String category;

  final String shortDescription;

  final String description;

  final List<String> learningOutcomes;

  final List<CourseLesson> lessons;

  final String iconPath;

  final TechBrandColors brand;

  final double rating;

  final String? level;

  final int? studentCount;

  final int? estimatedMinutes;

  final double? progress;

  int get lessonCount => lessons.length;

  bool get isEnrolled => progress != null;

  CourseDetail copyWith({double? progress, List<CourseLesson>? lessons}) {
    return CourseDetail(
      id: id,
      title: title,
      category: category,
      shortDescription: shortDescription,
      description: description,
      learningOutcomes: learningOutcomes,
      lessons: lessons ?? this.lessons,
      iconPath: iconPath,
      brand: brand,
      rating: rating,
      level: level,
      studentCount: studentCount,
      estimatedMinutes: estimatedMinutes,
      progress: progress ?? this.progress,
    );
  }

  int get completedLessonCount =>
      lessons.where((l) => l.state == CourseLessonState.completed).length;

  String? get nextLessonTitle {
    if (progress == null) return null;
    for (final lesson in lessons) {
      if (lesson.state == CourseLessonState.current ||
          lesson.state == CourseLessonState.available) {
        return lesson.title;
      }
    }
    return null;
  }
}
