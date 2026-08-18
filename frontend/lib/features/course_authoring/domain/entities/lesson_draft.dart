//**
// frontend/features/course_authoring/domain/entities/lesson_draft.dart
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
library;

class LessonDraft {
  const LessonDraft({
    required this.id,
    required this.title,
    required this.description,
    this.objective,
    this.estimatedMinutes = 10,
    this.order = 0,
    this.materialPdfPath,
  });

  final String id;
  final String title;
  final String description;
  final String? objective;
  final int estimatedMinutes;
  final int order;

  final String? materialPdfPath;

  LessonDraft copyWith({
    String? id,
    String? title,
    String? description,
    String? objective,
    int? estimatedMinutes,
    int? order,
    String? materialPdfPath,
  }) {
    return LessonDraft(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      objective: objective ?? this.objective,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      order: order ?? this.order,
      materialPdfPath: materialPdfPath ?? this.materialPdfPath,
    );
  }
}
