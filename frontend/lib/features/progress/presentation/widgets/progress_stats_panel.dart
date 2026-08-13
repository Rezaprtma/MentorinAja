import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import 'course_distribution_chart.dart';

/// Learning-overview panel for the Progress page.
///
/// A premium two-column analytics card: the left holds the visual
/// [CourseDistributionChart] — the purple/green split mirrored by its "Total
/// Course" center — and the right stacks the three numeric course statistics
/// as icon + value + supporting label, separated by subtle hairlines. The two
/// columns relate through spacing and alignment rather than a vertical line.
/// Interacting with a slice swaps the chart center to that slice's count and
/// share, replacing any permanent legend. On extremely narrow surfaces the
/// composition stacks into full-width metric rows below a centered chart.
class ProgressStatsPanel extends StatelessWidget {
  const ProgressStatsPanel({
    super.key,
    required this.totalCount,
    required this.activeCount,
    required this.completedCount,
  });

  /// All enrolled courses.
  final int totalCount;

  /// Courses with progress strictly between 0 and 100 percent.
  final int activeCount;

  /// Courses finished at 100 percent.
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      elevation: AppElevation.flat,
      radius: AppRadius.extraLarge,
      borderSide: BorderSide(color: ext.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Ringkasan Belajar',
            style: AppTypeScale.titleMedium.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 230) {
                return _buildNarrow(context, constraints.maxWidth);
              }
              return _buildWide(context, constraints.maxWidth);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWide(BuildContext context, double width) {
    final chartWidth = math.min(160.0, math.max(96.0, width * 0.42));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: chartWidth,
          child: CourseDistributionChart(
            totalCount: totalCount,
            activeCount: activeCount,
            completedCount: completedCount,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _MetricTile(
                icon: Icons.menu_book_rounded,
                value: '$totalCount',
                label: 'Total Course',
              ),
              const AppDivider(height: AppSpacing.md),
              _MetricTile(
                icon: Icons.school_rounded,
                value: '$activeCount',
                label: 'Sedang Dipelajari',
              ),
              const AppDivider(height: AppSpacing.md),
              _MetricTile(
                icon: Icons.check_circle_rounded,
                value: '$completedCount',
                label: 'Selesai',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrow(BuildContext context, double width) {
    final donutSize = math.min(120.0, math.max(88.0, width * 0.44));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SizedBox(
            width: donutSize,
            height: donutSize,
            child: CourseDistributionChart(
              totalCount: totalCount,
              activeCount: activeCount,
              completedCount: completedCount,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _InlineMetric(label: 'Total Course', value: '$totalCount'),
        const SizedBox(height: AppSpacing.sm),
        _InlineMetric(label: 'Sedang Dipelajari', value: '$activeCount'),
        const SizedBox(height: AppSpacing.sm),
        _InlineMetric(label: 'Selesai', value: '$completedCount'),
      ],
    );
  }
}

/// One statistic row: a neutral icon, a prominent value, and a supporting
/// label beneath it.
class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: AppIconSizes.xxl,
          height: AppIconSizes.xxl,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: AppIconSizes.md, color: ext.textSecondary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTypeScale.titleLarge.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: AppTypeScale.bodySmall.copyWith(
                  color: ext.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A full-width metric row: quiet label on the left, strong value on the
/// right, used on extremely narrow surfaces where vertical space is cheap.
class _InlineMetric extends StatelessWidget {
  const _InlineMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
          ),
        ),
        Text(
          value,
          style: AppTypeScale.titleLarge.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
