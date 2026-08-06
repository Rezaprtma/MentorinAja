import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../badges/app_badge.dart';
import 'app_base_card.dart';

/// Vertical card for displaying a course preview.
///
/// Composes a cover image, title, instructor name and optional metadata row.
/// Typically used in horizontal scrolling lists or grid layouts. The cover
/// area accepts any [Widget] so screens can supply an [Image.network],
/// placeholder, or custom illustration.
class AppCourseCard extends StatelessWidget {
  const AppCourseCard({
    super.key,
    this.cover,
    required this.title,
    this.subtitle,
    this.meta,
    this.badge,
    this.trailing,
    this.onTap,
    this.width,
    this.onLongPress,
  });

  /// Cover area rendered at the top of the card; typically 16:9 aspect ratio.
  final Widget? cover;

  /// Course title.
  final String title;

  /// Instructor or category label.
  final String? subtitle;

  /// Bottom metadata row (e.g. duration, lesson count).
  final Widget? meta;

  /// Optional badge (e.g. "New", "Free") positioned top-right of the cover.
  final String? badge;

  /// Optional trailing widget in the bottom row.
  final Widget? trailing;

  final VoidCallback? onTap;
  final double? width;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return AppBaseCard(
      onTap: onTap,
      onLongPress: onLongPress,
      padding: EdgeInsets.zero,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (cover != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.large),
              ),
              child: Stack(
                children: [
                  SizedBox(width: double.infinity, height: 140, child: cover!),
                  if (badge != null)
                    Positioned(
                      top: AppSpacing.xs,
                      right: AppSpacing.xs,
                      child: AppBadge(
                        label: badge!,
                        variant: AppBadgeVariant.info,
                      ),
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypeScale.titleSmall.copyWith(
                    color: ext.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle!,
                    style: AppTypeScale.bodySmall.copyWith(
                      color: ext.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (meta != null || trailing != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      if (meta != null) Expanded(child: meta!),
                      ?trailing,
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
