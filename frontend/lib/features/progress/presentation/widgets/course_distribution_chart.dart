//**
// frontend/features/progress/presentation/widgets/course_distribution_chart.dart
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

class CourseDistributionChart extends StatefulWidget {
  const CourseDistributionChart({
    super.key,
    required this.totalCount,
    required this.activeCount,
    required this.completedCount,
  });

  final int totalCount;

  final int activeCount;

  final int completedCount;

  @override
  State<CourseDistributionChart> createState() =>
      _CourseDistributionChartState();
}

enum _ChartSegment { studying, completed }

class _CourseDistributionChartState extends State<CourseDistributionChart> {
  static const Key _ringKey = Key('progress-donut-ring');

  _ChartSegment? _selected;

  double get _fractionActive => _fraction(widget.activeCount);

  double get _fractionCompleted => _fraction(widget.completedCount);

  double _fraction(int count) =>
      widget.totalCount <= 0 ? 0.0 : count / widget.totalCount;

  String _percentText(int count) {
    if (widget.totalCount <= 0) return '0%';
    return '${(count / widget.totalCount * 100).round()}%';
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        final thickness = size * 0.16;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              key: _ringKey,
              width: size,
              height: size,
              child: LayoutBuilder(
                builder: (context, ringConstraints) {
                  final ringSize = ringConstraints.biggest;
                  return GestureDetector(
                    onTapUp: (details) =>
                        _handleTap(details.localPosition, ringSize),
                    child: MouseRegion(
                      onHover: (event) =>
                          _handleHover(event.localPosition, ringSize),
                      onExit: (_) => _clearSelection(),
                      cursor: SystemMouseCursors.click,
                      child: Semantics(
                        label:
                            'Ringkasan Belajar: ${widget.activeCount} course '
                            'sedang dipelajari, ${widget.completedCount} course '
                            'selesai.',
                        child: ExcludeSemantics(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: ringSize,
                                painter: _DonutPainter(
                                  fractionActive: _fractionActive,
                                  fractionCompleted: _fractionCompleted,
                                  trackColor: scheme.surfaceContainerHighest,
                                  activeColor: scheme.secondary,
                                  completedColor: ext.success,
                                  thickness: thickness,
                                ),
                              ),
                              SizedBox(
                                width: size - thickness * 2 - AppSpacing.xs,
                                height: size - thickness * 2 - AppSpacing.xs,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: _CenterContent(
                                    value: _centerValue,
                                    label: _centerLabel,
                                    accent: _centerAccent(context),
                                    percent: _centerPercent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String get _centerValue => switch (_selected) {
    _ChartSegment.studying => '${widget.activeCount}',
    _ChartSegment.completed => '${widget.completedCount}',
    null => '${widget.totalCount}',
  };

  String get _centerLabel => switch (_selected) {
    _ChartSegment.studying => 'Sedang Dipelajari',
    _ChartSegment.completed => 'Selesai',
    null => 'Total Course',
  };

  Color _centerAccent(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    return switch (_selected) {
      _ChartSegment.studying => scheme.secondary,
      _ChartSegment.completed => ext.success,
      null => ext.textPrimary,
    };
  }

  String? get _centerPercent {
    final count = switch (_selected) {
      _ChartSegment.studying => widget.activeCount,
      _ChartSegment.completed => widget.completedCount,
      null => null,
    };
    return count == null ? null : _percentText(count);
  }

  void _handleTap(Offset local, Size size) {
    final segment = _segmentAt(local, size);
    setState(() {
      _selected = (segment == null || segment == _selected) ? null : segment;
    });
  }

  void _handleHover(Offset local, Size size) {
    final segment = _segmentAt(local, size);
    if (segment != _selected) setState(() => _selected = segment);
  }

  void _clearSelection() {
    if (_selected != null) setState(() => _selected = null);
  }

  _ChartSegment? _segmentAt(Offset local, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final delta = local - center;
    final distance = delta.distance;
    final outerRadius = size.shortestSide / 2;
    final thickness = size.shortestSide * 0.16;
    final innerRadius = outerRadius - thickness;
    if (distance < innerRadius || distance > outerRadius) return null;

    final start = -math.pi / 2;
    final twoPi = math.pi * 2;
    var angle = math.atan2(delta.dy, delta.dx) - start;
    if (angle < 0) angle += twoPi;
    angle %= twoPi;

    final sweepActive = _fractionActive * twoPi;
    final sweepCompleted = _fractionCompleted * twoPi;
    if (sweepActive > 0 && angle < sweepActive) {
      return _ChartSegment.studying;
    }
    if (sweepCompleted > 0 && angle < sweepActive + sweepCompleted) {
      return _ChartSegment.completed;
    }
    return null;
  }
}

class _CenterContent extends StatelessWidget {
  const _CenterContent({
    required this.value,
    required this.label,
    required this.accent,
    required this.percent,
  });

  final String value;
  final String label;
  final Color accent;
  final String? percent;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: AppTypeScale.titleLarge.copyWith(
            color: accent,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: AppTypeScale.labelSmall.copyWith(color: ext.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (percent != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxs),
            child: Text(
              percent!,
              style: AppTypeScale.labelSmall.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({
    required this.fractionActive,
    required this.fractionCompleted,
    required this.trackColor,
    required this.activeColor,
    required this.completedColor,
    required this.thickness,
  });

  final double fractionActive;
  final double fractionCompleted;
  final Color trackColor;
  final Color activeColor;
  final Color completedColor;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.shortestSide - thickness) / 2;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    final twoPi = math.pi * 2;
    final start = -math.pi / 2;
    final sweepActive = fractionActive * twoPi;
    final sweepCompleted = fractionCompleted * twoPi;

    canvas.drawArc(rect, 0, twoPi, false, line..color = trackColor);
    canvas.drawArc(rect, start, sweepActive, false, line..color = activeColor);
    canvas.drawArc(
      rect,
      start + sweepActive,
      sweepCompleted,
      false,
      line..color = completedColor,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.fractionActive != fractionActive ||
        oldDelegate.fractionCompleted != fractionCompleted ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.completedColor != completedColor ||
        oldDelegate.thickness != thickness;
  }
}
