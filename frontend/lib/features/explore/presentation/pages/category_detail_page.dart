import 'package:flutter/material.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/data/tech_brand_colors.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../mock_explore_data.dart';

/// Full-screen listing of a single learning area.
///
/// Receives the category name from the route, resolves its supporting
/// technology stack and lists every catalog course in that area as a
/// [CourseSummaryCard]. Course taps open the shared CourseDetailPage through
/// the stable course id.
class CategoryDetailPage extends StatelessWidget {
  const CategoryDetailPage({super.key, required this.categoryName});

  /// Display name of the learning area, e.g. "Mobile App".
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final category = _resolveCategory();
    final courses = MockCourseRepository().coursesInCategory(categoryName);

    return Scaffold(
      backgroundColor: ext.background,
      appBar: const AppAppBar(title: 'Kategori'),
      body: courses.isEmpty
          ? AppEmptyState(
              icon: Icons.category_outlined,
              title: 'Kategori Tidak Ditemukan',
              message: 'Course dalam kategori ini belum tersedia.',
              actionLabel: 'Kembali',
              onAction: () => Navigator.of(context).maybePop(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: AppSpacing.md,
                bottom: AppSpacing.xl,
              ),
              child: ResponsiveContainer(
                maxWidth: 720,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsivePadding.horizontal(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CategoryHero(category: category),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      '${courses.length} course tersedia',
                      style: AppTypeScale.bodyMedium.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _CourseGrid(courses: courses),
                  ],
                ),
              ),
            ),
    );
  }

  ExploreCategory _resolveCategory() {
    for (final category in MockExploreData.categories) {
      if (category.name == categoryName) return category;
    }
    return const ExploreCategory(
      name: 'Kategori',
      brand: TechBrandColors(
        background: Color(0xFFEDEDF0),
        accent: Color(0xFF6C6C77),
        onAccent: Color(0xFFFFFFFF),
      ),
    );
  }
}

/// Brand-tinted banner describing the learning area.
class _CategoryHero extends StatelessWidget {
  const _CategoryHero({required this.category});

  final ExploreCategory category;

  @override
  Widget build(BuildContext context) {
    final brand = category.brand;
    final onColor = brand.onAccent;

    return AppBaseCard(
      clipBehavior: Clip.antiAlias,
      color: brand.accent,
      radius: AppRadius.extraLarge,
      elevation: AppElevation.xs,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: AppTypeScale.headlineSmall.copyWith(
                    color: onColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  category.description,
                  style: AppTypeScale.bodyMedium.copyWith(
                    color: onColor.withValues(alpha: 0.85),
                  ),
                ),
                if (category.stack.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      for (final (index, path) in category.stack.indexed) ...[
                        if (index > 0) const SizedBox(width: AppSpacing.xs),
                        _StackTile(assetPath: path),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// White technology logo tile with a soft shadow, used inside the hero.
class _StackTile extends StatelessWidget {
  const _StackTile({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.small),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppSvg(assetPath, width: 20, height: 20, fit: BoxFit.contain),
    );
  }
}

/// Responsive grid of course summary cards for the category.
class _CourseGrid extends StatelessWidget {
  const _CourseGrid({required this.courses});

  final List<CourseDetail> courses;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final itemExtent = 200 + 48 * textScale;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        mainAxisExtent: itemExtent,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return CourseSummaryCard(
          title: course.title,
          category: course.category,
          description: course.shortDescription,
          iconPath: course.iconPath,
          brand: course.brand,
          lessonCount: course.lessonCount,
          rating: course.rating,
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.resolve(AppRoutes.courseDetail, {'courseId': course.id}),
          ),
        );
      },
    );
  }
}
