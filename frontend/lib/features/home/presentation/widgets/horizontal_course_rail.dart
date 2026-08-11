import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Horizontally scrolling rail that reveals part of the next card.
///
/// Measures its own width so every card is a responsive fraction of the
/// viewport — with a ceiling for wide/tablet screens — which guarantees a
/// predictable "peek" of the following card as a scroll affordance without any
/// device-specific sizing.
class HorizontalCourseRail extends StatelessWidget {
  const HorizontalCourseRail({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.cardWidthFactor = 0.82,
    this.maxCardWidth = 260,
    this.cardHeight = 200,
    this.gap = AppSpacing.sm,
    this.padding,
  });

  /// Number of cards in the rail.
  final int itemCount;

  /// Builds one card for the given index.
  final IndexedWidgetBuilder itemBuilder;

  /// Card width as a fraction of the available viewport.
  final double cardWidthFactor;

  /// Upper bound for card width on wide screens.
  final double maxCardWidth;

  /// Fixed card height so cards in the rail stay uniform.
  final double cardHeight;

  /// Horizontal gap between cards.
  final double gap;

  /// Optional outer padding of the scrollable rail.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = math.min(
          constraints.maxWidth * cardWidthFactor,
          maxCardWidth,
        );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: padding,
          child: Row(
            children: [
              for (var i = 0; i < itemCount; i++) ...[
                if (i > 0) SizedBox(width: gap),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: itemBuilder(context, i),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
