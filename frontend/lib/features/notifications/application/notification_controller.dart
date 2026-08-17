import 'package:flutter/foundation.dart';

import '../data/mock_notification_repository.dart';
import '../domain/entities/app_notification.dart';
import '../domain/repositories/notification_repository.dart';

/// Holds the notification feed and exposes the read-state operations the
/// screen needs. Replaces the repository per test by constructor injection.
///
/// Used through the [NotificationController.instance] singleton; call
/// [markAllRead] when the app opens so the app-bar badge stays consistent.
class NotificationController extends ChangeNotifier {
  NotificationController({NotificationRepository? repository})
    : _repository = repository ?? MockNotificationRepository();

  /// Shared app-wide controller.
  static final NotificationController instance = NotificationController();

  final NotificationRepository _repository;

  List<AppNotification> _items = const [];

  /// Snapshot of the feed, ordered newest first.
  List<AppNotification> get items => List.unmodifiable(_items);

  /// Number of unread notifications.
  int get unreadCount => _items.where((item) => !item.isRead).length;

  /// Reloads the feed from the repository.
  void refresh() {
    _items = _repository.fetch();
    notifyListeners();
  }

  /// Marks a single notification as read.
  void markRead(String id) {
    _items = [
      for (final item in _items)
        item.id == id ? item.copyWith(isRead: true) : item,
    ];
    notifyListeners();
  }

  /// Marks every notification as read.
  void markAllRead() {
    if (unreadCount == 0) return;
    _items = [for (final item in _items) item.copyWith(isRead: true)];
    notifyListeners();
  }
}
