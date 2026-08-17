import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/notifications/notifications.dart';

/// Repository returning a fixed two-item feed with deterministic timestamps.
class _FixedNotificationRepository implements NotificationRepository {
  @override
  List<AppNotification> fetch() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'a',
        kind: AppNotificationKind.courseUpdate,
        title: 'Update A',
        message: 'Pesan A',
        createdAt: now.subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      AppNotification(
        id: 'b',
        kind: AppNotificationKind.newCourse,
        title: 'Update B',
        message: 'Pesan B',
        createdAt: now.subtract(const Duration(hours: 5)),
        isRead: true,
      ),
    ];
  }
}

void main() {
  group('NotificationController', () {
    late NotificationController controller;

    setUp(() {
      controller = NotificationController(
        repository: _FixedNotificationRepository(),
      );
    });

    test('refresh loads the feed ordered newest first', () {
      expect(controller.items, isEmpty);
      expect(controller.unreadCount, 0);

      controller.refresh();

      expect(controller.items.length, 2);
      expect(controller.unreadCount, 1);
      expect(controller.items.first.id, 'a');
    });

    test('markRead flags a single notification as read', () {
      controller.refresh();
      controller.markRead('a');

      expect(controller.unreadCount, 0);
      expect(controller.items.every((item) => item.isRead), isTrue);
    });

    test('markAllRead clears every unread notification', () {
      controller.refresh();
      controller.markAllRead();

      expect(controller.unreadCount, 0);
      expect(controller.items.every((item) => item.isRead), isTrue);
    });

    test('markAllRead notifies only when there is something unread', () {
      var notified = 0;
      controller.refresh();
      controller.addListener(() => notified++);

      controller.markAllRead();
      controller.markAllRead();

      expect(notified, 1);
    });
  });
}
