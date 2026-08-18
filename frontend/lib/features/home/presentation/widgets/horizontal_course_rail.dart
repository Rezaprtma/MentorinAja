//**
// frontend/features/home/presentation/widgets/horizontal_course_rail.dart
//
// frontend:
// Reusable widget. Menampilkan komponen UI yang dapat digunakan di berbagai places.
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
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

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

  final int itemCount;

  final IndexedWidgetBuilder itemBuilder;

  final double cardWidthFactor;

  final double maxCardWidth;

  final double cardHeight;

  final double gap;

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
