//**
// frontend/shared/design_system/lists/app_course_tile.dart
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

import '../../../core/theme/theme.dart';
import 'app_tile.dart';

class AppCourseTile extends StatelessWidget {
  const AppCourseTile({
    super.key,
    this.thumbnail,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.thumbnailSize = 56,
  });

  final Widget? thumbnail;

  final String title;

  final String? subtitle;

  final Widget? trailing;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;

  final double thumbnailSize;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    final thumb = thumbnail != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.small),
            child: SizedBox(
              width: thumbnailSize,
              height: thumbnailSize,
              child: thumbnail,
            ),
          )
        : Container(
            width: thumbnailSize,
            height: thumbnailSize,
            decoration: BoxDecoration(
              color: ext.card,
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(
              Icons.play_circle_outline,
              color: ext.textDisabled,
              size: AppIconSizes.xl,
            ),
          );

    return AppTile(
      leading: thumb,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
    );
  }
}
