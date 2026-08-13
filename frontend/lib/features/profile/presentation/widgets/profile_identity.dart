/// Centered identity header for the Profile tab.
///
/// Renders the avatar, display name and email as the primary profile area
/// above the settings groups. The avatar is the focal element — a large
/// initial circle wrapped in a faint brand ring — and the display name sits
/// dominant beneath it. The optional edit button is the page's single primary
/// action and uses the orange brand CTA. Pure presentation — values arrive
/// through the constructor so the widget stays reusable once real profile data
/// lands.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

class ProfileIdentity extends StatelessWidget {
  const ProfileIdentity({
    super.key,
    required this.displayName,
    required this.email,
    this.onEdit,
  });

  final String displayName;
  final String email;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppAvatar.initial(
          name: displayName,
          size: 96,
          borderWidth: 2,
          borderColor: scheme.primary.withValues(alpha: 0.18),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          displayName,
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
            leadingIcon: Icons.edit_outlined,
            onPressed: onEdit,
          ),
        ],
      ],
    );
  }
}
