import 'package:flutter/material.dart';

import 'app_snack_bar.dart';
import 'app_notification.dart';

/// Convenience façade over [AppNotificationService].
///
/// Keeps the historical `AppToast.show` API while rendering the same reusable
/// notification card used across the app. Maps [AppFeedbackSeverity] onto
/// [AppNotificationType].
class AppToast {
  AppToast._();

  /// Display duration before a success/info notification animates back out.
  static const Duration displayDuration = Duration(seconds: 3);

  static void show(
    BuildContext context, {
    required String title,
    String? message,
    AppFeedbackSeverity severity = AppFeedbackSeverity.neutral,
    Duration? duration,
    IconData? icon,
  }) {
    AppNotificationService.show(
      context,
      type: _toType(severity),
      title: title,
      message: message,
      duration: duration,
    );
  }

  static void dismiss() => AppNotificationService.dismiss();

  static AppNotificationType _toType(AppFeedbackSeverity severity) {
    return switch (severity) {
      AppFeedbackSeverity.success => AppNotificationType.success,
      AppFeedbackSeverity.error => AppNotificationType.error,
      AppFeedbackSeverity.warning => AppNotificationType.warning,
      AppFeedbackSeverity.info ||
      AppFeedbackSeverity.neutral => AppNotificationType.info,
    };
  }
}
