import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'app_shimmer.dart';

/// Placeholder shape used during content loading.
///
/// Renders a rounded rectangle or circle filled with the current theme's
/// `surfaceContainerHighest` color. Wrap in [AppShimmer] to add the
/// animated gradient overlay.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.radius = AppRadius.medium,
    this.circle = false,
    this.color,
  });

  final double? width;
  final double? height;
  final double radius;
  final bool circle;
  final Color? color;

  /// Convenience for a text-line skeleton (full width, fixed height).
  const AppSkeleton.text({
    super.key,
    this.height = 14,
    this.radius = AppRadius.small,
    this.color,
  }) : width = double.infinity,
       circle = false;

  /// Convenience for a circular avatar skeleton.
  const AppSkeleton.circle({super.key, double size = 40, this.color})
    : width = size,
      height = size,
      radius = AppRadius.circle,
      circle = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: circle ? width : width,
      height: circle ? height ?? width : height,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: circle ? null : BorderRadius.circular(radius),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }
}

/// Pre-built skeleton layout for a typical card placeholder.
class AppSkeletonCard extends StatelessWidget {
  const AppSkeletonCard({super.key, this.showImage = true});

  final bool showImage;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showImage)
            const AppSkeleton(
              width: double.infinity,
              height: 140,
              radius: AppRadius.large,
            ),
          const SizedBox(height: AppSpacing.sm),
          const AppSkeleton.text(height: 16),
          const SizedBox(height: AppSpacing.xs),
          const AppSkeleton.text(height: 12),
          const SizedBox(height: AppSpacing.xxs),
          const AppSkeleton(width: 80, height: 12, radius: AppRadius.small),
        ],
      ),
    );
  }
}

/// Pre-built skeleton for a list tile.
class AppSkeletonTile extends StatelessWidget {
  const AppSkeletonTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Row(
        children: [
          AppSkeleton.circle(size: 40),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppSkeleton.text(height: 14),
                SizedBox(height: AppSpacing.xxs),
                AppSkeleton.text(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
