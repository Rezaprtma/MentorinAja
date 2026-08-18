//**
// frontend/features/home/presentation/widgets/hero_banner_carousel.dart
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
import 'package:frontend/shared/widgets/widgets.dart';

import '../../mock_home_data.dart';

class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({super.key, required this.banners, this.onCta});

  final List<MockBanner> banners;

  final VoidCallback? onCta;

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  static const double _viewportFraction = 0.98;

  static const double _pageGap = 4;

  late final PageController _controller;

  int _current = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: _viewportFraction);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    final scale = MediaQuery.textScalerOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth =
            constraints.maxWidth * _viewportFraction - _pageGap * 2;

        var tallest = 0.0;
        for (final banner in widget.banners) {
          final height = _BannerCard.probeHeight(banner, scale, pageWidth);
          tallest = math.max(tallest, height);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: tallest,
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.banners.length,
                onPageChanged: (index) => setState(() => _current = index),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _pageGap),
                  child: _BannerCard(
                    banner: widget.banners[index],
                    onCta: widget.onCta,
                  ),
                ),
              ),
            ),
            if (widget.banners.length > 1) ...[
              const SizedBox(height: AppSpacing.sm),
              _DotsIndicator(count: widget.banners.length, current: _current),
            ],
          ],
        );
      },
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner, this.onCta});

  static const double _padding = AppSpacing.lg;
  static const double _ctaHorizontalPadding = AppSpacing.md;
  static const double _ctaVerticalPadding = AppSpacing.xs;

  static const double _twoColumnMinWidth = 260;

  final MockBanner banner;
  final VoidCallback? onCta;

  static double _sidePanelWidthFor(MockBannerKind kind) {
    return switch (kind) {
      MockBannerKind.achievement => 116,
      MockBannerKind.interest => 116,
      MockBannerKind.discovery => 148,
    };
  }

  static double probeHeight(MockBanner banner, TextScaler scale, double width) {
    final innerWidth = width - _padding * 2;
    if (innerWidth <= 0) return 0;

    final twoColumn = innerWidth >= _twoColumnMinWidth;
    final sidePanelWidth = _sidePanelWidthFor(banner.kind);
    final columnWidth = twoColumn
        ? innerWidth - sidePanelWidth - AppSpacing.sm
        : innerWidth;

    final titleHeight = _measure(
      columnWidth,
      scale,
      banner.title,
      _titleStyleFor(innerWidth),
    );
    final messageHeight = _measure(
      columnWidth,
      scale,
      banner.message,
      AppTypeScale.bodyMedium,
    );
    final ctaHeight =
        _measure(
          math.max(0, columnWidth - _ctaHorizontalPadding * 2),
          scale,
          banner.ctaLabel,
          AppTypeScale.labelLarge.copyWith(fontWeight: FontWeight.w700),
        ) +
        _ctaVerticalPadding * 2;

    final leftColumn =
        titleHeight + AppSpacing.xs + messageHeight + AppSpacing.md + ctaHeight;
    final contentHeight = twoColumn
        ? math.max(leftColumn, _panelHeight(banner.kind))
        : leftColumn + AppSpacing.sm + _compactPanelHeight(banner.kind);

    return contentHeight + _padding * 2;
  }

  static double _panelHeight(MockBannerKind kind) {
    return switch (kind) {
      MockBannerKind.achievement => _StreakPanel.naturalHeight,
      MockBannerKind.interest => _InterestPanel.naturalHeight,
      MockBannerKind.discovery => _DiscoveryPanel.naturalHeight,
    };
  }

  static double _compactPanelHeight(MockBannerKind kind) {
    return switch (kind) {
      MockBannerKind.achievement => _StreakPanel.compactNaturalHeight,
      MockBannerKind.interest => _InterestPanel.compactNaturalHeight,
      MockBannerKind.discovery => _DiscoveryPanel.compactNaturalHeight,
    };
  }

  static double _measure(
    double width,
    TextScaler scale,
    String text,
    TextStyle style,
  ) {
    return (TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaler: scale,
    )..layout(maxWidth: width)).height;
  }

  static TextStyle _titleStyleFor(double innerWidth) {
    final fontSize = innerWidth >= 560
        ? 32.0
        : (innerWidth >= 340 ? 28.0 : 24.0);
    return AppTypeScale.headlineLarge.copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
    );
  }

  @override
  Widget build(BuildContext context) {
    final (surface, onSurface) = _surfaceFor(context);
    final (ctaBackground, ctaForeground) = _ctaColorsFor(context);
    final illustrationPath = banner.illustrationPath;

    return LayoutBuilder(
      builder: (context, constraints) {
        final innerWidth = constraints.maxWidth - _padding * 2;
        final twoColumn = innerWidth >= _twoColumnMinWidth;
        final sidePanelWidth = _sidePanelWidthFor(banner.kind);
        final titleStyle = _titleStyleFor(
          innerWidth,
        ).copyWith(color: onSurface);

        final leftColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(banner.title, style: titleStyle),
            const SizedBox(height: AppSpacing.xs),
            Text(
              banner.message,
              style: AppTypeScale.bodyMedium.copyWith(
                color: onSurface.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _BannerCta(
              label: banner.ctaLabel,
              background: ctaBackground,
              foreground: ctaForeground,
              onPressed: onCta,
            ),
          ],
        );

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: _BannerDecoration(
                  kind: banner.kind,
                  onSurface: onSurface,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(_padding),
                child: twoColumn
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: leftColumn),
                          const SizedBox(width: AppSpacing.sm),
                          SizedBox(
                            width: sidePanelWidth,
                            child: _SidePanel(
                              banner: banner,
                              onSurface: onSurface,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          leftColumn,
                          const SizedBox(height: AppSpacing.sm),
                          _SidePanel(
                            banner: banner,
                            onSurface: onSurface,
                            compact: true,
                          ),
                        ],
                      ),
              ),
              if (twoColumn &&
                  illustrationPath != null &&
                  illustrationPath.isNotEmpty)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _DiscoveryIllustration(
                    path: illustrationPath,
                    panelWidth: sidePanelWidth,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  (Color, Color) _surfaceFor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (banner.kind) {
      MockBannerKind.achievement => (scheme.primary, scheme.onPrimary),
      MockBannerKind.interest => (scheme.secondary, scheme.onSecondary),
      MockBannerKind.discovery => (scheme.surface, scheme.onSurface),
    };
  }

  (Color, Color) _ctaColorsFor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (banner.kind) {
      MockBannerKind.achievement => (scheme.onPrimary, scheme.primary),
      MockBannerKind.interest => (scheme.onSecondary, scheme.secondary),
      MockBannerKind.discovery => (scheme.primary, scheme.onPrimary),
    };
  }
}

