import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../mock_home_data.dart';
import '../widgets/ai_tutor_card.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/home_header.dart';
import '../widgets/learning_stats.dart';
import '../widgets/recommended_section.dart';

/// Home screen root.
///
/// Composes the greeting header, a lightweight AI-tutor strip, the dominant
/// "Continue learning" hero, an open weekly-progress row and the recommended
/// feed into a calm, scrollable dashboard. Each block uses a different visual
/// treatment — open header, tinted banner, hero surface, bordered list — so the
/// page breathes instead of stacking identical cards. All values come from
/// [MockHomeData]; the layout constrains itself with [ResponsiveContainer] so
/// tablet line lengths stay readable.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: AppSafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xl,
            horizontal: AppSpacing.xxs,
          ),
          child: ResponsiveContainer(
            maxWidth: 720,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsivePadding.horizontal(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HomeHeader(displayName: MockHomeData.displayName),
                const AppGap.v(AppSpacing.lg),
                const AiTutorCard(),
                const AppGap.v(AppSpacing.xl),
                ContinueLearningCard(
                  courseTitle: MockHomeData.courseTitle,
                  lessonLabel: MockHomeData.lessonLabel,
                  progress: MockHomeData.courseProgress,
                  onContinue: () {},
                ),
                const AppGap.v(AppSpacing.xl),
                const LearningStats(stats: MockHomeData.learningStats),
                const RecommendedSection(),
                const AppGap.v(AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
