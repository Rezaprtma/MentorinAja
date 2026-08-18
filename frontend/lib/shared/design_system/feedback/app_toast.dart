//**
// frontend/shared/design_system/feedback/app_toast.dart
//
// frontend:
// Design system widget. Menyediakan reusable UI components.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
import 'package:flutter/material.dart';

import 'app_snack_bar.dart';
import 'app_notification.dart';

class AppToast {
  AppToast._();

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
