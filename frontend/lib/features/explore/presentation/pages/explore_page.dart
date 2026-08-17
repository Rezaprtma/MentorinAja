import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/data/mock_refresh.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/tech/tech_logo.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../mock_explore_data.dart';
import '../widgets/category_discovery_card.dart';

/// Course discovery surface — the Explore tab.
///
/// Presents a discovery-first catalog layout: header, search, learning-area
/// categories, a horizontal "Kursus Populer" rail and a responsive "Untuk Kamu"
/// category discovery grid. No promotional hero — Home owns that role. Search
/// and category selection switch the catalog section into course results so
/// the default view never reads as a plain course listing.
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isSearching => _searchController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final results = _filteredCourses();

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: AppSafeArea(
        child: RefreshIndicator(
          onRefresh: mockRefresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.xxxl + AppSpacing.md,
            ),
            child: ResponsiveContainer(
              maxWidth: 720,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsivePadding.horizontal(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _ExploreHeader(),
                  const SizedBox(height: AppSpacing.lg),
                  AppSearchField(
                    controller: _searchController,
                    hint: 'Cari kursus atau materi...',
                    onChanged: (_) => setState(() {}),
                  ),
                  if (!_isSearching) ...[
                    const SizedBox(height: AppSpacing.xl),
                    const AppSectionHeader(
                      title: 'Kursus Populer',
                      trailing: _SeeAllButton(),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _PopularCourseRail(
                      courses: MockExploreData.popularCourses,
                      onCourseTap: (course) =>
                          _openCourse(context, course.courseId),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  AppSectionHeader(
                    title: _sectionTitle,
                    trailing: const _SeeAllButton(),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _catalogSection(results),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get _sectionTitle {
    if (_searchController.text.trim().isNotEmpty) return 'Hasil Pencarian';
    return 'Untuk Kamu';
  }

  List<ExploreCourse> _filteredCourses() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return MockExploreData.allCourses;

    return MockExploreData.allCourses
        .where(
          (course) =>
              course.title.toLowerCase().contains(query) ||
              course.description.toLowerCase().contains(query) ||
              course.category.toLowerCase().contains(query),
        )
        .toList();
  }

  Widget _catalogSection(List<ExploreCourse> results) {
    if (_isSearching) {
      if (results.isEmpty) {
        return const AppEmptyState(
          compact: true,
          icon: Icons.search_off_rounded,
          title: 'Tidak Ditemukan',
          message: 'Coba kata kunci lain atau pilih kategori berbeda.',
        );
      }
      return _CourseResultGrid(
        courses: results,
        onCourseTap: (course) => _openCourse(context, course.courseId),
      );
    }
    return _CategoryGrid(
      categories: MockExploreData.discoveryCategories,
      onCategoryTap: (category) => _openCategory(context, category.name),
    );
  }

  void _openCourse(BuildContext context, String courseId) {
    Navigator.of(context).pushNamed(
      AppRoutes.resolve(AppRoutes.courseDetail, {'courseId': courseId}),
    );
  }

  void _openCategory(BuildContext context, String categoryName) {
    Navigator.of(context).pushNamed(
      AppRoutes.resolve(AppRoutes.categoryDetail, {'category': categoryName}),
    );
  }
}

/// Short page header.
class _ExploreHeader extends StatelessWidget {
  const _ExploreHeader();

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Jelajahi',
          style: AppTypeScale.headlineLarge.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'Temukan materi yang sesuai dengan tujuan belajarmu.',
          style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
        ),
      ],
    );
  }
}

/// Horizontal carousel of popular courses with a peek at the next card.
class _PopularCourseRail extends StatelessWidget {
  const _PopularCourseRail({required this.courses, required this.onCourseTap});

  final List<ExploreCourse> courses;
  final ValueChanged<ExploreCourse> onCourseTap;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final railHeight = 142 + 92 * textScale;

    return SizedBox(
      height: railHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = math.min(constraints.maxWidth * 0.72, 260.0);

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
            itemCount: courses.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              return SizedBox(
                width: cardWidth,
                height: railHeight,
                child: _PopularCourseCard(
                  course: courses[index],
                  onTap: () => onCourseTap(courses[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Large vivid card for the popular course rail.
///
/// Uses the technology accent as a full-bleed surface with a white logo tile,
/// a translucent pill category and restrained decorative shapes that stay
/// inside the card composition.
class _PopularCourseCard extends StatelessWidget {
  const _PopularCourseCard({required this.course, this.onTap});

  final ExploreCourse course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brand = course.brand;
    final onColor = brand.onAccent;

    return AppBaseCard(
      onTap: onTap,
      clipBehavior: Clip.antiAlias,
      color: brand.accent,
      radius: AppRadius.large,
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
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -28,
            right: -20,
            child: Opacity(
              opacity: 0.16,
              child: AppSvg(course.iconPath, width: 96, height: 96),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TechLogo(
                  assetPath: course.iconPath,
                  size: 44,
                  background: Colors.white,
                ),
                const SizedBox(height: AppSpacing.sm),
                _CategoryPill(
                  label: course.category,
                  background: onColor.withValues(alpha: 0.14),
                  foreground: onColor,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  course.title,
                  style: AppTypeScale.titleLarge.copyWith(
                    color: onColor,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: onColor,
                      size: AppIconSizes.sm,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      course.rating.toStringAsFixed(1),
                      style: AppTypeScale.labelLarge.copyWith(
                        color: onColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      Icons.schedule_outlined,
                      color: onColor.withValues(alpha: 0.7),
                      size: AppIconSizes.sm,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Flexible(
                      child: Text(
                        '${course.lessonCount} pelajaran',
                        style: AppTypeScale.labelLarge.copyWith(
                          color: onColor.withValues(alpha: 0.75),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small rounded category label used on both card types.
class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTypeScale.labelSmall.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Responsive category discovery grid for the default "Untuk Kamu" section.
///
/// Column count follows available width via
/// [SliverGridDelegateWithMaxCrossAxisExtent]; item height scales with the
/// device text scale so band, description and stack never overflow. Hosted
/// inside the page's scroll view with non-scrollable physics.
class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories, this.onCategoryTap});

  final List<ExploreCategory> categories;
  final ValueChanged<ExploreCategory>? onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final itemExtent = 118 + 52 * textScale;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisExtent: itemExtent,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryDiscoveryCard(
          category: category,
          onTap: onCategoryTap == null ? null : () => onCategoryTap!(category),
        );
      },
    );
  }
}

/// Responsive course grid shown while searching or filtering categories.
class _CourseResultGrid extends StatelessWidget {
  const _CourseResultGrid({required this.courses, this.onCourseTap});

  final List<ExploreCourse> courses;
  final ValueChanged<ExploreCourse>? onCourseTap;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final itemExtent = 146 + 88 * textScale;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisExtent: itemExtent,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) => _CourseResultCard(
        course: courses[index],
        onTap: onCourseTap == null ? null : () => onCourseTap!(courses[index]),
      ),
    );
  }
}

/// Compact course card used in the filtered results grid.
class _CourseResultCard extends StatelessWidget {
  const _CourseResultCard({required this.course, this.onTap});

  final ExploreCourse course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final brand = course.brand;

    return AppBaseCard(
      onTap: onTap,
      clipBehavior: Clip.antiAlias,
      color: ext.card,
      radius: AppRadius.large,
      elevation: AppElevation.xs,
      padding: const EdgeInsets.all(AppSpacing.sm),
      borderSide: BorderSide(color: brand.accent.withValues(alpha: 0.16)),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brand.accent.withValues(alpha: 0.08),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: brand.background,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      border: Border.all(
                        color: brand.accent.withValues(alpha: 0.25),
                      ),
                    ),
                    child: AppSvg(course.iconPath, width: 24, height: 24),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.star_rounded,
                    color: ext.warning,
                    size: AppIconSizes.xs,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    course.rating.toStringAsFixed(1),
                    style: AppTypeScale.labelSmall.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              _CategoryPill(
                label: course.category,
                background: brand.accent,
                foreground: brand.onAccent,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                course.title,
                style: AppTypeScale.titleSmall.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                course.description,
                style: AppTypeScale.bodySmall.copyWith(
                  color: ext.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    color: ext.textDisabled,
                    size: AppIconSizes.xs,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Flexible(
                    child: Text(
                      '${course.lessonCount} pelajaran',
                      style: AppTypeScale.labelSmall.copyWith(
                        color: ext.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Lihat Semua" action used by catalog sections.
class _SeeAllButton extends StatelessWidget {
  const _SeeAllButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () {}, child: const Text('Lihat Semua'));
  }
}
