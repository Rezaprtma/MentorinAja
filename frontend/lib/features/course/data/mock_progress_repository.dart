//**
// frontend/features/course/data/mock_progress_repository.dart
//
// frontend:
// Mock data. Menyediakan sample data untuk development dan testing.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend karena hanya menyediakan mock data.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung. Integration terjadi melalui repositories.
//
// qa:
// QA perlu memvalidasi mock data coverage dan edge cases.
//**
import 'package:flutter/foundation.dart';

import '../domain/entities/course_detail.dart';
import '../domain/entities/course_progress.dart';
import '../domain/entities/course_lesson.dart';
import '../domain/repositories/course_repository.dart';
import '../domain/repositories/progress_repository.dart';
import 'mock_course_repository.dart';

class MockProgressRepository extends ChangeNotifier
    implements ProgressRepository {
  MockProgressRepository({CourseRepository? courses})
    : _courses = courses ?? MockCourseRepository();

  final CourseRepository _courses;

  final Map<String, Set<String>> _completed = {};

  final Map<String, String?> _current = {};

  @override
  CourseProgress? progressFor(String courseId) {
    final record = _recordFor(courseId);
    final course = _courses.findById(courseId);
    if (record == null || course == null) return null;

    final completed = record.completed.length;
    return CourseProgress(
      courseId: courseId,
      completedLessons: completed,
      totalLessons: course.lessonCount,
      currentLessonId: record.current,
      progress: course.lessonCount == 0 ? 0 : completed / course.lessonCount,
    );
  }

  @override
  Set<String> completedLessonIds(String courseId) {
    final record = _recordFor(courseId);
    return record?.completed ?? const <String>{};
  }

  @override
  String? currentLessonId(String courseId) {
    final record = _recordFor(courseId);
    return record?.current;
  }

  @override
  void startCourse(String courseId) {
    final course = _courses.findById(courseId);
    if (course == null || course.lessons.isEmpty) return;
    if (_completed.containsKey(courseId)) return;

    _completed[courseId] = <String>{};
    _current[courseId] = course.lessons.first.id;
    notifyListeners();
  }

  @override
  void completeLesson(String courseId, String lessonId) {
    final course = _courses.findById(courseId);
    if (course == null || course.lessons.isEmpty) return;

    if (!_completed.containsKey(courseId)) {
      _seedFromCatalog(course);
      if (!_completed.containsKey(courseId)) startCourse(courseId);
    }

    final set = _completed.putIfAbsent(courseId, () => <String>{});
    if (set.contains(lessonId)) return;

    final index = course.lessons.indexWhere((l) => l.id == lessonId);
    if (index < 0) return;

    set.add(lessonId);
    _current[courseId] = _firstOpenLesson(course, set);
    notifyListeners();
  }

  @override
  void resetAll() {
    _completed.clear();
    _current.clear();
    notifyListeners();
  }

  ({Set<String> completed, String? current})? _recordFor(String courseId) {
    final course = _courses.findById(courseId);
    if (course == null) return null;
    if (!_completed.containsKey(courseId)) _seedFromCatalog(course);
    if (!_completed.containsKey(courseId)) return null;
    return (completed: _completed[courseId]!, current: _current[courseId]);
  }

  void _seedFromCatalog(CourseDetail course) {
    if (course.progress == null) return;

    final set = <String>{};
    String? current;
    for (final lesson in course.lessons) {
      if (lesson.state == CourseLessonState.completed) set.add(lesson.id);
      if (lesson.state == CourseLessonState.current) current = lesson.id;
    }
    if (current == null &&
        set.isNotEmpty &&
        set.length < course.lessons.length) {
      current = _firstOpenLesson(course, set);
    }

    _completed[course.id] = set;
    _current[course.id] = current;
  }

  String? _firstOpenLesson(CourseDetail course, Set<String> completed) {
    for (final lesson in course.lessons) {
      if (!completed.contains(lesson.id)) return lesson.id;
    }
    return null;
  }
}
