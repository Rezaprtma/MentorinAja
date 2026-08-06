import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../layout/app_gap.dart';

/// A titled row used as a section break inside lists and pages.
///
/// Provides consistent vertical spacing, title weight and an optional
/// trailing action (e.g. "See all"). Screens compose [AppSectionHeader]
/// to give scrollable content a clear visual hierarchy without hand-building
/// title rows every time.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.only(
      top: AppSpacing.lg,
      bottom: AppSpacing.sm,
    ),
  });

  /// Primary heading text.
  final String title;

  /// Optional supporting line below the heading.
  final String? subtitle;

  /// Trailing widget (e.g. a "See all" [TextButton]).
  final Widget? trailing;

  /// Outer padding; defaults to standard section inset.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypeScale.titleMedium.copyWith(
                    color: ext.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  AppGap.xxs,
                  Text(
                    subtitle!,
                    style: AppTypeScale.bodySmall.copyWith(
                      color: ext.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
