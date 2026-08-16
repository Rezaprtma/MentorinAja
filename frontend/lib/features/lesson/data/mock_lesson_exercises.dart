import 'package:frontend/features/course/course.dart';

import '../domain/entities/lesson_exercise.dart';

/// Deterministic mock exercises for the Lesson Player.
///
/// Flagship courses carry hand-written exercises that match their technology;
/// the rest fall back to a generic generator that derives a completion and an
/// explanation exercise from the course snippet. Exercises rotate by lesson
/// index so every lesson ends with a hands-on challenge. A future backend
/// exercise API returns the same [LessonExercise] shape.
abstract final class MockLessonExercises {
  /// Completion challenge for the Game stage, or null when the course has no
  /// code. Curated courses always play their hand-written completion exercise.
  static LessonExercise? gameExercise(CourseDetail course, String code) {
    if (_isPlain(code)) return null;
    return _curated[course.id]?.completion ?? _genericCompletion(course, code);
  }

  /// Application exercises for the Latihan stage. Curated courses return a
  /// correction and an explanation exercise; the rest fall back to a single
  /// generic explanation. Empty when the course has no code.
  static List<LessonExercise> latihanExercises(
    CourseDetail course,
    String code,
  ) {
    if (_isPlain(code)) return const [];
    final curated = _curated[course.id];
    if (curated == null) return [_genericExplanation(course, code), _genericWriting()];
    return [curated.correction, curated.explanation, _genericWriting()];
  }

  /// Returns the exercise for [lesson], or null when the course has no code.
  static LessonExercise? forLesson(
    CourseDetail course,
    CourseLesson lesson, {
    required int index,
    required String code,
  }) {
    if (_isPlain(code)) return null;

    final curated = _curated[course.id];
    if (curated == null) {
      return index.isEven
          ? _genericCompletion(course, code)
          : _genericExplanation(course, code);
    }

    return switch (index % 3) {
      0 => curated.completion,
      1 => curated.correction,
      _ => curated.explanation,
    };
  }

  static bool _isPlain(String code) => code.trimLeft().startsWith('#');

  // -------------------------------------------------------------------------
  // Hand-written exercises per flagship course.
  // -------------------------------------------------------------------------

