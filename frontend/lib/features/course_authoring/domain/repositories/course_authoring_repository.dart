/// Data source seam for course authoring drafts.
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
