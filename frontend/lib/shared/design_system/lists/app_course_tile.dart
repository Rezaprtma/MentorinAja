import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'app_tile.dart';

/// Horizontal course row: thumbnail + title + metadata.
///
/// A compact list representation of a course, typically used in search results,
/// "continue learning" lists, and horizontal scrolling feeds. Accepts a
/// thumbnail [Widget] (e.g. [Image.network]) and renders title + subtitle
/// + optional trailing widget.
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

  /// Thumbnail widget rendered at the leading edge.
  final Widget? thumbnail;

  /// Course title.
  final String title;

  /// Instructor or category subtitle.
  final String? subtitle;

  /// Optional trailing widget (e.g. progress indicator, arrow).
  final Widget? trailing;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;

  /// Thumbnail dimension (square).
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
