import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';

import '../../logic/onboarding_controller.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/onboarding_page_theme.dart';

/// Three-chapter onboarding introducing MentorinAja.
///
/// Each chapter gets a distinct visual identity, but the flow stays identical:
/// swipeable [PageView], Skip, a compact circular Next, and a final
/// "Mulai Belajar" that routes into authentication.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingController _controller;
  late final PageController _pageController;

  static const _pageTransitionDuration = Duration(milliseconds: 350);

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
      body: ListenableBuilder(
        listenable: Listenable.merge([_controller, _pageController]),
        builder: (context, _) {
          return PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: _controller.onPageChanged,
            itemBuilder: (context, index) {
              final page = _pages[index];
              final theme = OnboardingPageTheme.of(page.chapter);
              return OnboardingPage(
                theme: theme,
                assetPath: page.assetPath,
                title: page.title,
                description: page.description,
                currentPage: _controller.currentPage,
                totalPages: _controller.totalPages,
                isLastPage: _controller.isLastPage,
                onSkip: _skipToEnd,
                onNext: _nextPage,
                onComplete: _completeOnboarding,
              );
            },
          );
        },
      ),
    );
  }

  static const _pages = <_OnboardingSlide>[
    _OnboardingSlide(
      chapter: OnboardingChapter.discover,
      assetPath: AppIllustrations.onboarding1,
      title: 'Belajar Tanpa Batas.',
      description:
          'Temukan cara belajar yang lebih cerdas dengan AI yang memahami kebutuhanmu.',
    ),
    _OnboardingSlide(
      chapter: OnboardingChapter.adapt,
      assetPath: AppIllustrations.onboarding2,
      title: 'Belajar yang Menyesuaikan Dirimu.',
      description:
          'Penjelasan, latihan, dan rekomendasi materi yang berkembang bersama proses belajarmu.',
    ),
    _OnboardingSlide(
      chapter: OnboardingChapter.start,
      assetPath: AppIllustrations.onboarding3,
      title: 'Mulai Hari Ini.',
      description:
          'Satu langkah kecil hari ini dapat membuka peluang yang lebih besar di masa depan.',
    ),
  ];
}

/// Static data describing one onboarding slide.
class _OnboardingSlide {
  const _OnboardingSlide({
    required this.chapter,
    required this.assetPath,
    required this.title,
    required this.description,
  });

  final OnboardingChapter chapter;
  final String assetPath;
  final String title;
  final String description;
}