  static const Map<String, _CuratedExercises> _curated = {
    'dasar-python': _CuratedExercises(
      completion: LessonExercise(
        type: LessonExerciseType.codeCompletion,
        title: 'Lengkapi function hitung',
        instruction:
            'Pilih token yang tepat untuk mengisi tiap bagian yang kosong.',
        code: r'''
def hitung(____):
    total = sum(____)
    return total / len(nilai)
''',
        blanks: [
          CodeCompletionBlank(token: 'nilai'),
          CodeCompletionBlank(token: 'nilai'),
        ],
        options: ['nilai', 'total', 'print', 'len'],
        hint:
            'Baris return memakai len(nilai). Parameter function dan argumen '
            'sum() harus menunjuk daftar angka yang sama.',
        explanation:
            'Parameter nilai menerima daftar angka saat function dipanggil, '
            'lalu sum(nilai) menjumlahkannya dan len(nilai) menghitung jumlah '
            'elemennya sehingga hasilnya rata-rata.',
      ),
      correction: LessonExercise(
        type: LessonExerciseType.codeCorrection,
        title: 'Perbaiki kode berikut',
        instruction:
            'Ada satu kesalahan di kode ini. Pilih perbaikan yang tepat.',
        code: r'''
def hitung(nilai):
    total = sum(nilai)
    return total / len()
''',
        correctedCode: r'''
def hitung(nilai):
    total = sum(nilai)
    return total / len(nilai)
''',
        choices: [
          ExerciseChoice(label: 'len(nilai)', isCorrect: true),
          ExerciseChoice(label: 'len(total)', isCorrect: false),
          ExerciseChoice(label: 'sum(nilai)', isCorrect: false),
          ExerciseChoice(label: 'Tidak ada kesalahan', isCorrect: false),
        ],
        hint: 'len() butuh satu argumen: objek yang jumlah elemennya dihitung.',
        explanation:
            'Benar. len() membutuhkan objek yang ingin dihitung jumlah '
            'elemennya — di sini daftar nilai, bukan tanpa argumen.',
      ),
      explanation: LessonExercise(
        type: LessonExerciseType.codeExplanation,
        title: 'Jelaskan baris kode ini',
        instruction: 'Apa fungsi baris kode di bawah ini?',
        code: 'total = sum(nilai)',
        choices: [
          ExerciseChoice(
            label: 'Menghitung jumlah seluruh nilai',
            isCorrect: true,
          ),
          ExerciseChoice(
            label: 'Menghitung jumlah elemen nilai',
            isCorrect: false,
          ),
          ExerciseChoice(label: 'Menampilkan nilai total', isCorrect: false),
          ExerciseChoice(label: 'Menghapus data dalam nilai', isCorrect: false),
        ],
        hint: 'Fungsi sum() berhubungan dengan penjumlahan angka.',
        explanation:
            'sum(nilai) menjumlahkan semua angka dalam daftar nilai dan '
            'menyimpan hasilnya ke variabel total.',
      ),
    ),
    'javascript-modern': _CuratedExercises(
      completion: LessonExercise(
        type: LessonExerciseType.codeCompletion,
        title: 'Lengkapi arrow function',
        instruction: 'Pilih token yang tepat untuk melengkapi baris kode ini.',
        code: r'''
const angka = [1, 2, 3];
const hasil = angka.map(____ => ____ * 2);
console.log(hasil);
''',
        blanks: [
          CodeCompletionBlank(token: 'n'),
          CodeCompletionBlank(token: 'n'),
        ],
        options: ['n', 'hasil', 'angka', 'log'],
        hint:
            'map() memanggil fungsi untuk tiap elemen. Parameter menampung '
            'elemen saat ini, lalu dikalikan dua.',
        explanation:
            'map() menjalankan fungsi untuk tiap elemen. Parameter n '
            'menampung elemen saat ini, dan n * 2 menghasilkan daftar baru '
            'yang tiap angkanya dikali dua.',
      ),
      correction: LessonExercise(
        type: LessonExerciseType.codeCorrection,
        title: 'Perbaiki arrow function',
        instruction:
            'Syntax arrow function-nya salah. Pilih perbaikan yang benar.',
        code: r'''
const angka = [1, 2, 3];
const hasil = angka.map(n -> n * 2);
''',
        correctedCode: r'''
const angka = [1, 2, 3];
const hasil = angka.map(n => n * 2);
''',
        choices: [
          ExerciseChoice(label: 'n => n * 2', isCorrect: true),
          ExerciseChoice(label: 'n -> n * 2', isCorrect: false),
          ExerciseChoice(label: 'n = n * 2', isCorrect: false),
          ExerciseChoice(label: 'n >= n * 2', isCorrect: false),
        ],
        hint: 'Arrow function memakai tanda sama-dengan dan lebih besar.',
        explanation:
            'Benar. Arrow function memakai => untuk menghubungkan parameter '
            'dengan isi fungsi, bukan ->.',
      ),
      explanation: LessonExercise(
        type: LessonExerciseType.codeExplanation,
        title: 'Jelaskan hasil kode ini',
        instruction: 'Apa yang dihasilkan variabel hasil?',
        code: 'const hasil = angka.map(n => n * 2);',
        choices: [
          ExerciseChoice(
            label: 'Daftar baru yang tiap angkanya dikali dua',
            isCorrect: true,
          ),
          ExerciseChoice(
            label: 'Daftar angka asli tanpa perubahan',
            isCorrect: false,
          ),
          ExerciseChoice(
            label: 'Satu angka hasil penjumlahan',
            isCorrect: false,
          ),
          ExerciseChoice(label: 'Daftar angka yang dihapus', isCorrect: false),
        ],
        hint:
            'map() selalu mengembalikan daftar baru dengan panjang yang sama.',
        explanation:
            'map() menghasilkan daftar baru. Setiap angka asli dipetakan '
            'menjadi n * 2, jadi hasil adalah [2, 4, 6].',
      ),
    ),
    'mysql-dasar': _CuratedExercises(
      completion: LessonExercise(
        type: LessonExerciseType.codeCompletion,
        title: 'Lengkapi query agregasi',
        instruction:
            'Pilih alias yang tepat agar hasil query memiliki nama kolom.',
        code: r'''
SELECT kategori, COUNT(*) AS ____
FROM courses
GROUP BY kategori;
''',
        blanks: [CodeCompletionBlank(token: 'jumlah_course')],
        options: ['jumlah_course', 'kursus', 'sum', 'where'],
        hint:
            'AS memberi nama pada hasil hitungan. Nama itu dipakai untuk '
            'menyebut kolom hasilnya.',
        explanation:
            'Alias jumlah_course memberi nama pada hasil COUNT(*), sehingga '
            'kolom hasilnya mudah dibaca dan dipakai pada query lanjutan.',
      ),
      correction: LessonExercise(
        type: LessonExerciseType.codeCorrection,
        title: 'Perbaiki query SELECT',
        instruction: 'Query ini error. Pilih perbaikan yang benar.',
        code: r'''
SELECT kategori COUNT(*) FROM courses;
''',
        correctedCode: r'''
SELECT kategori, COUNT(*) FROM courses;
''',
        choices: [
          ExerciseChoice(
            label: 'SELECT kategori, COUNT(*) FROM courses;',
            isCorrect: true,
          ),
          ExerciseChoice(
            label: 'SELECT kategori COUNT(*) FROM courses;',
            isCorrect: false,
          ),
          ExerciseChoice(
            label: 'SELECT kategori, COUNT(*), FROM courses;',
            isCorrect: false,
          ),
          ExerciseChoice(
            label: 'SELECT kategori COUNT(*), FROM courses;',
            isCorrect: false,
          ),
        ],
        hint: 'Kolom dalam klausa SELECT dipisahkan oleh tanda koma.',
        explanation:
            'Benar. Setiap kolom dalam SELECT harus dipisahkan koma. Setelah '
            'kategori wajib ada tanda koma sebelum COUNT(*).',
      ),
      explanation: LessonExercise(
        type: LessonExerciseType.codeExplanation,
        title: 'Jelaskan query ini',
        instruction: 'Apa yang dilakukan query berikut?',
        code: 'SELECT COUNT(*) FROM courses;',
        choices: [
          ExerciseChoice(
            label: 'Menghitung jumlah baris pada tabel courses',
            isCorrect: true,
          ),
          ExerciseChoice(
            label: 'Menghapus semua baris pada tabel courses',
            isCorrect: false,
          ),
          ExerciseChoice(
            label: 'Menampilkan semua isi tabel courses',
            isCorrect: false,
          ),
          ExerciseChoice(label: 'Menjumlahkan kolom courses', isCorrect: false),
        ],
        hint: 'COUNT(*) menghitung baris, bukan memilih datanya.',
        explanation:
            'COUNT(*) menghitung jumlah baris yang cocok — di sini seluruh '
            'baris tabel courses.',
      ),
    ),
    'flutter-untuk-pemula': _CuratedExercises(
      completion: LessonExercise(
        type: LessonExerciseType.codeCompletion,
        title: 'Lengkapi class CourseCard',
        instruction: 'Pilih nama field yang tepat untuk menerima judul course.',
        code: r'''
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.title});

  final String ____;

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(____));
  }
}
''',
        blanks: [
          CodeCompletionBlank(token: 'title'),
          CodeCompletionBlank(token: 'title'),
        ],
        options: ['title', 'widget', 'context', 'string'],
        hint:
            'Constructor menggunakan this.title, jadi field harus bernama '
            'sama.',
        explanation:
            'Field title menyimpan judul yang dikirim lewat constructor, lalu '
            'Text(title) menampilkannya di dalam Card.',
      ),
      correction: LessonExercise(
        type: LessonExerciseType.codeCorrection,
        title: 'Perbaiki method build',
        instruction: 'Ada satu kesalahan tipe pada method build. Perbaiki.',
        code: r'''
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.title});

  final String title;

  @override
  Widget build(context) {
    return Card(child: Text(title));
  }
}
''',
        correctedCode: r'''
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(title));
  }
}
''',
        choices: [
          ExerciseChoice(label: 'build(BuildContext context)', isCorrect: true),
          ExerciseChoice(label: 'build(BuildContext)', isCorrect: false),
          ExerciseChoice(label: 'build(context)', isCorrect: false),
          ExerciseChoice(label: 'build()', isCorrect: false),
        ],
        hint:
            'Method build memerlukan parameter context yang bertipe BuildContext.',
        explanation:
            'Benar. build wajib menerima BuildContext context — tipe yang '
            'hilang pada kode awal.',
      ),
      explanation: LessonExercise(
        type: LessonExerciseType.codeExplanation,
        title: 'Jelaskan baris ini',
        instruction: 'Apa yang dilakukan baris kode berikut?',
        code: 'return Card(child: Text(title));',
        choices: [
          ExerciseChoice(
            label: 'Membuat kartu yang menampilkan teks title',
            isCorrect: true,
          ),
          ExerciseChoice(
            label: 'Menghapus kartu dan teksnya',
            isCorrect: false,
          ),
          ExerciseChoice(
            label: 'Menyimpan title ke penyimpanan',
            isCorrect: false,
          ),
          ExerciseChoice(
            label: 'Menampilkan dialog konfirmasi',
            isCorrect: false,
          ),
        ],
        hint: 'Card dan Text adalah widget yang digabungkan sebagai anak.',
        explanation:
            'Baris ini membangun widget Card yang berisi Text(title), jadi '
            'judul course tampil di dalam kartu.',
      ),
    ),
    'html-css-modern': _CuratedExercises(
      completion: LessonExercise(
        type: LessonExerciseType.codeCompletion,
        title: 'Lengkapi properti CSS',
        instruction: 'Pilih properti yang tepat untuk mengubah warna teks.',
        code: r'''
<style>
  .hero {
    ____: #F97316;
    padding: 32px;
  }
</style>
''',
        blanks: [CodeCompletionBlank(token: 'color')],
        options: ['color', 'text', 'style', 'font'],
        hint: 'Properti warna teks pada CSS dimulai huruf c.',
        explanation:
            'color mengatur warna teks elemen. padding: 32px memberi ruang '
            'di dalam elemen.',
      ),
      correction: LessonExercise(
        type: LessonExerciseType.codeCorrection,
        title: 'Perbaiki tag HTML',
        instruction: 'Ada tag yang tidak ditutup dengan benar. Perbaiki.',
        code: '<p>Ini adalah paragraf pertama.<p>',
        correctedCode: '<p>Ini adalah paragraf pertama.</p>',
        choices: [
          ExerciseChoice(
            label: '<p>Ini adalah paragraf pertama.</p>',
            isCorrect: true,
          ),
          ExerciseChoice(
            label: '<p>Ini adalah paragraf pertama.<p>',
            isCorrect: false,
          ),
          ExerciseChoice(
            label: '<p>Ini adalah paragraf pertama.</p></p>',
            isCorrect: false,
          ),
          ExerciseChoice(
            label: '<p>Ini adalah paragraf pertama.<p/>',
            isCorrect: false,
          ),
        ],
        hint: 'Tag pembuka <p> harus ditutup dengan </p>.',
        explanation:
            'Benar. Setiap tag pembuka <p> harus ditutup dengan </p>. '
            '<p> kedua di kode awal tidak pernah ditutup.',
      ),
      explanation: LessonExercise(
        type: LessonExerciseType.codeExplanation,
        title: 'Jelaskan properti ini',
        instruction: 'Apa efek dari properti padding: 32px?',
        code: 'padding: 32px;',
        choices: [
          ExerciseChoice(
            label: 'Memberi ruang di dalam elemen',
            isCorrect: true,
          ),
          ExerciseChoice(
            label: 'Memberi ruang di luar elemen',
            isCorrect: false,
          ),
          ExerciseChoice(
            label: 'Mengubah warna latar elemen',
            isCorrect: false,
          ),
          ExerciseChoice(
            label: 'Mengubah ukuran teks elemen',
            isCorrect: false,
          ),
        ],
        hint: 'padding berbeda dengan margin.',
        explanation:
            'padding menambah ruang di dalam elemen, antara isi dan tepinya. '
            'Ruang di luar elemen adalah tugas margin.',
      ),
    ),
  };

