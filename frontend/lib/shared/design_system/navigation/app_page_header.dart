import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../layout/app_gap.dart';

/// Large, prominent title block for the top of a screen.
///
/// Used for screen headers (e.g. "My Profile", "Course Details") where the
/// title is larger than a standard [AppBar] and may include a subtitle or
/// trailing action. Typically placed inside [AppScrollablePage] or a
/// [SliverToBoxAdapter].
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.only(
      left: AppSpacing.md,
      right: AppSpacing.md,
      top: AppSpacing.lg,
      bottom: AppSpacing.sm,
    ),
  });

  /// Primary heading in [headlineSmall] style.
  final String title;

  /// Optional supporting text in [bodyMedium] style.
  final String? subtitle;

  /// Optional trailing widget aligned to the end of the title row.
  final Widget? trailing;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypeScale.headlineSmall.copyWith(
                    color: ext.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  AppGap.xs,
                  Text(
                    subtitle!,
                    style: AppTypeScale.bodyMedium.copyWith(
                      color: ext.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[AppGap.md, trailing!],
        ],
      ),
    );
  }
}
