//**
// frontend/features/notifications/application/notification_controller.dart
//
// frontend:
// Controller. Mengelola state dan business logic untuk feature.
//
// backend:
// Future: akan membutuhkan backend persistence dan API integration.
//
// api:
// Future: akan melakukan API calls melalui repositories.
//
// qa:
// QA perlu memvalidasi state transitions dan edge cases.
//**
import 'package:flutter/foundation.dart';

import '../data/mock_notification_repository.dart';
import '../domain/entities/app_notification.dart';
import '../domain/repositories/notification_repository.dart';

class NotificationController extends ChangeNotifier {
  NotificationController({NotificationRepository? repository})
    : _repository = repository ?? MockNotificationRepository();

  static final NotificationController instance = NotificationController();

  final NotificationRepository _repository;

  List<AppNotification> _items = const [];

  List<AppNotification> get items => List.unmodifiable(_items);

  int get unreadCount => _items.where((item) => !item.isRead).length;

  void refresh() {
    _items = _repository.fetch();
    notifyListeners();
  }

  void markRead(String id) {
    _items = [
      for (final item in _items)
        item.id == id ? item.copyWith(isRead: true) : item,
    ];
    notifyListeners();
  }

  void markAllRead() {
    if (unreadCount == 0) return;
    _items = [for (final item in _items) item.copyWith(isRead: true)];
    notifyListeners();
  }
}
