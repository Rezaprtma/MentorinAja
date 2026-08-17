import '../entities/app_notification.dart';

/// Source of the learner's notification feed.
///
/// Backend notifications later implement this interface; the controller never
/// depends on where the data comes from.
abstract class NotificationRepository {
  List<AppNotification> fetch();
}
