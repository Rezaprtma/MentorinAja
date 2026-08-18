//**
// frontend/features/explore/presentation/widgets/category_discovery_card.dart
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
import 'package:flutter/material.dart';

import 'package:frontend/shared/data/tech_brand_colors.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../mock_explore_data.dart';

class CategoryDiscoveryCard extends StatelessWidget {
  const CategoryDiscoveryCard({super.key, required this.category, this.onTap});

  final ExploreCategory category;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final stack = category.stack;

    return AppBaseCard(
      onTap: onTap,
      clipBehavior: Clip.antiAlias,
      color: ext.card,
      radius: AppRadius.large,
      elevation: AppElevation.xs,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CategoryBand(name: category.name, brand: category.brand),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.description,
                        style: AppTypeScale.bodyMedium.copyWith(
                          color: ext.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (stack.isNotEmpty) ...[
                        const Spacer(),
                        _TechStackRow(stack: stack, brand: category.brand),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: -AppSpacing.md,
            bottom: -AppSpacing.md,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: category.brand.accent.withValues(alpha: 0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBand extends StatelessWidget {
  const _CategoryBand({required this.name, required this.brand});

  final String name;
  final TechBrandColors brand;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: brand.accent,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Stack(
        children: [
          Positioned(
            right: AppSpacing.xs,
            top: -AppSpacing.md,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypeScale.titleMedium.copyWith(
                    color: brand.onAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brand.onAccent.withValues(alpha: 0.16),
                ),
                child: Icon(
                  Icons.arrow_outward_rounded,
                  color: brand.onAccent,
                  size: AppIconSizes.sm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TechStackRow extends StatelessWidget {
  const _TechStackRow({required this.stack, required this.brand});

  static const int _maxLogos = 4;

  final List<String> stack;
  final TechBrandColors brand;

  @override
  Widget build(BuildContext context) {
    final shown = stack.take(_maxLogos).toList();
    final hidden = stack.length - shown.length;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (index, path) in shown.indexed) ...[
            if (index > 0) const SizedBox(width: AppSpacing.xs),
            _StackTile(assetPath: path, brand: brand),
          ],
          if (hidden > 0) ...[
            const SizedBox(width: AppSpacing.xs),
            _OverflowBadge(count: hidden, brand: brand),
          ],
        ],
      ),
    );
  }
}

class _OverflowBadge extends StatelessWidget {
  const _OverflowBadge({required this.count, required this.brand});

  final int count;
  final TechBrandColors brand;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: brand.accent,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        '+$count',
        style: AppTypeScale.labelSmall.copyWith(
          color: brand.onAccent,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StackTile extends StatelessWidget {
  const _StackTile({required this.assetPath, required this.brand});

  final String assetPath;
  final TechBrandColors brand;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(color: brand.accent.withValues(alpha: 0.25)),
      ),
      child: AppSvg(assetPath, width: 18, height: 18, fit: BoxFit.contain),
    );
  }
}
