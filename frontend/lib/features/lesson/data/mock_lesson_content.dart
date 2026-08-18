//**
// frontend/features/lesson/data/mock_lesson_content.dart
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
import 'package:frontend/features/course/course.dart';

import '../domain/entities/lesson_content.dart';
import 'mock_lesson_exercises.dart';

abstract final class MockLessonContent {
  static List<LessonContentBlock> materiBlocks(
    CourseDetail course,
    CourseLesson lesson, {
    required int index,
    required int total,
  }) {
    return forLesson(
      course,
      lesson,
      index: index,
      total: total,
    ).where((block) => block.type != LessonContentBlockType.exercise).toList();
  }

  static List<LessonContentBlock> forLesson(
    CourseDetail course,
    CourseLesson lesson, {
    required int index,
    required int total,
  }) {
    return [
      LessonContentBlock(
        type: LessonContentBlockType.heading,
        text: lesson.title,
      ),
      LessonContentBlock(
        type: LessonContentBlockType.paragraph,
        text:
            'Pelajaran ${index + 1} dari $total di course ${course.title} '
            'membahas "${lesson.title}". Kamu akan mempelajari konsepnya '
            'lewat penjelasan singkat, melihat contoh langsung, lalu '
            'menerapkannya dalam latihan kecil.',
      ),
      const LessonContentBlock(
        type: LessonContentBlockType.bulletList,
        heading: 'PELAJARI',
        items: [
          'Memahami konsep inti dari pelajaran ini.',
          'Melihat contoh nyata dalam bahasa yang sedang dipelajari.',
          'Berlatih langsung dengan kode sederhana.',
        ],
      ),
      LessonContentBlock(
        type: LessonContentBlockType.paragraph,
        text: _conceptParagraph(course, lesson),
      ),
      const LessonContentBlock(
        type: LessonContentBlockType.subheading,
        text: 'Langkah Pembelajaran',
      ),
      const LessonContentBlock(
        type: LessonContentBlockType.numberedList,
        items: [
          'Baca teori dan pahami konsep dasar.',
          'Pelajari contoh kode yang diberikan.',
          'Kerjakan game interaktif untuk menguji pemahaman.',
          'Selesaikan latihan menulis kode secara mandiri.',
        ],
      ),
      const LessonContentBlock(
        type: LessonContentBlockType.warning,
        text:
            'Pastikan kamu sudah memahami materi sebelumnya. Konsep di '
            'pelajaran ini membangun di atas fondasi yang sudah dipelajari — '
            'melewati langkah bisa membuat bagian selanjutnya terasa lebih '
            'sulit dari seharusnya.',
      ),
      LessonContentBlock(
        type: LessonContentBlockType.code,
        label: _languageLabel(course.id),
        heading: 'LIHAT CONTOH',
        text: snippetFor(course, lesson),
      ),
      LessonContentBlock(
        type: LessonContentBlockType.example,
        heading: 'CONTOH PENERAPAN',
        text:
            'Bayangkan kamu sedang mengerjakan proyek kecil. Kamu bisa '
            'langsung menerapkan "${lesson.title}" untuk menyelesaikan '
            'masalah nyata — mulai dari yang sederhana, lalu tingkatkan '
            'kompleksitasnya seiring pemahamanmu bertambah.',
      ),
      const LessonContentBlock(
        type: LessonContentBlockType.summary,
        text:
            'Sebagai rangkuman, pemahaman tentang topik ini sangat krusial '
            'karena akan terus digunakan pada materi-materi tingkat lanjut.',
      ),
      const LessonContentBlock(
        type: LessonContentBlockType.checklist,
        heading: 'TARGET MANDIRI',
        items: [
          'Saya sudah mencoba menjalankan kode contoh.',
          'Saya mengerti alur logika dari baris per baris kode.',
          'Saya siap melanjutkan ke tantangan game.',
        ],
      ),
      LessonContentBlock(
        type: LessonContentBlockType.exercise,
        exercise: MockLessonExercises.forLesson(
          course,
          lesson,
          index: index,
          code: snippetFor(course, lesson),
        ),
      ),
      const LessonContentBlock(
        type: LessonContentBlockType.tip,
        heading: 'DAPATKAN FEEDBACK',
        text:
            'Jangan terburu-buru. Pahami tiap baris kode sebelum lanjut ke '
            'pelajaran berikutnya.',
      ),
    ];
  }

