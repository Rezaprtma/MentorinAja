import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/course/course.dart';

void main() {
  group('LearningProgressController', () {
    late LearningProgressController controller;

    setUp(() {
      controller = LearningProgressController();
    });

    test('an unstarted course reports no progress', () {
      expect(controller.progressFor('flutter-untuk-pemula'), isNull);
      expect(controller.isCompleted('flutter-untuk-pemula'), isFalse);
      expect(controller.currentLessonId('flutter-untuk-pemula'), isNull);
    });

    test('seeds progress from the catalog enrollment snapshot', () {
      final record = controller.progressFor('dasar-python');

      expect(record, isNotNull);
      expect(record!.completedLessons, 12);
      expect(record.totalLessons, 20);
      expect(record.progress, closeTo(0.6, 0.0001));
      expect(record.currentLessonId, 'lesson-13');
      expect(controller.isCompleted('dasar-python'), isFalse);
    });

    test('beginCourse starts a fresh course at its first lesson', () {
      controller.beginCourse('flutter-untuk-pemula');

      final record = controller.progressFor('flutter-untuk-pemula');
      expect(record, isNotNull);
      expect(record!.progress, 0.0);
      expect(controller.currentLessonId('flutter-untuk-pemula'), 'lesson-1');
      expect(controller.isCompleted('flutter-untuk-pemula'), isFalse);
    });

    test('completeLesson marks, advances and notifies', () {
      var notified = 0;
      controller.addListener(() => notified++);

      controller.completeLesson('dasar-python', 'lesson-13');

      final record = controller.progressFor('dasar-python')!;
      expect(record.completedLessons, 13);
      expect(record.progress, closeTo(13 / 20, 0.0001));
      expect(record.currentLessonId, 'lesson-14');
      expect(controller.isCompleted('dasar-python'), isFalse);
      expect(notified, 1);
    });

    test('completing the final lesson finishes the course', () {
      controller.completeLesson('laravel-untuk-pemula', 'lesson-15');

      expect(controller.progressFor('laravel-untuk-pemula')!.progress, 1.0);
      expect(controller.isCompleted('laravel-untuk-pemula'), isTrue);
      expect(controller.currentLessonId('laravel-untuk-pemula'), isNull);
    });

    test('lessonStates derive completed, current and locked states', () {
      final states = controller.lessonStates('dasar-python');

      expect(states.length, 20);
      expect(states.first.state, CourseLessonState.completed);
      expect(states[11].state, CourseLessonState.completed);
      expect(states[12].state, CourseLessonState.current);
      expect(states[13].state, CourseLessonState.locked);
      expect(states.last.state, CourseLessonState.locked);
    });

    test('liveCourse enriches the catalog record with live progress', () {
      final live = controller.liveCourse('dasar-python');

      expect(live, isNotNull);
      expect(live!.progress, closeTo(0.6, 0.0001));
      expect(live.lessons[12].state, CourseLessonState.current);
      expect(live.isEnrolled, isTrue);
    });

    test('an untouched course stays not enrolled on liveCourse', () {
      final live = controller.liveCourse('flutter-untuk-pemula');

      expect(live, isNotNull);
      expect(live!.progress, isNull);
      expect(live.isEnrolled, isFalse);
    });

    test('resetAll clears a freshly started course', () {
      controller.beginCourse('flutter-untuk-pemula');
      expect(controller.progressFor('flutter-untuk-pemula'), isNotNull);

      controller.resetAll();

      expect(controller.progressFor('flutter-untuk-pemula'), isNull);
    });
  });
}
