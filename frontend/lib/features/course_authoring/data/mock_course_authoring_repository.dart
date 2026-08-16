/// In-memory [CourseAuthoringRepository] seeded with sample Bahasa Indonesia content.
library;

import 'package:frontend/features/lesson/domain/entities/lesson_content.dart';
import 'package:frontend/features/lesson/domain/entities/lesson_exercise.dart';

import '../domain/entities/blank_draft.dart';
import '../domain/entities/course_authoring_draft.dart';
import '../domain/entities/draft_status.dart';
import '../domain/entities/exercise_draft.dart';
import '../domain/entities/game_choice_draft.dart';
import '../domain/entities/game_draft.dart';
import '../domain/entities/lesson_draft.dart';
import '../domain/entities/material_block_draft.dart';
import '../domain/repositories/course_authoring_repository.dart';

class MockCourseAuthoringRepository implements CourseAuthoringRepository {
  MockCourseAuthoringRepository() {
    _drafts.add(_seedPythonCourse());
  }

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
      materialBlocks: [
        MaterialBlockDraft(
          id: 'mb-1-1',
          type: LessonContentBlockType.heading,
          text: 'Apa itu Python?',
          order: 0,
        ),
        MaterialBlockDraft(
          id: 'mb-1-2',
          type: LessonContentBlockType.paragraph,
          text:
              'Python adalah bahasa pemrograman yang mudah dipelajari and banyak digunakan di berbagai bidang.',
          order: 1,
        ),
        MaterialBlockDraft(
          id: 'mb-1-3',
          type: LessonContentBlockType.code,
          text: 'print("Hello, World!")',
          label: 'Python',
          order: 2,
        ),
      ],
      games: [
        GameDraft(
          id: 'game-1-1',
          gameType: GameType.codeOrdering,
          instruction: 'Susun kode berikut agar mencetak "Halo".',
          options: ['print', '(', '"Halo"', ')'],
          correctOrder: [0, 1, 2, 3],
          order: 0,
        ),
        GameDraft(
          id: 'game-1-2',
          gameType: GameType.multipleChoice,
          instruction:
              'Fungsi apa yang digunakan untuk mencetak teks di Python?',
          choices: [
            GameChoiceDraft(label: 'print()', isCorrect: true),
            GameChoiceDraft(label: 'echo()', isCorrect: false),
            GameChoiceDraft(label: 'write()', isCorrect: false),
          ],
          explanation:
              'Fungsi print() digunakan untuk menampilkan output ke layar.',
          order: 1,
        ),
      ],
      exercises: [
        ExerciseDraft(
          id: 'ex-1-1',
          type: LessonExerciseType.codeCompletion,
          title: 'Lengkapi kode',
          instruction: 'Lengkapi kode agar mencetak "Selamat Datang".',
          code: '___("Selamat Datang")',
          blanks: [BlankDraft(token: 'print')],
          options: ['print', 'echo', 'log'],
          hint: 'Gunakan fungsi bawaan Python untuk mencetak teks.',
          order: 0,
        ),
      ],
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
      materialBlocks: [
        MaterialBlockDraft(
          id: 'mb-2-1',
          type: LessonContentBlockType.heading,
          text: 'Variabel',
          order: 0,
        ),
        MaterialBlockDraft(
          id: 'mb-2-2',
          type: LessonContentBlockType.paragraph,
          text:
              'Variabel adalah tempat menyimpan data. Di Python, variabel tidak perlu dideklarasikan tipe datanya.',
          order: 1,
        ),
        MaterialBlockDraft(
          id: 'mb-2-3',
          type: LessonContentBlockType.code,
          text: 'nama = "Budi"\numur = 17',
          label: 'Python',
          order: 2,
        ),
        MaterialBlockDraft(
          id: 'mb-2-4',
          type: LessonContentBlockType.bulletList,
          items: [
            'int — bilangan bulat',
            'float — bilangan desimal',
            'str — teks',
          ],
          order: 3,
        ),
      ],
      games: [
        GameDraft(
          id: 'game-2-1',
          gameType: GameType.tokenCompletion,
          instruction: 'Lengkapi kode agar variabel nama berisi "Ani".',
          code: '___ = "Ani"',
          blanks: [BlankDraft(token: 'nama')],
          options: ['nama', 'var', 'let'],
          order: 0,
        ),
        GameDraft(
          id: 'game-2-2',
          gameType: GameType.outputPrediction,
          instruction: 'Apa output dari kode berikut?',
          code: 'x = 5\nprint(x + 3)',
          expectedAnswer: '8',
          order: 1,
        ),
        GameDraft(
          id: 'game-2-3',
          gameType: GameType.identifyError,
          instruction: 'Temukan kesalahan pada kode berikut.',
          code: 'nama = Budi\nprint(nama)',
          choices: [
            GameChoiceDraft(
              label: 'Budi harus diapit tanda kutip',
              isCorrect: true,
            ),
            GameChoiceDraft(label: 'print harus kapital', isCorrect: false),
          ],
          explanation:
              'String di Python harus diapit tanda kutip, misalnya "Budi".',
          order: 2,
        ),
      ],
      exercises: [
        ExerciseDraft(
          id: 'ex-2-1',
          type: LessonExerciseType.codeCorrection,
          title: 'Perbaiki kode',
          instruction: 'Perbaiki kode berikut agar berjalan tanpa error.',
          code: 'nama = Budi\nprint(nama)',
          correctedCode: 'nama = "Budi"\nprint(nama)',
          choices: [
            GameChoiceDraft(
              label: 'Tambahkan tanda kutip pada Budi',
              isCorrect: true,
            ),
            GameChoiceDraft(
              label: 'Ubah print menjadi Print',
              isCorrect: false,
            ),
          ],
          explanation: 'String harus diapit tanda kutip.',
          order: 0,
        ),
      ],
    );
  }
}
