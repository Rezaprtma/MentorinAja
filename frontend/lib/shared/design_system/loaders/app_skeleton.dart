//**
// frontend/shared/design_system/loaders/app_skeleton.dart
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
import 'app_shimmer.dart';

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

  const AppSkeleton.text({
    super.key,
    this.height = 14,
    this.radius = AppRadius.small,
    this.color,
  }) : width = double.infinity,
       circle = false;

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
