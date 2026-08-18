//**
// frontend/shared/design_system/lists/app_profile_tile.dart
//
// frontend:
// Design system widget. Menyediakan reusable UI components.
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

import '../../../core/theme/theme.dart';
import '../avatar/app_avatar.dart';
import 'app_tile.dart';

class AppProfileTile extends StatelessWidget {
  const AppProfileTile({
    super.key,
    this.imageUrl,
    required this.name,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.avatarSize = 40,
  });

  final String? imageUrl;
  final String name;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    return AppTile(
      leading: imageUrl != null
          ? AppAvatar.network(imageUrl: imageUrl!, size: avatarSize)
          : AppAvatar.initial(name: name, size: avatarSize),
      title: name,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
    );
  }
}
