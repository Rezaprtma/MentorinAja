import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../logic/onboarding_controller.dart';

/// Three-page onboarding introducing MentorinAja.
///
/// Background layers (white + wave) fill the entire viewport, edge-to-edge.
/// Content is laid out with natural Flex (Column/Expanded) inside the screen's
/// own SafeArea; only the decorative background uses positioned widgets.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingController _controller;
  late final PageController _pageController;

  static const _pageTransitionDuration = Duration(milliseconds: 350);
  static const _indicatorTransitionDuration = Duration(milliseconds: 150);

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: _pageTransitionDuration,
      curve: AppEasing.decelerate,
    );
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      _controller.totalPages - 1,
      duration: _pageTransitionDuration,
      curve: AppEasing.decelerate,
    );
  }

  void _completeOnboarding() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.authentication,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: ListenableBuilder(
          listenable: Listenable.merge([_controller, _pageController]),
          builder: (context, _) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Background layers fill the |viewport|, ignoring SafeArea.
                const ColoredBox(color: Colors.white),
                const CustomPaint(
                  painter: _WaveBackgroundPainter(color: Color(0xFFFFF8F4)),
                ),

                // Page content — fills the Stack; SafeArea handled per page.
                _OnboardingBody(
                  pageController: _pageController,
                  onPageChanged: _controller.onPageChanged,
                  pages: _pages,
                  isLastPage: _controller.isLastPage,
                  currentPage: _controller.currentPage,
                  totalPages: _controller.totalPages,
                  onSkip: _skipToEnd,
                  onNext: _nextPage,
                  onComplete: _completeOnboarding,
                  indicatorDuration: _indicatorTransitionDuration,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static const _pages = [
    _OnboardingPage(
      animationPath: 'assets/animations/Onboarding1.json',
      title: 'Belajar Tanpa Batas.',
      description:
          'Temukan cara belajar yang lebih cerdas dengan AI yang memahami kebutuhanmu.',
    ),
    _OnboardingPage(
      animationPath: 'assets/animations/Onboarding2.json',
      title: 'Belajar yang Menyesuaikan Dirimu.',
      description:
          'Penjelasan, latihan, dan rekomendasi materi yang berkembang bersama proses belajarmu.',
    ),
    _OnboardingPage(
      animationPath: 'assets/animations/Onboarding3.json',
      title: 'Mulai Hari Ini.',
      description:
          'Satu langkah kecil hari ini dapat membuka peluang yang lebih besar di masa depan.',
    ),
  ];
}

// ────────────────────────────────────────────────────────────────────────────
// Page data
// ────────────────────────────────────────────────────────────────────────────

class _OnboardingPage {
  const _OnboardingPage({
    required this.animationPath,
    required this.title,
    required this.description,
  });

  final String animationPath;
  final String title;
  final String description;
}

// ────────────────────────────────────────────────────────────────────────────
// Body — horizontal PageView filling the viewport
// ────────────────────────────────────────────────────────────────────────────

class _OnboardingBody extends StatelessWidget {
  const _OnboardingBody({
    required this.pageController,
    required this.onPageChanged,
    required this.pages,
    required this.isLastPage,
    required this.currentPage,
    required this.totalPages,
    required this.onSkip,
    required this.onNext,
    required this.onComplete,
    required this.indicatorDuration,
  });

  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final List<_OnboardingPage> pages;
  final bool isLastPage;
  final int currentPage;
  final int totalPages;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback onComplete;
  final Duration indicatorDuration;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: pages.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: pageController,
          builder: (context, child) {
            final pageOffset = pageController.page ?? 0.0;
            final diff = (index - pageOffset).clamp(-1.0, 1.0);

            final opacity = 1.0 - diff.abs().abs();
            final slideX = diff * 40.0;

            return Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(slideX, 0),
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: SafeArea(
                  bottom: false,
                  child: _OnboardingIllustration(
                    page: pages[index],
                    isLastPage: isLastPage,
                    onSkip: onSkip,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: SafeArea(
                  top: false,
                  child: _OnboardingContent(
                    page: pages[index],
                    isLastPage: isLastPage,
                    currentPage: currentPage,
                    totalPages: totalPages,
                    onNext: onNext,
                    onComplete: onComplete,
                    indicatorDuration: indicatorDuration,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Illustration section — flex 6, extends to the top edge (white background)
// ────────────────────────────────────────────────────────────────────────────

class _OnboardingIllustration extends StatelessWidget {
  const _OnboardingIllustration({
    required this.page,
    required this.isLastPage,
    required this.onSkip,
  });

  final _OnboardingPage page;
  final bool isLastPage;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Semantics(
              image: true,
              label: page.title,
              child: AppLottie(
                page.animationPath,
                repeat: true,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        if (!isLastPage)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              child: TextButton(
                onPressed: onSkip,
                child: Text(
                  'Skip',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Content section — sits on the wave background (flex 4)
//
// Uses LayoutBuilder to derive spacing proportionally from the available
// height. Title and description centre in the lower section while the
// indicator and CTA stay pinned to the bottom SafeArea.
// ────────────────────────────────────────────────────────────────────────────

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({
    required this.page,
    required this.isLastPage,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onComplete,
    required this.indicatorDuration,
  });

  final _OnboardingPage page;
  final bool isLastPage;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onComplete;
  final Duration indicatorDuration;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final spacingLarge = h * 0.05;
        final spacingMedium = h * 0.025;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            spacingLarge,
            AppSpacing.lg,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      page.title,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacingMedium),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: Text(
                        page.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              _PageIndicator(
                currentPage: currentPage,
                totalPages: totalPages,
                duration: indicatorDuration,
              ),
              SizedBox(height: spacingMedium),
              AppButton(
                onPressed: isLastPage ? onComplete : onNext,
                label: isLastPage ? 'Mulai Belajar' : 'Next',
                isFullWidth: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Wave background painter — single continuous shape over the content section
//
// Draws a gentle, low-amplitude S-curve across the full viewport near the
// flex 6:4 content split, then fills everything below it with a solid color.
// The curve stays subtle and premium; it never dominates the layout.
// ────────────────────────────────────────────────────────────────────────────

class _WaveBackgroundPainter extends CustomPainter {
  const _WaveBackgroundPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = ui.PaintingStyle.fill;

    final path = Path()
      // Start at the bottom-left.
      ..lineTo(0, size.height)
      // Up the left edge to the wave's left start.
      ..lineTo(0, size.height * 0.585)
      // Single gentle, low-amplitude S-curve across the full width.
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.610,
        size.width * 0.50,
        size.height * 0.585,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.560,
        size.width,
        size.height * 0.600,
      )
      // Down the right edge, then close along the bottom.
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WaveBackgroundPainter oldDelegate) =>
      oldDelegate.color != color;
}

// ────────────────────────────────────────────────────────────────────────────
// Page indicator
// ────────────────────────────────────────────────────────────────────────────

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.currentPage,
    required this.totalPages,
    required this.duration,
  });

  final int currentPage;
  final int totalPages;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          child: AnimatedContainer(
            duration: duration,
            curve: AppEasing.standard,
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? scheme.primary : scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        );
      }),
    );
  }
}
