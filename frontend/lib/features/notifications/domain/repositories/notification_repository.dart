//**
// frontend/features/notifications/domain/repositories/notification_repository.dart
//
// frontend:
// Repository interface. Mendefinisikan kontrak data untuk feature.
//
// backend:
// Future: akan diimplementasikan dengan real backend calls.
//
// api:
// Future: akan menjadi integration point untuk backend APIs.
//
// qa:
// QA perlu memvalidasi data flow dan error handling.
//**
import '../entities/app_notification.dart';

abstract class NotificationRepository {
  List<AppNotification> fetch();
}
