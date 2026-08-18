//**
// frontend/features/course/data/mock_course_catalog.dart
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
import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/shared/data/tech_brand_colors.dart';

import '../domain/entities/course_detail.dart';
import '../domain/entities/course_lesson.dart';

abstract final class MockCourseCatalog {
  static final List<CourseDetail> courses = <CourseDetail>[
    CourseDetail(
      id: 'dasar-python',
      title: 'Dasar Python',
      category: 'Pemrograman',
      shortDescription: 'Pelajari sintaks dan konsep dasar Python.',
      description:
          'Course ini membangun fondasi pemrograman Python dari nol: mulai dari '
          'pengenalan bahasa, variabel, alur kontrol, hingga function dan '
          'konsep object-oriented. Setiap bab disertai latihan langsung sehingga '
          'kamu tidak hanya membaca, tetapi juga menulis kode.',
      learningOutcomes: const [
        'Memahami dasar Python',
        'Menggunakan variable dan data type',
        'Menggunakan conditional',
        'Menggunakan loop',
        'Membuat function',
      ],
      lessons: _lessons(
        const [
          'Pengenalan Python',
          'Instalasi dan Setup',
          'Variable dan Data Type',
          'String dan Formatting',
          'Operator dan Ekspresi',
          'Conditional (if/else)',
          'Loop (for & while)',
          'List dan Tuple',
          'Dictionary dan Set',
          'Function Dasar',
          'Function Parameters',
          'Scope dan Closure',
          'Modularitas dan Import',
          'Error Handling',
          'File Input & Output',
          'Object-Oriented Python',
          'Class dan Instance',
          'Inheritance',
          'Proyek: Kalkulator CLI',
          'Proyek: Analisis Data Dasar',
        ],
        completed: 12,
        current: 12,
      ),
      iconPath: AppIconPaths.techPython,
      brand: const TechBrandColors(
        background: Color(0xFFE8F0FE),
        accent: Color(0xFF3776AB),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.9,
      level: 'Pemula',
      studentCount: 18240,
      estimatedMinutes: 460,
      progress: 0.72,
    ),
    CourseDetail(
      id: 'javascript-modern',
      title: 'JavaScript Modern',
      category: 'Frontend',
      shortDescription: 'Bangun interaksi web dengan JavaScript.',
      description:
          'JavaScript Modern memandu kamu dari sintaks dasar menuju pola '
          'pemrograman kontemporer: array methods, manipulasi DOM, dan '
          'asynchronous JavaScript. Course ini menekankan praktik langsung '
          'dengan studi kasus web interaktif.',
      learningOutcomes: const [
        'Menulis sintaks JavaScript modern',
        'Mengolah data dengan array methods',
        'Memahami scope dan closure',
        'Menggunakan Promise dan async/await',
        'Memanipulasi DOM secara efisien',
      ],
      lessons: _lessons(
        const [
          'Pengenalan JavaScript',
          'Variable dan Tipe Data',
          'Operator dan Ekspresi',
          'Conditional',
          'Loop dan Iterasi',
          'Function dan Arrow Function',
          'Array Dasar',
          'Array Methods',
          'Object dan JSON',
          'DOM Manipulation',
          'Event Handling',
          'Scope dan Closure',
          'Asynchronous JavaScript',
          'Promise dan Async/Await',
          'Fetch API',
          'Modul dan Import',
          'Proyek: To-Do App',
          'Proyek: Data Viewer',
        ],
        completed: 8,
        current: 8,
      ),
      iconPath: AppIconPaths.techJavascript,
      brand: const TechBrandColors(
        background: Color(0xFFFFF9E0),
        accent: Color(0xFFF7DF1E),
        onAccent: Color(0xFF3D3200),
      ),
      rating: 4.8,
      level: 'Pemula',
      studentCount: 14980,
      estimatedMinutes: 420,
      progress: 0.45,
    ),
    CourseDetail(
      id: 'mysql-dasar',
      title: 'MySQL Dasar',
      category: 'Database',
      shortDescription: 'Pelajari database dan query SQL.',
      description:
          'Kuasai dasar database relasional dengan MySQL: struktur tabel, query '
          'SELECT, filtering, agregasi, hingga join. Course ini dirancang untuk '
          'pemula yang ingin memahami bagaimana data aplikasi disimpan dan '
          'diambil secara efisien.',
      learningOutcomes: const [
        'Memahami konsep database relasional',
        'Membuat dan mengelola tabel',
        'Menulis query SELECT yang benar',
        'Menggunakan filter, sorting, dan agregasi',
        'Menggabungkan tabel dengan JOIN',
      ],
      lessons: _lessons(
        const [
          'Pengenalan Database',
          'Instalasi MySQL',
          'Struktur Tabel dan Tipe Data',
          'Query Dasar (SELECT)',
          'Filtering Data',
          'Sorting dan Limit',
          'Fungsi Agregat',
          'Join Antar Tabel',
          'Subquery',
          'Index dan Performa',
          'Transaction',
          'Stored Procedure',
          'Backup dan Restore',
          'Security dan User',
          'Proyek: CRUD Sederhana',
          'Proyek: Analisis Data',
        ],
        completed: 4,
        current: 4,
      ),
      iconPath: AppIconPaths.techMysql,
      brand: const TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF00758F),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.9,
      level: 'Pemula',
      studentCount: 22140,
      estimatedMinutes: 400,
      progress: 0.28,
    ),
    CourseDetail(
      id: 'laravel-untuk-pemula',
      title: 'Laravel untuk Pemula',
      category: 'Backend',
      shortDescription: 'Kembangkan aplikasi web dengan Laravel.',
      description:
          'Bangun aplikasi web modern menggunakan framework Laravel. Course ini '
          'menuntun kamu dari instalasi, routing, controller, dan Blade template, '
          'hingga Eloquent ORM dan autentikasi — dengan satu proyek nyata di '
          'akhir perjalanan.',
      learningOutcomes: const [
        'Menginstal dan mengonfigurasi Laravel',
        'Membangun routing dan controller',
        'Membuat tampilan dengan Blade template',
        'Menggunakan Eloquent ORM dan migration',
        'Membangun autentikasi dasar',
      ],
      lessons: _lessons(
        const [
          'Pengenalan Laravel',
          'Instalasi Laravel',
          'Struktur Proyek',
          'Routing Dasar',
          'Controller',
          'Blade Template',
          'Model dan Migration',
          'Eloquent ORM',
          'Validasi Form',
          'Authentication',
          'API Dasar',
          'Proyek: Membuat Proyek Pertama',
          'Proyek: CRUD Blog',
          'Deployment Dasar',
          'Best Practices',
        ],
        completed: 15,
        current: -1,
      ),
      iconPath: AppIconPaths.techLaravel,
      brand: const TechBrandColors(
        background: Color(0xFFFCE4EC),
        accent: Color(0xFFF05340),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.6,
      level: 'Pemula',
      studentCount: 12110,
      estimatedMinutes: 380,
      progress: 1.0,
    ),
    CourseDetail(
      id: 'flutter-untuk-pemula',
      title: 'Flutter untuk Pemula',
      category: 'Mobile App',
      shortDescription: 'Buat aplikasi mobile lintas platform dengan Flutter.',
      description:
          'Mulai dari konsep widget hingga mengirim aplikasi pertama ke '
          'perangkat. Course ini memperkenalkan Flutter dan Dart, layout '
          'responsif, navigasi antar halaman, serta integrasi state sederhana '
          'melalui latihan bertahap.',
      learningOutcomes: const [
        'Memahami widget dan struktur Flutter',
        'Membangun layout responsif',
        'Menavigasi antar halaman',
        'Mengelola state sederhana',
        'Menjalankan aplikasi di perangkat',
      ],
      lessons: _lessons(const [
        'Pengenalan Flutter',
        'Setup Lingkungan',
        'Memahami Widget',
        'Stateless vs Stateful',
        'Layout dan Row/Column',
        'Input dan Form',
        'Navigasi Antar Halaman',
        'Mengelola State',
        'Mengambil Data',
        'Tema dan Styling',
        'Animasi Dasar',
        'Proyek: Aplikasi Pertamamu',
        'Debugging',
        'Membangun untuk Rilis',
      ]),
      iconPath: AppIconPaths.techFlutter,
      brand: const TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF0468D7),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.8,
      level: 'Pemula',
      studentCount: 16330,
      estimatedMinutes: 520,
    ),
    CourseDetail(
      id: 'html-css-modern',
      title: 'HTML & CSS Modern',
      category: 'Website',
      shortDescription: 'Susun struktur dan gaya halaman web dari nol.',
      description:
          'Pelajari cara menyusun struktur halaman web dengan HTML dan '
          'menghidupkannya dengan CSS modern: Flexbox, Grid, responsive design, '
          'dan best practices. Ideal untuk memulai perjalanan menjadi frontend '
          'developer.',
      learningOutcomes: const [
        'Menyusun struktur semantik HTML',
        'Menata halaman dengan Flexbox dan Grid',
        'Membuat layout responsif',
        'Menggunakan custom properties',
        'Menerapkan aksesibilitas dasar',
      ],
      lessons: _lessons(const [
        'Pengenalan HTML',
        'Struktur dan Semantik',
        'Text, Link, dan Media',
        'Tabel dan Form',
        'Pengenalan CSS',
        'Selector dan Specificity',
        'Box Model',
        'Flexbox',
        'CSS Grid',
        'Responsive Design',
        'Custom Properties',
        'Proyek: Landing Page',
      ]),
      iconPath: AppIconPaths.techCss,
      brand: const TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF264DE4),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.8,
      level: 'Pemula',
      studentCount: 20120,
      estimatedMinutes: 340,
    ),
    CourseDetail(
      id: 'dasar-html-css',
      title: 'Dasar HTML & CSS',
      category: 'Website',
      shortDescription: 'Susun struktur dan gaya halaman web.',
      description:
          'Fondasi web development dalam satu course: struktur HTML yang '
          'semantik dan styling CSS untuk layout, warna, dan tipografi. Course '
          'ini dirancang untuk pemula yang ingin membuat halaman web pertamanya '
          'dengan benar sejak awal.',
      learningOutcomes: const [
        'Menyusun struktur HTML dasar',
        'Menata teks dan media',
        'Menerapkan styling CSS',
        'Membuat layout sederhana',
        'Membuat halaman responsif',
      ],
      lessons: _lessons(const [
        'Pengenalan HTML',
        'Struktur Dokumen',
        'Text dan Heading',
        'Link dan Gambar',
        'List dan Tabel',
        'Form Dasar',
        'Pengenalan CSS',
        'Selector dan Property',
        'Warna dan Background',
        'Box Model',
        'Layout dengan Flexbox',
        'Proyek: Halaman Pertamamu',
      ]),
      iconPath: AppIconPaths.techCss,
      brand: const TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF264DE4),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.8,
      level: 'Pemula',
      studentCount: 18890,
      estimatedMinutes: 320,
    ),
    CourseDetail(
      id: 'otomatisasi-dengan-python',
      title: 'Otomatisasi dengan Python',
      category: 'DevOps',
      shortDescription: 'Automasi tugas berulang dengan skrip Python.',
      description:
          'Gunakan Python untuk mengotomatisasi pekerjaan berulang: pengolahan '
          'file, scraping data sederhana, dan penjadwalan skrip. Course ini '
          'praktis dan langsung diterapkan pada skenario sehari-hari.',
      learningOutcomes: const [
        'Menulis skrip Python yang dapat digunakan ulang',
        'Mengolah file dan direktori',
        'Mengotomatisasi tugas berulang',
        'Membuat skrip terjadwal',
        'Menangani error dengan benar',
      ],
      lessons: _lessons(const [
        'Mengapa Otomatisasi?',
        'Setup dan Lingkungan',
        'Bekerja dengan File',
        'String dan Regex',
        'Membaca Data',
        'Menulis Skrip',
        'Menjadwalkan Skrip',
        'Error Handling',
        'Membuat CLI Tool',
        'Proyek: Backup Otomatis',
        'Proyek: Laporan Harian',
        'Best Practices',
        'Next Steps',
      ]),
      iconPath: AppIconPaths.techPython,
      brand: const TechBrandColors(
        background: Color(0xFFE8F0FE),
        accent: Color(0xFF3776AB),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.6,
      level: 'Menengah',
      studentCount: 9840,
      estimatedMinutes: 310,
    ),
    CourseDetail(
      id: 'desain-web-dengan-css',
      title: 'Desain Web dengan CSS',
      category: 'UI/UX',
      shortDescription: 'Kuasai tata letak, warna, dan tipografi untuk UI.',
      description:
          'Fokus pada sisi visual interface: tipografi, warna, spacing, dan '
          'komposisi layout. Course ini menjembatani kemampuan CSS teknis dengan '
          'prinsip desain agar hasil webmu terlihat profesional.',
      learningOutcomes: const [
        'Menerapkan prinsip tipografi',
        'Membangun sistem warna yang konsisten',
        'Mengelola spacing dan hierarki visual',
        'Mendesain komponen yang konsisten',
        'Menerapkan prinsip aksesibilitas visual',
      ],
      lessons: _lessons(const [
        'Prinsip Desain Web',
        'Tipografi',
        'Warna dan Kontras',
        'Spacing dan Grid',
        'Hierarki Visual',
        'Komponen UI',
        'State dan Interaksi',
        'Aksesibilitas',
        'Membangun Design System Mini',
        'Proyek: Redesign Halaman',
      ]),
      iconPath: AppIconPaths.techCss,
      brand: const TechBrandColors(
        background: Color(0xFFE3F2FD),
        accent: Color(0xFF264DE4),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.7,
      level: 'Menengah',
      studentCount: 8450,
      estimatedMinutes: 260,
    ),
    CourseDetail(
      id: 'android-dengan-kotlin',
      title: 'Android dengan Kotlin',
      category: 'Mobile App',
      shortDescription: 'Kembangkan aplikasi Android native dengan Kotlin.',
      description:
          'Kembangkan aplikasi Android native menggunakan Kotlin dan Jetpack '
          'Compose. Course ini mencakup konsep Activity, layout, navigasi, dan '
          'pengelolaan data lokal hingga aplikasi siap uji di emulator.',
      learningOutcomes: const [
        'Memahami struktur proyek Android',
        'Membangun UI dengan Jetpack Compose',
        'Mengelola navigasi antar layar',
        'Menyimpan data secara lokal',
        'Menjalankan aplikasi di emulator',
      ],
      lessons: _lessons(const [
        'Pengenalan Android',
        'Setup Studio dan Emulator',
        'Struktur Proyek',
        'Kotlin Dasar',
        'Jetpack Compose',
        'Layout dan Komponen',
        'State dan ViewModel',
        'Navigasi',
        'Room dan Data Lokal',
        'Menangani Izin',
        'Proyek: Notes App',
        'Membangun untuk Rilis',
      ]),
      iconPath: AppIconPaths.techKotlin,
      brand: const TechBrandColors(
        background: Color(0xFFF3EFFF),
        accent: Color(0xFF7F52FF),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.7,
      level: 'Pemula',
      studentCount: 11230,
      estimatedMinutes: 480,
    ),
    CourseDetail(
      id: 'ios-dengan-swift',
      title: 'iOS dengan Swift',
      category: 'Mobile App',
      shortDescription: 'Bangun aplikasi iOS dengan Swift modern.',
      description:
          'Pelajari pengembangan iOS dari nol menggunakan SwiftUI: tata letak, '
          'state, navigasi, hingga penyimpanan data lokal. Course ini berfokus '
          'pada praktik dan membangun aplikasi yang benar-benar berfungsi.',
      learningOutcomes: const [
        'Memahami konsep Swift dan SwiftUI',
        'Membangun layout dengan SwiftUI',
        'Mengelola state aplikasi',
        'Menggunakan navigasi antar view',
        'Menyimpan data secara lokal',
      ],
      lessons: _lessons(const [
        'Pengenalan iOS',
        'Setup Xcode',
        'Swift Dasar',
        'SwiftUI dan View',
        'Layout dan Stacks',
        'State dan Binding',
        'Navigasi',
        'Data dan List',
        'Penyimpanan Lokal',
        'Proyek: Habit Tracker',
        'Publikasi ke App Store',
      ]),
      iconPath: AppIconPaths.techSwift,
      brand: const TechBrandColors(
        background: Color(0xFFFEEDEA),
        accent: Color(0xFFF05138),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.6,
      level: 'Pemula',
      studentCount: 7320,
      estimatedMinutes: 430,
    ),
    CourseDetail(
      id: 'javascript-interaktif',
      title: 'JavaScript Interaktif',
      category: 'Website',
      shortDescription: 'Bangun interaksi web yang dinamis dengan JavaScript.',
      description:
          'Bawa website statis menjadi interaktif: event handling, manipulasi '
          'DOM, validasi form, dan komunikasi dengan API. Course ini praktis '
          'dan penuh contoh yang bisa langsung dicoba.',
      learningOutcomes: const [
        'Memahami event dan event handling',
        'Memanipulasi DOM secara dinamis',
        'Membuat validasi form',
        'Berinteraksi dengan API',
        'Membuat UI yang responsif terhadap state',
      ],
      lessons: _lessons(const [
        'Pengenalan Interaksi Web',
        'Menemukan Elemen',
        'Mengubah Konten',
        'Event Handling',
        'Form dan Validasi',
        'Local Storage',
        'Menggunakan Fetch API',
        'Menampilkan Data',
        'Debounce dan Throttle',
        'Animasi Ringan',
        'Proyek: Quiz Interaktif',
        'Proyek: Aplikasi Cuaca',
      ]),
      iconPath: AppIconPaths.techJavascript,
      brand: const TechBrandColors(
        background: Color(0xFFFFF9E0),
        accent: Color(0xFFF7DF1E),
        onAccent: Color(0xFF3D3200),
      ),
      rating: 4.8,
      level: 'Menengah',
      studentCount: 13890,
      estimatedMinutes: 360,
    ),
    CourseDetail(
      id: 'typescript-praktis',
      title: 'TypeScript Praktis',
      category: 'Website',
      shortDescription: 'Tulis JavaScript yang aman dengan tipe data.',
      description:
          'Tambahkan keamanan tipe pada JavaScript dengan TypeScript: interface, '
          'generic, dan tooling modern. Course ini menargetkan developer '
          'JavaScript yang ingin menulis kode yang lebih terprediksi.',
      learningOutcomes: const [
        'Memahami sistem tipe TypeScript',
        'Menggunakan interface dan type alias',
        'Menerapkan generic pada fungsi',
        'Mengonfigurasi tsconfig',
        'Mengintegrasikan TypeScript ke proyek',
      ],
      lessons: _lessons(const [
        'Mengapa TypeScript?',
        'Setup dan tsconfig',
        'Tipe Dasar',
        'Interface dan Type Alias',
        'Union dan Literal Types',
        'Function dan Overload',
        'Generic',
        'Utility Types',
        'Class dan Modifier',
        'Type Narrowing',
        'Proyek: API Client',
      ]),
      iconPath: AppIconPaths.techTypescript,
      brand: const TechBrandColors(
        background: Color(0xFFEAF2FD),
        accent: Color(0xFF3178C6),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.7,
      level: 'Menengah',
      studentCount: 9230,
      estimatedMinutes: 300,
    ),
    CourseDetail(
      id: 'php-untuk-pemula',
      title: 'PHP untuk Pemula',
      category: 'Backend',
      shortDescription: 'Kembangkan aplikasi web dari sisi server dengan PHP.',
      description:
          'Pelajari pemrograman server-side dengan PHP: variabel, array, form '
          'handling, sesi, dan interaksi dengan database. Course ini menyiapkan '
          'kamu memahami bagaimana halaman web dinamis bekerja.',
      learningOutcomes: const [
        'Menulis sintaks PHP dasar',
        'Mengelola variabel dan array',
        'Menangani form dan request',
        'Menggunakan sesi',
        'Terhubung dengan database',
      ],
      lessons: _lessons(const [
        'Pengenalan PHP',
        'Setup Lingkungan',
        'Sintaks Dasar',
        'Variabel dan Tipe',
        'Array dan Manipulasi',
        'Function',
        'Form dan Request',
        'Session dan Cookie',
        'Koneksi Database',
        'CRUD Dasar',
        'Proyek: Buku Tamu',
      ]),
      iconPath: AppIconPaths.techPhp,
      brand: const TechBrandColors(
        background: Color(0xFFEDE7F6),
        accent: Color(0xFF777BB4),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.7,
      level: 'Pemula',
      studentCount: 12760,
      estimatedMinutes: 330,
    ),
    CourseDetail(
      id: 'nodejs-express',
      title: 'Node.js & Express',
      category: 'Backend',
      shortDescription: 'Bangun API cepat dengan Node.js dan Express.',
      description:
          'Bangun REST API menggunakan Node.js dan Express: routing, middleware, '
          'validasi, dan koneksi database. Course ini menuntun dari server '
          'sederhana hingga API yang terstruktur dan siap dikonsumsi.',
      learningOutcomes: const [
        'Menyiapkan proyek Node.js',
        'Membangun server dengan Express',
        'Membuat REST API',
        'Menggunakan middleware',
        'Menghubungkan dengan database',
      ],
      lessons: _lessons(const [
        'Pengenalan Node.js',
        'Setup dan npm',
        'Modul dan CommonJS',
        'Pengenalan Express',
        'Routing',
        'Middleware',
        'Menangani Request',
        'REST API Dasar',
        'Validasi Input',
        'Koneksi Database',
        'Autentikasi Dasar',
        'Proyek: To-Do API',
      ]),
      iconPath: AppIconPaths.techNodejs,
      brand: const TechBrandColors(
        background: Color(0xFFE9F7E6),
        accent: Color(0xFF3C873A),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.7,
      level: 'Menengah',
      studentCount: 10450,
      estimatedMinutes: 360,
    ),
    CourseDetail(
      id: 'postgresql-lanjutan',
      title: 'PostgreSQL Lanjutan',
      category: 'Database',
      shortDescription: 'Kelola data skalabel dengan PostgreSQL.',
      description:
          'Perdalam PostgreSQL melampaui dasar: tipe data lanjutan, index, '
          'transaction isolation, dan optimasi query. Cocok untuk developer yang '
          'ingin database production-grade.',
      learningOutcomes: const [
        'Menggunakan tipe data lanjutan',
        'Mengoptimalkan query dengan index',
        'Memahami transaction isolation',
        'Menulis query kompleks',
        'Mengelola user dan permission',
      ],
      lessons: _lessons(const [
        'Mengapa PostgreSQL?',
        'Tipe Data Lanjutan',
        'Constraint dan Validasi',
        'Index dan Performa',
        'Query Kompleks',
        'Window Functions',
        'Transaction dan Isolation',
        'Concurrency',
        'User dan Permission',
        'Backup dan Recovery',
        'Monitoring',
      ]),
      iconPath: AppIconPaths.techPostgresql,
      brand: const TechBrandColors(
        background: Color(0xFFE7EEF6),
        accent: Color(0xFF336791),
        onAccent: Color(0xFFFFFFFF),
      ),
      rating: 4.8,
      level: 'Lanjutan',
      studentCount: 6910,
      estimatedMinutes: 320,
    ),
  ];

  static List<CourseLesson> _lessons(
    List<String> titles, {
    int completed = 0,
    int current = -1,
  }) {
    return [
      for (var i = 0; i < titles.length; i++)
        CourseLesson(
          id: 'lesson-${i + 1}',
          title: titles[i],
          durationMinutes: 8 + (i * 3) % 9,
          state: i < completed
              ? CourseLessonState.completed
              : i == current
              ? CourseLessonState.current
              : CourseLessonState.available,
        ),
    ];
  }
}
