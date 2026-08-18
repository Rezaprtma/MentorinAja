//**
// frontend/features/course_authoring/domain/repositories/course_authoring_repository.dart
//
// frontend:
// Repository interface. Mendefinisikan kontrak data untuk feature.
//
// backend:
// Future: akan diimplementasikan dengan real backend calls.
//
// api:
// Future: akan menjadi integration point untuk backend APIs.
//
// qa:
// QA perlu memvalidasi data flow dan error handling.
//**
library;

import '../entities/course_authoring_draft.dart';
import '../entities/lesson_draft.dart';

abstract class CourseAuthoringRepository {
  List<CourseAuthoringDraft> allDrafts();

  CourseAuthoringDraft? findDraft(String id);

  CourseAuthoringDraft createDraft(CourseAuthoringDraft draft);

  CourseAuthoringDraft updateDraft(CourseAuthoringDraft draft);

  void deleteDraft(String id);

  CourseAuthoringDraft addLesson(String courseId, LessonDraft lesson);

  CourseAuthoringDraft updateLesson(String courseId, LessonDraft lesson);

  CourseAuthoringDraft deleteLesson(String courseId, String lessonId);

  CourseAuthoringDraft reorderLessons(String courseId, List<String> lessonIds);

  CourseAuthoringDraft publishCourse(String id);

  CourseAuthoringDraft unpublishCourse(String id);
}
