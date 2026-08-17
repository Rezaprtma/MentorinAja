/// Centered identity header for the Profile tab.
///
/// Renders the avatar, username and email as the primary profile area above
/// the settings groups. The avatar is the focal element — a large initial
/// circle (or the selected photo via [ProfilePhotoAvatar]) wrapped in a faint
/// brand ring — and the username sits dominant beneath it. The optional edit
/// button opens the Edit Profil page and is the header's single primary
/// action. Pure presentation — values arrive through the constructor so the
/// widget stays reusable once real profile data lands.
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
