//**
// frontend/features/profile/presentation/widgets/profile_identity.dart
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
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import 'profile_photo_avatar.dart';

class ProfileIdentity extends StatelessWidget {
  const ProfileIdentity({
    super.key,
    required this.username,
    required this.email,
    this.photoUrl,
    this.onEdit,
  });

  final String username;
  final String email;
  final String? photoUrl;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfilePhotoAvatar(
          username: username,
          photoUrl: photoUrl,
          size: 96,
          borderWidth: 2,
          borderColor: scheme.primary.withValues(alpha: 0.18),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          username,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypeScale.headlineSmall.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          email,
          textAlign: TextAlign.center,
          style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
        ),
        if (onEdit != null) ...[
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            variant: AppButtonVariant.primary,
            label: 'Edit Profil',
            onPressed: onEdit,
          ),
        ],
      ],
    );
  }
}
