import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import 'onboarding_illustration.dart';
import 'onboarding_indicator.dart';
import 'onboarding_page_theme.dart';

/// A single onboarding slide, isolated as its own visual coordinate space.
///
/// The root [ClipRect] hard-clips the background, illustration, text,
/// indicator and CTA to this page's bounds so nothing owned by a neighbor page
/// can ever bleed across a page boundary during a horizontal swipe.
///
/// Each chapter carries its own background, brand logomark, compact "Next"
/// circle or final wide CTA, and page indicator, all resolved from the
/// [OnboardingPageTheme] so swiping feels like moving through chapters of one
/// product.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.theme,
    required this.assetPath,
    required this.title,
    required this.description,
    required this.isLastPage,
    required this.currentPage,
    required this.totalPages,
    required this.onSkip,
    required this.onNext,
    required this.onComplete,
  });

  final OnboardingPageTheme theme;
  final String assetPath;
  final String title;
  final String description;
  final bool isLastPage;
  final int currentPage;
  final int totalPages;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(color: theme.background),
        child: AppSafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 7,
                child: _OnboardingHead(
                  theme: theme,
                  assetPath: assetPath,
                  isLastPage: isLastPage,
                  onSkip: onSkip,
                ),
              ),
              Expanded(
                flex: 3,
                child: _OnboardingBody(
                  theme: theme,
                  title: title,
                  description: description,
                  isLastPage: isLastPage,
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onNext: onNext,
                  onComplete: onComplete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Illustration area with the brand mark pinned to the top-left corner and the
/// Skip action in the top-right corner.
class _OnboardingHead extends StatelessWidget {
  const _OnboardingHead({
    required this.theme,
    required this.assetPath,
    required this.isLastPage,
    required this.onSkip,
  });

  final OnboardingPageTheme theme;
  final String assetPath;
  final bool isLastPage;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(child: OnboardingIllustration(assetPath: assetPath)),
        Positioned(
          top: AppSpacing.xs,
          left: AppSpacing.lg,
          child: AppSvg(
            theme.brandLogoPath,
            width: AppIconSizes.xxxxl,
            height: AppIconSizes.xxxxl,
            semanticsLabel: AppBrand.name,
          ),
        ),
        if (!isLastPage)
          Positioned(
            top: AppSpacing.xs,
            right: AppSpacing.sm,
            child: TextButton(
              onPressed: onSkip,
              child: Text(
                'Skip',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: theme.skipColor),
              ),
            ),
          ),
      ],
    );
  }
}

/// Bottom block: title, description, page indicator, and the chapter CTA —
/// a compact circle on navigation pages or a wide primary action on the
/// final page.
class _OnboardingBody extends StatelessWidget {
  const _OnboardingBody({
    required this.theme,
    required this.title,
    required this.description,
    required this.isLastPage,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onComplete,
  });

  final OnboardingPageTheme theme;
  final String title;
  final String description;
  final bool isLastPage;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: theme.titleColor,
                                fontWeight: FontWeight.w700,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const AppGap.v(AppSpacing.sm),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: Text(
                            description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: theme.descriptionColor),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OnboardingIndicator(
                  accent: theme.accent,
                  inactiveColor: theme.indicatorInactive,
                  current: currentPage,
                  total: totalPages,
                ),
              ),
              if (!isLastPage) ...[
                const AppGap.h(AppSpacing.sm),
                _NextNavigationButton(
                  background: theme.ctaBackground,
                  foreground: theme.ctaForeground,
                  onPressed: onNext,
                ),
              ],
            ],
          ),
          if (isLastPage) ...[
            const AppGap.v(AppSpacing.md),
            _OnboardingActionButton(
              background: theme.ctaBackground,
              foreground: theme.ctaForeground,
              label: 'Mulai Belajar',
              onPressed: onComplete,
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact circular "Next" navigation affordance for pages 1 and 2.
class _NextNavigationButton extends StatelessWidget {
  const _NextNavigationButton({
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Next chapter',
      child: Material(
        color: background,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: AppSpacing.xxxl,
            height: AppSpacing.xxxl,
            child: Icon(
              AppIcons.arrowForward,
              color: foreground,
              size: AppIconSizes.lg,
            ),
          ),
        ),
      ),
    );
  }
}

/// Wide primary action shown on the final page.
class _OnboardingActionButton extends StatelessWidget {
  const _OnboardingActionButton({
    required this.background,
    required this.foreground,
    required this.label,
    required this.onPressed,
  });

  final Color background;
  final Color foreground;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.xxxl,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 0,
          shape: const StadiumBorder(),
          textStyle: AppTypeScale.labelLarge.copyWith(color: foreground),
        ),
        child: Text(label),
      ),
    );
  }
}
