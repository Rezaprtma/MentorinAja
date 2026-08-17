import 'package:flutter/material.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../domain/entities/lesson_content.dart';
import '../widgets/learning_navigation_bar.dart';
import '../widgets/lesson_content_block_view.dart';
import '../widgets/stages/stage_intro_card.dart';
import 'lesson_stage.dart';

/// Materi stage — focused on teaching concepts and explanations.
///
/// Renders the stage intro and the teaching blocks (paragraphs, goals, code
/// examples and tips) with no exercises. Bottom padding reserves space so the
/// floating session controls never cover the last block.
class MateriStageView extends StatelessWidget {
  const MateriStageView({
    super.key,
    required this.lesson,
    required this.blocks,
  });

  final CourseLesson lesson;

  /// Teaching-only blocks for this lesson.
  final List<LessonContentBlock> blocks;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        ResponsivePadding.horizontal(context),
        AppSpacing.md,
        ResponsivePadding.horizontal(context),
        LearningNavigationBar.reservedContentSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const StageIntroCard(stage: LessonStage.materi),
          const SizedBox(height: AppSpacing.lg),
          for (final block in blocks) ...[
            LessonContentBlockView(block: block),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
