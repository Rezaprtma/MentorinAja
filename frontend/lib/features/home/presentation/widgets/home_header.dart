import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Greeting row for the Home screen.
///
/// A time-of-day eyebrow pair throws a personalized "ready to continue
/// learning?" line under the learner's name. The notification action and
/// avatar stay minimal on the trailing edge so the header never grows taller
/// than it needs to be.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.displayName,
    this.onNotificationsPressed,
  });

  /// Learner's name woven into the greeting line.
  final String displayName;

  /// Opens the notifications surface.
  final VoidCallback? onNotificationsPressed;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Good afternoon',
                style: AppTypeScale.labelMedium.copyWith(
                  color: ext.textSecondary,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '$displayName, ready to continue learning?',
                style: AppTypeScale.headlineMedium.copyWith(
                  color: ext.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        AppIconButton(
          icon: Icons.notifications_none,
          tooltip: 'Notifications',
          onPressed: onNotificationsPressed,
        ),
        const SizedBox(width: AppSpacing.xs),
        AppAvatar.initial(name: displayName, size: 44),
      ],
    );
  }
}
