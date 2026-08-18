//**
// frontend/features/lesson/data/mock_module_content_generator.dart
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

import '../domain/entities/lesson_exercise.dart';

class MockModuleContentGenerator {
  const MockModuleContentGenerator._();

  static List<LessonExercise> generateGames({
    required String lessonId,
    required String title,
    String language = 'Python',
  }) {
    final normalized = title.toLowerCase();

    if (normalized.contains('hello') || normalized.contains('cetak')) {
      return _helloWorldGames(language);
    }
    if (normalized.contains('variabel') ||
        normalized.contains('variable') ||
        normalized.contains('tipe data')) {
      return _variableGames(language);
    }
    if (normalized.contains('cabang') ||
        normalized.contains('kondisi') ||
        normalized.contains('if')) {
      return _conditionalGames(language);
    }
    if (normalized.contains('ulang') ||
        normalized.contains('loop') ||
        normalized.contains('for')) {
      return _loopGames(language);
    }

    return _genericGames(title, language);
  }

  static LessonExercise generateExercise({
    required String lessonId,
    required String title,
    String language = 'Python',
  }) {
    final normalized = title.toLowerCase();

    if (normalized.contains('hello') || normalized.contains('cetak')) {
      return LessonExercise(
        type: LessonExerciseType.codeWriting,
        title: 'Cetak Teks',
        instruction: 'Tulis kode $language untuk mencetak teks "Hello World".',
        expectedAnswer: language.toLowerCase() == 'javascript'
            ? 'console.log("Hello World")'
            : 'print("Hello World")',
        hint: 'Gunakan fungsi cetak bawaan bahasa tersebut.',
        explanation: 'Fungsi cetak menampilkan teks ke output standar.',
      );
    }
    if (normalized.contains('variabel') || normalized.contains('tipe data')) {
      return LessonExercise(
        type: LessonExerciseType.codeWriting,
        title: 'Deklarasi Variabel',
        instruction: 'Buat variabel bernama "umur" bernilai integer 20.',
        expectedAnswer: language.toLowerCase() == 'javascript'
            ? 'let umur = 20'
            : 'umur = 20',
        hint: 'Tulis nama variabel diikuti tanda sama dengan dan nilainya.',
        explanation: 'Variabel digunakan untuk menyimpan data.',
      );
    }
    if (normalized.contains('cabang') ||
        normalized.contains('kondisi') ||
        normalized.contains('if')) {
      return LessonExercise(
        type: LessonExerciseType.codeWriting,
        title: 'Ganjil Genap',
        instruction:
            'Tulis program percabangan untuk memeriksa jika variabel x genap maka cetak "Genap".',
        expectedAnswer: language.toLowerCase() == 'javascript'
            ? 'if (x % 2 === 0) {\n  console.log("Genap")\n}'
            : 'if x % 2 == 0:\n    print("Genap")',
        hint: 'Gunakan operator modulus (%) dan kondisi if.',
        explanation: 'Kondisi if memeriksa suatu ekspresi boolean.',
      );
    }

    return LessonExercise(
      type: LessonExerciseType.codeWriting,
      title: 'Perulangan Segitiga',
      instruction: 'Tulis perulangan untuk mencetak angka 1 sampai 3.',
      expectedAnswer: language.toLowerCase() == 'javascript'
          ? 'for (let i = 1; i <= 3; i++) {\n  console.log(i)\n}'
          : 'for i in range(1, 4):\n    print(i)',
      hint: 'Gunakan perulangan for.',
      explanation: 'Perulangan mengeksekusi blok kode berulang kali.',
    );
  }