class _BannerDecoration extends StatelessWidget {
  const _BannerDecoration({required this.kind, required this.onSurface});

  final MockBannerKind kind;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    final children = switch (kind) {
      MockBannerKind.achievement => [
        _Circle(
          right: -40,
          top: -40,
          size: 128,
          color: onSurface.withValues(alpha: 0.12),
        ),
        _Circle(
          left: -28,
          bottom: -28,
          size: 88,
          color: onSurface.withValues(alpha: 0.10),
        ),
      ],
      MockBannerKind.interest => [
        _Circle(
          right: -40,
          top: -40,
          size: 128,
          color: onSurface.withValues(alpha: 0.12),
        ),
        _Circle(
          left: -28,
          bottom: -28,
          size: 88,
          color: onSurface.withValues(alpha: 0.10),
        ),
      ],
      MockBannerKind.discovery => [
        _Circle(
          right: -40,
          top: -40,
          size: 128,
          color: onSurface.withValues(alpha: 0.05),
        ),
      ],
    };

    return Stack(children: children);
  }
}

class _Circle extends StatelessWidget {
  const _Circle({
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.size,
    required this.color,
  });

  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  const _SidePanel({
    required this.banner,
    required this.onSurface,
    this.compact = false,
  });

  final MockBanner banner;
  final Color onSurface;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return switch (banner.kind) {
      MockBannerKind.achievement => _StreakPanel(
        days: banner.streakDays ?? 0,
        onSurface: onSurface,
        compact: compact,
      ),
      MockBannerKind.interest => _InterestPanel(
        progress: banner.progress,
        progressLabel: banner.progressLabel,
        onSurface: onSurface,
        compact: compact,
      ),
      MockBannerKind.discovery => _DiscoveryPanel(
        illustrationPath: banner.illustrationPath,
        label: banner.title,
        onSurface: onSurface,
        compact: compact,
      ),
    };
  }
}

class _StreakPanel extends StatelessWidget {
  const _StreakPanel({
    required this.days,
    required this.onSurface,
    this.compact = false,
  });

