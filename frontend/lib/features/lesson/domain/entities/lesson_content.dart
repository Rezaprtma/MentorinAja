//**
// frontend/features/lesson/domain/entities/lesson_content.dart
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

import 'package:frontend/shared/enums/enums.dart';

import 'lesson_exercise.dart';

export 'package:frontend/shared/enums/enums.dart' show LessonContentBlockType;

class LessonContentBlock {
  const LessonContentBlock({
    required this.type,
    this.text,
    this.label,
    this.items = const [],
    this.heading,
    this.exercise,
  });

  final LessonContentBlockType type;

  final String? text;

  final String? label;

  final List<String> items;

  final String? heading;

  final LessonExercise? exercise;
}
