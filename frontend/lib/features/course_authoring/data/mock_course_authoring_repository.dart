//**
// frontend/features/course_authoring/data/mock_course_authoring_repository.dart
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
library;

import '../domain/entities/course_authoring_draft.dart';
import '../domain/entities/draft_status.dart';
import '../domain/entities/lesson_draft.dart';
import '../domain/repositories/course_authoring_repository.dart';

class MockCourseAuthoringRepository implements CourseAuthoringRepository {
  MockCourseAuthoringRepository() {
    _drafts.add(_seedPythonCourse());
  }

  static final MockCourseAuthoringRepository instance =
      MockCourseAuthoringRepository();

  final List<CourseAuthoringDraft> _drafts = [];

  @override
  List<CourseAuthoringDraft> allDrafts() => List.unmodifiable(_drafts);

  @override
  CourseAuthoringDraft? findDraft(String id) {
    for (final d in _drafts) {
      if (d.id == id) return d;
    }
    return null;
  }

  @override
  CourseAuthoringDraft createDraft(CourseAuthoringDraft draft) {
    _drafts.add(draft);
    return draft;
  }

  @override
  CourseAuthoringDraft updateDraft(CourseAuthoringDraft draft) {
    final index = _drafts.indexWhere((d) => d.id == draft.id);
    if (index == -1) throw StateError('Draft ${draft.id} tidak ditemukan');
    _drafts[index] = draft;
    return draft;
  }

  @override
  void deleteDraft(String id) {
    _drafts.removeWhere((d) => d.id == id);
  }

  @override
  CourseAuthoringDraft addLesson(String courseId, LessonDraft lesson) {
    final draft = _requireDraft(courseId);
    final updated = draft.copyWith(
      lessons: [...draft.lessons, lesson],
      updatedAt: DateTime.now(),
    );
    return updateDraft(updated);
  }

  @override
  CourseAuthoringDraft updateLesson(String courseId, LessonDraft lesson) {
    final draft = _requireDraft(courseId);
    final lessons = draft.lessons.map((l) {
      return l.id == lesson.id ? lesson : l;
    }).toList();
    final updated = draft.copyWith(lessons: lessons, updatedAt: DateTime.now());
    return updateDraft(updated);
  }

  @override
  CourseAuthoringDraft deleteLesson(String courseId, String lessonId) {
    final draft = _requireDraft(courseId);
    final lessons = draft.lessons.where((l) => l.id != lessonId).toList();
    final updated = draft.copyWith(lessons: lessons, updatedAt: DateTime.now());
    return updateDraft(updated);
  }

  @override
  CourseAuthoringDraft reorderLessons(String courseId, List<String> lessonIds) {
    final draft = _requireDraft(courseId);
    final byId = {for (final l in draft.lessons) l.id: l};
    final reordered = <LessonDraft>[];
    for (var i = 0; i < lessonIds.length; i++) {
      final lesson = byId[lessonIds[i]];
      if (lesson != null) reordered.add(lesson.copyWith(order: i));
    }
    final updated = draft.copyWith(
      lessons: reordered,
      updatedAt: DateTime.now(),
    );
    return updateDraft(updated);
  }

  @override
  CourseAuthoringDraft publishCourse(String id) {
    final draft = _requireDraft(id);
    final updated = draft.copyWith(
      status: DraftStatus.published,
      updatedAt: DateTime.now(),
    );
    return updateDraft(updated);
  }

  @override
  CourseAuthoringDraft unpublishCourse(String id) {
    final draft = _requireDraft(id);
    final updated = draft.copyWith(
      status: DraftStatus.draft,
      updatedAt: DateTime.now(),
    );
    return updateDraft(updated);
  }

  CourseAuthoringDraft _requireDraft(String id) {
    final draft = findDraft(id);
    if (draft == null) throw StateError('Draft $id tidak ditemukan');
    return draft;
  }

  CourseAuthoringDraft _seedPythonCourse() {
    return CourseAuthoringDraft(
      id: 'draft-python-dasar',
      title: 'Dasar Python',
      description:
          'Pelajari dasar-dasar bahasa pemrograman Python dari nol hingga mahir.',
      category: 'Pemrograman',
      language: 'Python',
      level: 'Pemula',
      estimatedMinutes: 60,
      objectives: [
        'Memahami sintaks dasar Python',
        'Menulis program sederhana',
        'Menggunakan variabel dan tipe data',
      ],
      targetAudience: 'Pelajar dan mahasiswa yang baru mengenal pemrograman',
      status: DraftStatus.draft,
      updatedAt: DateTime(2026, 8, 1),
      lessons: [_seedLesson1(), _seedLesson2()],
    );
  }

  LessonDraft _seedLesson1() {
    return const LessonDraft(
      id: 'lesson-1-hello',
      title: 'Hello World',
      description: 'Menulis program pertama dengan Python.',
      objective: 'Memahami fungsi print dan menjalankan skrip Python.',
      estimatedMinutes: 15,
      order: 0,
      materialPdfPath: 'assets/pdfs/python_hello_world.pdf',
    );
  }

  LessonDraft _seedLesson2() {
    return const LessonDraft(
      id: 'lesson-2-variabel',
      title: 'Variabel dan Tipe Data',
      description: 'Mengenal variabel, tipe data, dan cara penggunaannya.',
      objective: 'Mampu mendeklarasikan variabel dan memahami tipe data dasar.',
      estimatedMinutes: 20,
      order: 1,
      materialPdfPath: 'assets/pdfs/python_variabel.pdf',
    );
  }
}