  static List<LessonExercise> _helloWorldGames(String language) {
    final printFn = language.toLowerCase() == 'javascript'
        ? 'console.log'
        : 'print';
    return [
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.codeOrdering,
        instruction: 'Susun kode agar mencetak "Hello".',
        options: [printFn, '(', '"Hello"', ')'],
        correctOrder: const [0, 1, 2, 3],
        explanation:
            'Urutan pemanggilan fungsi cetak dimulai dari nama fungsi, kurung buka, argumen, lalu kurung tutup.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.multipleChoice,
        instruction: 'Fungsi manakah yang digunakan untuk mencetak teks?',
        choices: [
          ExerciseChoice(label: '$printFn()', isCorrect: true),
          const ExerciseChoice(label: 'input()', isCorrect: false),
          const ExerciseChoice(label: 'read()', isCorrect: false),
        ],
        explanation: 'Fungsi $printFn() adalah keluaran teks standar.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.tokenCompletion,
        instruction: 'Lengkapi kode untuk mencetak "Dunia".',
        code: '____("Dunia")',
        blanks: [CodeCompletionBlank(token: printFn)],
        options: [printFn, 'echo', 'log'],
        explanation: 'Fungsi $printFn digunakan untuk mencetak di $language.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.outputPrediction,
        instruction: 'Berapakah output dari kode berikut?',
        code: '$printFn(3 + 4)',
        expectedAnswer: '7',
        explanation: 'Evaluasi ekspresi matematika 3 + 4 adalah 7.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.identifyError,
        instruction: 'Di mana kesalahan kode berikut?',
        code: '$printFn(Hello)',
        choices: const [
          ExerciseChoice(
            label: 'Teks "Hello" tidak memiliki tanda kutip',
            isCorrect: true,
          ),
          ExerciseChoice(
            label: 'Kurung buka tidak diperlukan',
            isCorrect: false,
          ),
          ExerciseChoice(
            label: 'Kurung tutup tidak diperlukan',
            isCorrect: false,
          ),
        ],
        explanation: 'String literal harus selalu menggunakan tanda kutip.',
      ),
    ];
  }

  static List<LessonExercise> _variableGames(String language) {
    final isJs = language.toLowerCase() == 'javascript';
    return [
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.tokenCompletion,
        instruction: 'Lengkapi untuk menetapkan nilai 10 ke variabel x.',
        code: '${isJs ? 'let ' : ''}x ____ 10',
        blanks: const [CodeCompletionBlank(token: '=')],
        options: const ['=', '==', 'equals'],
        explanation:
            'Operator penugasan (=) menetapkan nilai di kanan ke variabel di kiri.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.outputPrediction,
        instruction: 'Berapa nilai y di akhir program?',
        code: 'x = 5\ny = x + 2',
        expectedAnswer: '7',
        explanation: 'x bernilai 5, sehingga y = 5 + 2 = 7.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.identifyError,
        instruction: 'Temukan kesalahan pada deklarasi berikut.',
        code: '1st_number = 100',
        choices: const [
          ExerciseChoice(
            label: 'Nama variabel tidak boleh diawali dengan angka',
            isCorrect: true,
          ),
          ExerciseChoice(label: 'Nilai 100 terlalu besar', isCorrect: false),
          ExerciseChoice(
            label: 'Tanda sama dengan harus ganda',
            isCorrect: false,
          ),
        ],
        explanation:
            'Nama variabel harus diawali dengan huruf atau garis bawah, tidak boleh angka.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.codeOrdering,
        instruction: 'Susun kode untuk mendeklarasikan dan mencetak variabel.',
        options: isJs
            ? const ['let y = 15;', 'console.log(', 'y', ');']
            : const ['y = 15', 'print(', 'y', ')'],
        correctOrder: const [0, 1, 2, 3],
        explanation:
            'Variabel harus dideklarasikan terlebih dahulu sebelum dibaca/dicetak.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.multipleChoice,
        instruction: 'Tipe data apakah nilai "Halo"?',
        choices: const [
          ExerciseChoice(label: 'String', isCorrect: true),
          ExerciseChoice(label: 'Integer', isCorrect: false),
          ExerciseChoice(label: 'Float', isCorrect: false),
        ],
        explanation: 'Setiap nilai yang diapit tanda kutip adalah String.',
      ),
    ];
  }

  static List<LessonExercise> _conditionalGames(String language) {
    final isJs = language.toLowerCase() == 'javascript';
    return [
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.tokenCompletion,
        instruction: 'Lengkapi kondisi if berikut.',
        code: 'x = 10\nif x ____ 10:\n    print("Sama")',
        blanks: const [CodeCompletionBlank(token: '==')],
        options: const ['==', '=', 'equals'],
        explanation: 'Operator perbandingan kesetaraan adalah ==.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.outputPrediction,
        instruction: 'Apa output kode berikut?',
        code: 'x = 3\nif x > 5:\n    print("A")\nelse:\n    print("B")',
        expectedAnswer: 'B',
        explanation:
            'Kondisi 3 > 5 salah, sehingga mengeksekusi blok else ("B").',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.identifyError,
        instruction: 'Temukan kesalahan sintaks berikut.',
        code: isJs ? 'if x = 5 {}' : 'if x == 5\n    print(x)',
        choices: isJs
            ? const [
                ExerciseChoice(
                  label:
                      'Menggunakan operator penugasan (=) bukan perbandingan (==)',
                  isCorrect: true,
                ),
                ExerciseChoice(
                  label: 'Kurung kurawal tidak diperlukan',
                  isCorrect: false,
                ),
              ]
            : const [
                ExerciseChoice(
                  label: 'Kurang tanda titik dua (:) di akhir baris if',
                  isCorrect: true,
                ),
                ExerciseChoice(
                  label: 'Indentasi print salah',
                  isCorrect: false,
                ),
              ],
        explanation: isJs
            ? 'Kondisi if memerlukan perbandingan (==).'
            : 'Sintaks if di Python mewajibkan tanda titik dua (:).',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.multipleChoice,
        instruction: 'Operator apa yang digunakan untuk logika AND?',
        choices: isJs
            ? const [
                ExerciseChoice(label: '&&', isCorrect: true),
                ExerciseChoice(label: 'and', isCorrect: false),
                ExerciseChoice(label: '&', isCorrect: false),
              ]
            : const [
                ExerciseChoice(label: 'and', isCorrect: true),
                ExerciseChoice(label: '&&', isCorrect: false),
                ExerciseChoice(label: '&', isCorrect: false),
              ],
        explanation: 'Logika AND bernilai benar jika kedua kondisi benar.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.codeOrdering,
        instruction: 'Susun struktur percabangan sederhana.',
        options: isJs
            ? const [
                'if (x > 0) {',
                '  console.log("Positif");',
                '} else {',
                '  console.log("Nol/Negatif");',
                '}',
              ]
            : const [
                'if x > 0:',
                '    print("Positif")',
                'else:',
                '    print("Nol/Negatif")',
                '',
              ],
        correctOrder: const [0, 1, 2, 3, 4],
        explanation:
            'Alur program memeriksa kondisi if dahulu baru kemudian block else.',
      ),
    ];
  }

  static List<LessonExercise> _loopGames(String language) {
    final isJs = language.toLowerCase() == 'javascript';
    return [
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.tokenCompletion,
        instruction: 'Lengkapi perulangan range.',
        code: isJs ? 'for (let i = 0; i < 3; ____) {}' : 'for i in ____(3):',
        blanks: [CodeCompletionBlank(token: isJs ? 'i++' : 'range')],
        options: [isJs ? 'i++' : 'range', isJs ? 'i+1' : 'list', 'loop'],
        explanation: 'Mengontrol iterasi perulangan.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.outputPrediction,
        instruction: 'Berapa kali perulangan ini dieksekusi?',
        code: isJs
            ? 'let count = 0;\nwhile (count < 3) {\n  count++;\n}'
            : 'count = 0\nwhile count < 3:\n    count += 1',
        expectedAnswer: '3',
        explanation:
            'Iterasi berjalan saat count = 0, 1, dan 2. Ketika count = 3, perulangan berhenti.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.identifyError,
        instruction: 'Apa bahaya dari kode perulangan berikut?',
        code: 'while True:\n    print("Ulang")',
        choices: const [
          ExerciseChoice(
            label: 'Menyebabkan perulangan tak terbatas (infinite loop)',
            isCorrect: true,
          ),
          ExerciseChoice(
            label: 'Tidak akan dieksekusi sama sekali',
            isCorrect: false,
          ),
          ExerciseChoice(label: 'Sintaksnya error', isCorrect: false),
        ],
        explanation:
            'Karena kondisi bernilai True terus, perulangan tidak akan pernah berhenti.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.multipleChoice,
        instruction:
            'Keyword apa yang digunakan untuk menghentikan perulangan lebih awal?',
        choices: const [
          ExerciseChoice(label: 'break', isCorrect: true),
          ExerciseChoice(label: 'stop', isCorrect: false),
          ExerciseChoice(label: 'continue', isCorrect: false),
        ],
        explanation:
            'Keyword break keluar dari perulangan, sedangkan continue melanjutkan ke iterasi berikutnya.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.codeOrdering,
        instruction: 'Susun perulangan agar mencetak 0 dan 1.',
        options: isJs
            ? const ['for (let i = 0; i < 2; i++) {', '  console.log(i);', '}']
            : const ['for i in range(2):', '    print(i)', ''],
        correctOrder: const [0, 1, 2],
        explanation:
            'Menyusun perulangan for dengan range 2 mencetak 0 lalu 1.',
      ),
    ];
  }

  static List<LessonExercise> _genericGames(String topic, String language) {
    final printFn = language.toLowerCase() == 'javascript'
        ? 'console.log'
        : 'print';
    return [
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.codeOrdering,
        instruction: 'Susun kode berikut terkait topik $topic.',
        options: [printFn, '(', '"$topic"', ')'],
        correctOrder: const [0, 1, 2, 3],
        explanation: 'Menyusun perintah cetak untuk materi $topic.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.multipleChoice,
        instruction: 'Bahasa pemrograman yang digunakan saat ini adalah?',
        choices: [
          ExerciseChoice(label: language, isCorrect: true),
          const ExerciseChoice(label: 'Assembly', isCorrect: false),
          const ExerciseChoice(label: 'Binary', isCorrect: false),
        ],
        explanation: 'Topik ini dipelajari menggunakan bahasa $language.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.tokenCompletion,
        instruction: 'Lengkapi kode untuk topik $topic.',
        code: '____("$topic")',
        blanks: [CodeCompletionBlank(token: printFn)],
        options: [printFn, 'echo', 'log'],
        explanation: 'Cetak pesan terkait $topic.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.outputPrediction,
        instruction: 'Berapa hasil dari 5 + 5?',
        code: '$printFn(5 + 5)',
        expectedAnswer: '10',
        explanation: 'Evaluasi matematika sederhana 5 + 5 adalah 10.',
      ),
      LessonExercise(
        type: LessonExerciseType.codeCompletion,
        gameType: GameType.identifyError,
        instruction: 'Periksa jika kode cetak $topic memiliki kesalahan.',
        code: '$printFn("$topic"',
        choices: const [
          ExerciseChoice(label: 'Kurang tanda kurung tutup )', isCorrect: true),
          ExerciseChoice(
            label: 'Teks tidak boleh pakai kutip ganda',
            isCorrect: false,
          ),
        ],
        explanation:
            'Kurung buka harus selalu dipasangkan dengan kurung tutup.',
      ),
    ];
  }
}
