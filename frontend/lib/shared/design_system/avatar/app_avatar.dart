//**
// frontend/shared/design_system/avatar/app_avatar.dart
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

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
    this.borderWidth = 0,
    this.borderColor,
    this.image,
    this.initials,
    this.child,
  });

  const AppAvatar.network({
    super.key,
    String? imageUrl,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
    this.borderWidth = 0,
    this.borderColor,
  }) : image = imageUrl != null ? const _NetworkImagePlaceholder() : null,
       initials = null,
       child = null;

  AppAvatar.initial({
    super.key,
    required String name,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
    this.borderWidth = 0,
    this.borderColor,
  }) : image = null,
       initials = _deriveInitials(name),
       child = null;

  AppAvatar.user({
    super.key,
    String? imageUrl,
    required String name,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
    this.borderWidth = 0,
    this.borderColor,
  }) : image = imageUrl != null ? const _NetworkImagePlaceholder() : null,
       initials = _deriveInitials(name),
       child = null;

  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderWidth;
  final Color? borderColor;
  final Object? image;
  final String? initials;
  final Widget? child;

  static String _deriveInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? scheme.primaryContainer;
    final fg = foregroundColor ?? scheme.onPrimaryContainer;

    final decoration = BoxDecoration(
      color: bg,
      shape: BoxShape.circle,
      border: borderWidth > 0
          ? Border.all(
              color: borderColor ?? context.appColors.border,
              width: borderWidth,
            )
          : null,
    );

    return Semantics(
      label: initials ?? 'Avatar',
      image: image != null,
      child: Container(
        width: size,
        height: size,
        decoration: decoration,
        clipBehavior: Clip.antiAlias,
        child: _buildContent(bg, fg),
      ),
    );
  }

  Widget _buildContent(Color bg, Color fg) {
    if (child != null) return child!;

    if (image is _NetworkImagePlaceholder) {
      return Container(
        color: bg,
        alignment: Alignment.center,
        child: initials != null
            ? Text(
                initials!,
                style: TextStyle(
                  color: fg,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Icon(Icons.person, size: size * 0.5, color: fg),
      );
    }

    return Container(
      alignment: Alignment.center,
      child: Text(
        initials ?? '?',
        style: TextStyle(
          color: fg,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NetworkImagePlaceholder {
  const _NetworkImagePlaceholder();
}
