/// A notification shown to the learner.
///
/// Carries the message, a timestamp and an optional deep link to a course.
/// [isRead] drives the subtle unread styling; [courseId] makes the
/// notification actionable when present.
library;

/// What a notification is about; drives its icon and tint.
enum AppNotificationKind {
  /// Content of an enrolled course was updated.
  courseUpdate,

  /// The next lesson is ready to study.
  lessonReady,

  /// A milestone in the learner's progress.
  progress,

  /// A new course became available.
  newCourse,

  /// A study reminder.
  reminder;

  /// Broad bucket used by the feed filter bar.
  NotificationCategory get category => switch (this) {
    AppNotificationKind.courseUpdate ||
    AppNotificationKind.newCourse => NotificationCategory.course,
    AppNotificationKind.lessonReady ||
    AppNotificationKind.progress => NotificationCategory.belajar,
    AppNotificationKind.reminder => NotificationCategory.pengingat,
  };
}

/// Broad grouping of the feed used by the notification filter bar.
enum NotificationCategory {
  /// Study-related updates: ready lessons and progress milestones.
  belajar('Belajar'),

  /// Catalog and course-content announcements.
  course('Course'),

  /// Study reminders.
  pengingat('Pengingat');

  const NotificationCategory(this.label);

  /// Indonesian label shown on the filter chip.
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

  /// Stable course id to open when the notification is actionable.
  final String? courseId;

  /// Short action label (e.g. "Buka Course"); defaulted by the UI.
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
