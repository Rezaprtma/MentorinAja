//**
// frontend/features/profile/presentation/pages/support/about_page.dart
//
// frontend:
// Screen/page. Menampilkan UI dan menerima user interactions.
//
// backend:
// Future: akan membutuhkan backend data dan API calls.
//
// api:
// Future: akan melakukan API calls melalui controllers/repositories.
//
// qa:
// QA perlu memvalidasi UI rendering, user interactions, dan navigation.
//**
import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_assets.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: ext.background,
      appBar: const AppAppBar(title: 'Tentang'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: AppSpacing.md,
          bottom: AppSpacing.xl,
        ),
        child: ResponsiveContainer(
          maxWidth: 640,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsivePadding.horizontal(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBaseCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                elevation: AppElevation.flat,
                radius: AppRadius.extraLarge,
                borderSide: BorderSide(color: ext.border),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                      alignment: Alignment.center,
                      child: const AppSvg(
                        AppLogo.onBrand,
                        width: 44,
                        height: 44,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'MentorinAja',
                      style: AppTypeScale.titleLarge.copyWith(
                        color: ext.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Versi 1.0.0',
                      style: AppTypeScale.bodySmall.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Platform pembelajaran Indonesia dengan dukungan mentor '
                      'dan AI.',
                      textAlign: TextAlign.center,
                      style: AppTypeScale.bodyMedium.copyWith(
                        color: ext.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const AppSectionHeader(
                title: 'Misi Kami',
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppBaseCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                elevation: AppElevation.flat,
                radius: AppRadius.large,
                borderSide: BorderSide(color: ext.border),
                child: Text(
                  'Membuat belajar teknologi lebih mudah, terstruktur, dan '
                  'terjangkau untuk semua orang Indonesia, dengan dukungan '
                  'mentor dan AI di setiap langkah.',
                  style: AppTypeScale.bodyMedium.copyWith(
                    color: ext.textPrimary,
                    height: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const AppSectionHeader(
                title: 'Yang Kamu Dapatkan',
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: AppSpacing.sm),
              const _FeatureRow(
                icon: Icons.menu_book_outlined,
                title: 'Course Terstruktur',
                subtitle: 'Materi bertahap yang mudah diikuti.',
              ),
              const SizedBox(height: AppSpacing.sm),
              const _FeatureRow(
                icon: Icons.support_agent_rounded,
                title: 'Dukungan Mentor',
                subtitle: 'Bantuan dari mentor yang berpengalaman.',
              ),
              const SizedBox(height: AppSpacing.sm),
              const _FeatureRow(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Bantuan AI',
                subtitle: 'Rekomendasi belajar yang dipersonalisasi.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      elevation: AppElevation.flat,
      radius: AppRadius.large,
      borderSide: BorderSide(color: ext.border),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.secondaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: scheme.onSecondaryContainer,
              size: AppIconSizes.lg,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypeScale.titleSmall.copyWith(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypeScale.bodySmall.copyWith(
                    color: ext.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