  // -------------------------------------------------------------------------
  // Generic generator for courses without hand-written exercises.
  // -------------------------------------------------------------------------

  static LessonExercise _genericCompletion(CourseDetail course, String code) {
    final blanked = _pickIdentifier(code);
    final target = blanked ?? 'hasil';
    final base = blanked == null
        ? code
        : code.replaceAll(RegExp('\\b${RegExp.escape(target)}\\b'), '____');

    final distractors = const [
      'print',
      'hasil',
      'total',
    ].where((other) => other != target).take(3);
    final options = [target, ...distractors];

    return LessonExercise(
      type: LessonExerciseType.codeCompletion,
      title: 'Lengkapi kode berikut',
      instruction: 'Pilih token yang tepat untuk melengkapi kode di bawah ini.',
      code: base,
      blanks: [CodeCompletionBlank(token: target)],
      options: options,
      hint: 'Perhatikan bagaimana $target dipakai di baris lain kode ini.',
      explanation:
          'Kode ini memakai $target untuk menyimpan nilai yang diolah dalam '
          'course ${course.title}.',
    );
  }

  static String? _pickIdentifier(String code) {
    for (final line in code.split('\n').reversed) {
      final trimmed = line.trim();
      if (trimmed.isEmpty ||
          trimmed.startsWith('#') ||
          trimmed.startsWith('//')) {
        continue;
      }
      final declaration = RegExp(
        r'\b(val|var|let|const|final)\s+([A-Za-z_]\w*)',
      ).firstMatch(trimmed);
      if (declaration != null) return declaration.group(2);
      final dollar = RegExp(r'\$([A-Za-z_]\w*)').firstMatch(trimmed);
      if (dollar != null) return dollar.group(1);
      final words = RegExp(r'\b([A-Za-z_]\w*)\b').allMatches(trimmed).toList();
      if (words.isEmpty) continue;
      final candidate = words.last.group(1)!;
      if (const {
        'print',
        'echo',
        'return',
        'SELECT',
        'FROM',
        'for',
        'foreach',
        'if',
        'else',
      }.contains(candidate)) {
        continue;
      }
      return candidate;
    }
    return null;
  }