  static String _conceptParagraph(CourseDetail course, CourseLesson lesson) {
    return '"${lesson.title}" adalah salah satu fondasi dalam bidang '
        '${course.category}. Dalam praktiknya, kamu akan menggunakannya '
        'hampir di setiap proyek, jadi memahami cara kerjanya sejak awal '
        'membuat materi selanjutnya terasa jauh lebih ringan. Fokus pada '
        'bagaimana setiap bagian saling berhubungan, bukan sekadar '
        'menghafal sintaksnya.';
  }

  static String snippetFor(CourseDetail course, CourseLesson lesson) {
    final snippet = _snippets[course.id];
    if (snippet != null) return snippet;
    return '''
# ${lesson.title}
# Contoh praktik singkat dari course ${course.title}.
# Tulis implementasi pertamamu di sini.
''';
  }

  static String _languageLabel(String courseId) {
    if (courseId == 'javascript-modern' ||
        courseId == 'javascript-interaktif' ||
        courseId == 'nodejs-express') {
      return 'JavaScript';
    }
    if (courseId == 'typescript-praktis') return 'TypeScript';
    if (courseId == 'mysql-dasar' || courseId == 'postgresql-lanjutan') {
      return 'SQL';
    }
    if (courseId == 'flutter-untuk-pemula') return 'Dart';
    if (courseId == 'android-dengan-kotlin') return 'Kotlin';
    if (courseId == 'ios-dengan-swift') return 'Swift';
    if (courseId == 'html-css-modern' ||
        courseId == 'dasar-html-css' ||
        courseId == 'desain-web-dengan-css') {
      return 'HTML & CSS';
    }
    if (courseId == 'laravel-untuk-pemula' || courseId == 'php-untuk-pemula') {
      return 'PHP';
    }
    return 'Kode';
  }

  static const Map<String, String> _snippets = {
    'dasar-python': r'''
def hitung_rata_rata(nilai):
    total = sum(nilai)
    return total / len(nilai)

nilai = [85, 92, 78, 96]
print(f"Rata-rata: {hitung_rata_rata(nilai):.1f}")
''',
    'otomatisasi-dengan-python': r'''
import os

folder = "laporan"
for nama_file in os.listdir(folder):
    if nama_file.endswith(".txt"):
        print(f"Memproses {nama_file}")
''',
    'javascript-modern': r'''
const materi = ['Python', 'JavaScript', 'SQL'];
const hasil = materi.map((item) => `Kursus: ${item}`);
console.log(hasil);
''',
    'javascript-interaktif': r'''
document.querySelectorAll('.btn').forEach((btn) => {
  btn.addEventListener('click', (event) => {
    alert('Klik diterima!');
  });
});
''',
    'typescript-praktis': r'''
interface Course {
  id: string;
  title: string;
  lessonCount: number;
}

const course: Course = {
  id: 'dasar-python',
  title: 'Dasar Python',
  lessonCount: 20,
};
''',
    'mysql-dasar': r'''
SELECT kategori, COUNT(*) AS jumlah_course
FROM courses
GROUP BY kategori
ORDER BY jumlah_course DESC;
''',
    'postgresql-lanjutan': r'''
SELECT user_id, RANK() OVER (ORDER BY progress DESC) AS peringkat
FROM enrollments;
''',
    'php-untuk-pemula': r'''
<?php
$nama = "Rina";
echo "Halo, $nama!";
?>
''',
    'laravel-untuk-pemula': r'''
Route::get('/courses/{course}', function (Course $course) {
    return view('courses.show', compact('course'));
});
''',
    'flutter-untuk-pemula': r'''
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(title));
  }
}
''',
    'android-dengan-kotlin': r'''
fun main() {
    val nama = "Rina"
    println("Halo, $nama!")
}
''',
    'ios-dengan-swift': r'''
struct Course: Identifiable {
    let id = UUID()
    var title: String
}
''',
    'nodejs-express': r'''
const express = require('express');
const app = express();

app.get('/courses', (req, res) => {
  res.json({ courses: [] });
});
''',
    'html-css-modern': r'''
<main class="hero">
  <h1>Belajar Lebih Santai</h1>
  <p>Kuasai keterampilan baru bersama MentorinAja.</p>
</main>

<style>
  .hero {
    color: #1D2939;
    background: #FFF7ED;
    padding: 32px;
  }
</style>
''',
    'dasar-html-css': r'''
<h1>Halaman Pertamaku</h1>
<p>Ini adalah paragraf pertama saya.</p>

<style>
  h1 { color: #F97316; }
</style>
''',
    'desain-web-dengan-css': r'''
.card {
  display: grid;
  gap: 16px;
  padding: 24px;
  border: 1px solid #EAECF0;
  border-radius: 16px;
}
''',
  };
}