  static const double naturalHeight = 156;

  static const double compactNaturalHeight = 56;

  final int days;
  final Color onSurface;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: onSurface, size: 36),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$days',
                  style: AppTypeScale.titleMedium.copyWith(
                    color: onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Hari Berturut-turut',
                  style: AppTypeScale.bodySmall.copyWith(
                    color: onSurface.withValues(alpha: 0.85),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: onSurface, size: 72),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '$days',
            style: AppTypeScale.headlineLarge.copyWith(
              fontSize: 44,
              height: 1,
              color: onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Hari Berturut-turut',
            textAlign: TextAlign.center,
            style: AppTypeScale.bodySmall.copyWith(
              color: onSurface.withValues(alpha: 0.85),
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _InterestPanel extends StatelessWidget {
  const _InterestPanel({
    required this.progress,
    required this.progressLabel,
    required this.onSurface,
    this.compact = false,
  });

  static const double naturalHeight = 124;

  static const double compactNaturalHeight = 56;

  final double? progress;
  final String? progressLabel;
  final Color onSurface;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final percent = ((progress ?? 0) * 100).round();

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RingProgress(
            percent: percent,
            size: 44,
            strokeWidth: 7,
            trackColor: onSurface.withValues(alpha: 0.22),
            progressColor: accent,
            foreground: onSurface,
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$percent%',
                  style: AppTypeScale.titleMedium.copyWith(
                    color: onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  progressLabel ?? '',
                  style: AppTypeScale.bodySmall.copyWith(
                    color: onSurface.withValues(alpha: 0.85),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RingProgress(
            percent: percent,
            size: 84,
            strokeWidth: 12,
            trackColor: onSurface.withValues(alpha: 0.22),
            progressColor: accent,
            foreground: onSurface,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            progressLabel ?? '',
            textAlign: TextAlign.center,
            style: AppTypeScale.bodySmall.copyWith(
              color: onSurface.withValues(alpha: 0.85),
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _RingProgress extends StatelessWidget {
  const _RingProgress({
    required this.percent,
    required this.size,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
    required this.foreground,
  });

  final int percent;
  final double size;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final labelStyle =
        (size >= 64
                ? AppTypeScale.titleMedium.copyWith(fontSize: 18)
                : AppTypeScale.labelMedium)
            .copyWith(color: foreground, fontWeight: FontWeight.w800);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: percent / 100,
            strokeWidth: strokeWidth,
            strokeCap: StrokeCap.round,
            backgroundColor: trackColor,
            color: progressColor,
          ),
          Center(child: Text('$percent%', style: labelStyle)),
        ],
      ),
    );
  }
}

class _DiscoveryPanel extends StatelessWidget {
  const _DiscoveryPanel({
    required this.illustrationPath,
    required this.label,
    required this.onSurface,
    this.compact = false,
  });

  static const double naturalHeight = 120;

  static const double compactNaturalHeight = 56;

  final String? illustrationPath;
  final String label;
  final Color onSurface;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final path = illustrationPath;
    if (path == null || path.isEmpty) return const SizedBox.shrink();

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: AppSvg(path, fit: BoxFit.contain),
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTypeScale.titleMedium.copyWith(
                    color: onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Jelajahi sekarang',
                  style: AppTypeScale.bodySmall.copyWith(
                    color: onSurface.withValues(alpha: 0.85),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

class _DiscoveryIllustration extends StatelessWidget {
  const _DiscoveryIllustration({required this.path, required this.panelWidth});

  static const double _aspect = 1.3163;

  final String path;
  final double panelWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var width = panelWidth + _BannerCard._padding;
        var height = width / _aspect;
        if (height > constraints.maxHeight) {
          height = constraints.maxHeight;
          width = height * _aspect;
        }
        return SizedBox(
          width: width,
          height: height,
          child: AppSvg(path, fit: BoxFit.contain),
        );
      },
    );
  }
}

class _BannerCta extends StatelessWidget {
  const _BannerCta({
    required this.label,
    required this.background,
    required this.foreground,
    this.onPressed,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: background,
        shape: const StadiumBorder(),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _BannerCard._ctaHorizontalPadding,
              vertical: _BannerCard._ctaVerticalPadding,
            ),
            child: Text(
              label,
              style: AppTypeScale.labelLarge.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          Container(
            width: current == i ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: current == i ? scheme.primary : scheme.outlineVariant,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ],
      ],
    );
  }
}