  static LessonExercise _genericExplanation(CourseDetail course, String code) {
    final line = code
        .split('\n')
        .reversed
        .map((l) => l.trim())
        .firstWhere(
          (l) => l.isNotEmpty && !l.startsWith('#') && !l.startsWith('//'),
          orElse: () => '',
        );

    return LessonExercise(
      type: LessonExerciseType.codeExplanation,
      title: 'Jelaskan baris kode ini',
      instruction: 'Apa yang dilakukan baris kode berikut?',
      code: line.isEmpty ? code : line,
      choices: const [
        ExerciseChoice(
          label: 'Menjalankan perintah yang ditulis pada baris ini',
          isCorrect: true,
        ),
        ExerciseChoice(label: 'Menghentikan program', isCorrect: false),
        ExerciseChoice(
          label: 'Menampilkan error pada program',
          isCorrect: false,
        ),
        ExerciseChoice(label: 'Menyimpan data ke database', isCorrect: false),
      ],
      hint: 'Perhatikan kata kunci yang dipakai di awal baris.',
      explanation:
          'Baris ini mengeksekusi operasi yang didefinisikannya: '
          '${line.isEmpty ? 'kode pada pelajaran ini' : line} adalah bagian '
          'dari alur program yang sedang kamu pelajari.',
    );
  }

  static LessonExercise _genericWriting() {
    return const LessonExercise(
      type: LessonExerciseType.codeWriting,
      gameType: GameType.codeOrdering,
      title: 'Urutkan kode berikut',
      instruction: 'Susun potongan kode agar menampilkan pesan "Hello World".',
      code: 'print("Hello World")',
      options: ['world")', 'print("', 'Hello '],
      correctOrder: [1, 2, 0],
      hint: 'Fungsi print diawali dengan nama fungsi lalu tanda kurung buka.',
      explanation:
          'Susunan yang benar adalah print(" lalu Hello lalu world") agar '
          'membentuk perintah print("Hello world").',
    );
  }
}

/// Hand-written exercise set for one course.
class _CuratedExercises {
  const _CuratedExercises({
    required this.completion,
    required this.correction,
    required this.explanation,
  });

  final LessonExercise completion;
  final LessonExercise correction;
  final LessonExercise explanation;
}
