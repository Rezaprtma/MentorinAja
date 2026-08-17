import '../domain/entities/tutor_message.dart';
import '../domain/repositories/tutor_repository.dart';

/// Local deterministic tutor replies used until the backend AI service exists.
///
/// Keyword detection keeps the seam deterministic: "error" explains a likely
/// mistake, "contoh/kode" returns a short code sample relevant to the course,
/// "petunjuk" gives a nudge, and everything else gets a conceptual answer.
class MockTutorRepository implements TutorRepository {
  const MockTutorRepository();

  @override
  Future<TutorMessage> reply({
    required TutorLessonContext context,
    required String message,
  }) {
    final normalized = message.toLowerCase();

    if (normalized.contains('error')) {
      return Future.value(
        TutorMessage(
          role: TutorMessageRole.assistant,
          text:
              'Kita lihat pelan-pelan di pelajaran ${context.lessonTitle}. '
              'Biasanya error muncul karena bagian kode menerima nilai yang '
              'belum lengkap. Cek argumen function atau tanda kurungnya dulu.',
          createdAt: DateTime.now(),
        ),
      );
    }

    if (normalized.contains('contoh') ||
        normalized.contains('kode') ||
        normalized.contains('code')) {
      final (label, code) = _codeSample(context.courseId);
      return Future.value(
        TutorMessage(
          role: TutorMessageRole.assistant,
          text:
              'Tentu, ini contoh singkat yang relevan dengan ${context.lessonTitle}:',
          code: code,
          codeLabel: label,
          createdAt: DateTime.now(),
        ),
      );
    }

    if (normalized.contains('petunjuk') || normalized.contains('hint')) {
      return Future.value(
        TutorMessage(
          role: TutorMessageRole.assistant,
          text:
              'Petunjuknya: cari variabel yang dipakai berulang. Kalau baris '
              'berikutnya memakai nama yang sama, bagian tadi kemungkinan '
              'harus diisi token itu.',
          createdAt: DateTime.now(),
        ),
      );
    }

    return Future.value(
      TutorMessage(
        role: TutorMessageRole.assistant,
        text:
            'Untuk ${context.lessonTitle}, fokusnya adalah memahami hubungan '
            'antar baris kode. Baca satu baris, tanyakan: data apa yang masuk, '
            'operasi apa yang terjadi, dan hasilnya disimpan di mana.',
        createdAt: DateTime.now(),
      ),
    );
  }

  (String, String) _codeSample(String courseId) {
    return switch (courseId) {
      'javascript-modern' => (
        'JavaScript',
        '''const materi = ['Python', 'JavaScript', 'SQL'];
const hasil = materi.map((item) => `Kursus: \${item}`);
console.log(hasil);''',
      ),
      'mysql-dasar' => (
        'SQL',
        '''SELECT kategori, COUNT(*) AS jumlah_course
FROM courses
GROUP BY kategori
ORDER BY jumlah_course DESC;''',
      ),
      'flutter-untuk-pemula' => (
        'Dart',
        '''class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(title));
  }
}''',
      ),
      _ => (
        'Python',
        '''def hitung_rata_rata(nilai):
    total = sum(nilai)
    return total / len(nilai)

nilai = [85, 92, 78, 96]
print(f"Rata-rata: {hitung_rata_rata(nilai):.1f}")''',
      ),
    };
  }
}
