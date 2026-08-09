import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../mock_home_data.dart';

/// Compact learning metrics for the Home screen.
///
/// Renders an open horizontal information row — no surrounding surface — with
/// soft tinted icon chips, bold values and muted labels separated by hairline
/// dividers. Keeping the strip surface-less lets it support the "Continue
/// learning" hero instead of competing with it for visual weight.
class LearningStats extends StatelessWidget {
  const LearningStats({super.key, required this.stats});

  /// The metrics to display, e.g. [MockHomeData.learningStats].
  final List<LearningStat> stats;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    final children = <Widget>[];
    for (var i = 0; i < stats.length; i++) {
      if (i > 0) children.add(_StatDivider(color: ext.divider));
      children.add(
        Expanded(
          child: _StatTile(
            stat: stats[i],
            chipColor: _chipColor(context, stats[i].accent),
            accentColor: _accentColor(context, stats[i].accent),
          ),
        ),
      );
    }

    return Row(children: children);
  }

  Color _chipColor(BuildContext context, LearningAccent accent) {
    final scheme = Theme.of(context).colorScheme;
    return switch (accent) {
      LearningAccent.primary => scheme.primaryContainer,
      LearningAccent.secondary => scheme.secondaryContainer,
      LearningAccent.neutral => scheme.surfaceContainerHighest,
    };
  }

  Color _accentColor(BuildContext context, LearningAccent accent) {
    final scheme = Theme.of(context).colorScheme;
    return switch (accent) {
      LearningAccent.primary => scheme.primary,
      LearningAccent.secondary => scheme.secondary,
      LearningAccent.neutral => context.appColors.textSecondary,
    };
  }
}

/// Hairline vertical divider between stat tiles.
class _StatDivider extends StatelessWidget {
  const _StatDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 44, color: color);
  }
}

/// One metric tile inside [LearningStats].
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.stat,
    required this.chipColor,
    required this.accentColor,
  });

  final LearningStat stat;
  final Color chipColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: chipColor,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Icon(stat.icon, size: AppIconSizes.md, color: accentColor),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          stat.value,
          style: AppTypeScale.titleMedium.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          stat.label,
          style: AppTypeScale.labelSmall.copyWith(color: ext.textSecondary),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
