//**
// frontend/features/notifications/data/mock_notification_repository.dart
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
import 'package:frontend/shared/models/course_identifier.dart';

import '../domain/entities/app_notification.dart';
import '../domain/repositories/notification_repository.dart';

class MockNotificationRepository implements NotificationRepository {
  @override
  List<AppNotification> fetch() {
    final now = DateTime.now();

    return [
      AppNotification(
        id: 'notif-1',
        kind: AppNotificationKind.courseUpdate,
        title: 'Course Python Dasar diperbarui',
        message:
            'Modul "Fungsi" menambahkan latihan interaktif baru untuk kamu.',
        createdAt: now.subtract(const Duration(minutes: 25)),
        isRead: false,
        courseId: CourseIdentifier.slug('Dasar Python'),
        actionLabel: 'Buka Course',
      ),
      AppNotification(
        id: 'notif-2',
        kind: AppNotificationKind.lessonReady,
        title: 'Pelajaran berikutnya sudah siap',
        message: 'Lanjutkan ke "Widget dan Material" di course Flutter.',
        createdAt: now.subtract(const Duration(hours: 3)),
        isRead: false,
        courseId: CourseIdentifier.slug('Flutter untuk Pemula'),
        actionLabel: 'Lanjutkan',
      ),
      AppNotification(
        id: 'notif-3',
        kind: AppNotificationKind.progress,
        title: 'Progress belajar kamu mencapai 75%',
        message: 'Tinggal 3 pelajaran lagi sampai kamu menuntaskan course ini.',
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        isRead: false,
        courseId: CourseIdentifier.slug('HTML & CSS Modern'),
        actionLabel: 'Lanjutkan',
      ),
      AppNotification(
        id: 'notif-4',
        kind: AppNotificationKind.reminder,
        title: 'Jangan lupa lanjutkan belajar hari ini',
        message: 'Satu sesi belajar singkat membuat kamu makin konsisten.',
        createdAt: now.subtract(const Duration(days: 1, hours: 7)),
        isRead: true,
      ),
      AppNotification(
        id: 'notif-5',
        kind: AppNotificationKind.newCourse,
        title: 'Course baru tersedia',
        message: 'JavaScript Interaktif sudah bisa kamu pelajari sekarang.',
        createdAt: now.subtract(const Duration(days: 3)),
        isRead: true,
        courseId: CourseIdentifier.slug('JavaScript Interaktif'),
        actionLabel: 'Lihat Course',
      ),
      AppNotification(
        id: 'notif-6',
        kind: AppNotificationKind.progress,
        title: 'Progress belajar kamu mencapai 50%',
        message: 'Setengah perjalanan course MySQL sudah kamu selesaikan.',
        createdAt: now.subtract(const Duration(days: 5)),
        isRead: true,
        courseId: CourseIdentifier.slug('MySQL Dasar'),
        actionLabel: 'Lanjutkan',
      ),
      AppNotification(
        id: 'notif-7',
        kind: AppNotificationKind.courseUpdate,
        title: 'Laravel untuk Pemula diperbarui',
        message:
            'Materi "Controller dan Route" disusun ulang agar lebih jelas.',
        createdAt: now.subtract(const Duration(days: 11)),
        isRead: true,
        courseId: CourseIdentifier.slug('Laravel untuk Pemula'),
        actionLabel: 'Buka Course',
      ),
      AppNotification(
        id: 'notif-8',
        kind: AppNotificationKind.newCourse,
        title: 'Course baru tersedia',
        message: 'Node.js & Express hadir untuk kamu yang ingin membangun API.',
        createdAt: now.subtract(const Duration(days: 16)),
        isRead: true,
        courseId: CourseIdentifier.slug('Node.js & Express'),
        actionLabel: 'Lihat Course',
      ),
    ];
  }
}
