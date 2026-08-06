import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../avatar/app_avatar.dart';
import 'app_tile.dart';

/// Profile display tile: avatar + name + subtitle + optional trailing.
///
/// Used in settings menus, team lists, and any context where a user identity
/// needs to be shown compactly. Composes [AppAvatar] with [AppTile].
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
