//**
// frontend/features/notifications/domain/entities/app_notification.dart
//
// frontend:
// Entity/model. Mendefinisikan data structures untuk feature.
//
// backend:
// Future: akan sesuai dengan backend data models.
//
// api:
// Future: akan menjadi frontend expected contract untuk APIs.
//
// qa:
// QA perlu memvalidasi data validation dan edge cases.
//**
library;

enum AppNotificationKind {
  courseUpdate,

  lessonReady,

  progress,

  newCourse,

  reminder;

  NotificationCategory get category => switch (this) {
    AppNotificationKind.courseUpdate ||
    AppNotificationKind.newCourse => NotificationCategory.course,
    AppNotificationKind.lessonReady ||
    AppNotificationKind.progress => NotificationCategory.belajar,
    AppNotificationKind.reminder => NotificationCategory.pengingat,
  };
}

enum NotificationCategory {
  belajar('Belajar'),

  course('Course'),

  pengingat('Pengingat');

  const NotificationCategory(this.label);

  final String label;
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
    this.courseId,
    this.actionLabel,
  });

  final String id;
  final AppNotificationKind kind;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  final String? courseId;

  final String? actionLabel;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      kind: kind,
      title: title,
      message: message,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      courseId: courseId,
      actionLabel: actionLabel,
    );
  }
}
