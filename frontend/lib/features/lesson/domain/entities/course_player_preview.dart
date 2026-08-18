//**
// frontend/features/lesson/domain/entities/course_player_preview.dart
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

import 'package:frontend/features/course/course.dart';

import 'lesson_content.dart';
import 'lesson_exercise.dart';

class CoursePlayerPreview {
  const CoursePlayerPreview({
    required this.course,
    required this.lessons,
    required this.materiByLesson,
    required this.gameByLesson,
    required this.latihanByLesson,
  });

  final CourseDetail course;

  final List<CourseLesson> lessons;

  final Map<String, List<LessonContentBlock>> materiByLesson;

  final Map<String, List<LessonExercise>> gameByLesson;

  final Map<String, LessonExercise?> latihanByLesson;
}
