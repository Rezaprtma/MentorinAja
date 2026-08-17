import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../domain/entities/app_notification.dart';

/// One row of the notification feed.
///
/// Unread notifications keep a bold title and a small accent dot so the state
/// is legible even before the user reads the body. The tinted icon tile
/// communicates the notification kind at a glance without relying on color
/// alone — the icon carries the meaning.
class NotificationListItem extends StatelessWidget {
  const NotificationListItem({
    super.key,
    required this.notification,
    required this.isLast,
    this.onTap,
  });

  final AppNotification notification;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final (container, foreground) = _tint(ext, scheme);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: container,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: AppIconSizes.lg,
                        color: foreground,
                      ),
                    ),
                    if (!notification.isRead)
                      Positioned(
                        top: -1,
                        right: -1,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: ext.card, width: 1.6),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: AppTypeScale.bodyMedium.copyWith(
                                color: ext.textPrimary,
                                fontWeight: notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: Text(
                              _relativeTime(notification.createdAt),
                              style: AppTypeScale.labelSmall.copyWith(
                                color: ext.textDisabled,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        notification.message,
                        style: AppTypeScale.bodySmall.copyWith(
                          color: ext.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isLast) const AppDivider(height: 1, indent: 68),
      ],
    );
  }

  IconData get icon => switch (notification.kind) {
    AppNotificationKind.courseUpdate => Icons.sync_alt_rounded,
    AppNotificationKind.lessonReady => Icons.play_circle_outline_rounded,
    AppNotificationKind.progress => Icons.trending_up_rounded,
    AppNotificationKind.newCourse => Icons.add_box_rounded,
    AppNotificationKind.reminder => Icons.notifications_active_outlined,
  };

  (Color, Color) _tint(AppThemeExtension ext, ColorScheme scheme) {
    return switch (notification.kind) {
      AppNotificationKind.courseUpdate => (
        ext.infoContainer,
        ext.onInfoContainer,
      ),
      AppNotificationKind.lessonReady => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      AppNotificationKind.progress => (
        ext.successContainer,
        ext.onSuccessContainer,
      ),
      AppNotificationKind.newCourse => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      AppNotificationKind.reminder => (
        ext.warningContainer,
        ext.onWarningContainer,
      ),
    };
  }

  static String _relativeTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'Baru saja';
    if (difference.inMinutes < 60) return '${difference.inMinutes} mnt lalu';
    if (difference.inHours < 24) return '${difference.inHours} jam lalu';
    if (difference.inDays < 2) return 'Kemarin';
    return '${difference.inDays} hari lalu';
  }
}
