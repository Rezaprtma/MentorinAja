//**
// frontend/shared/widgets/asset/app_icon.dart
//
// frontend:
// Shared widget. Menyediakan reusable UI components untuk feature screens.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering dan behavior.
//**
import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.iconData, {
    super.key,
    this.size,
    this.color,
    this.semanticsLabel,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
  }) : _assetPath = null;

  const AppIcon.asset(
    String assetPath, {
    super.key,
    this.size,
    this.color,
    this.semanticsLabel,
  }) : iconData = null,
       _assetPath = assetPath,
       fill = null,
       weight = null,
       grade = null,
       opticalSize = null;

  final IconData? iconData;

  final String? _assetPath;

  final double? size;
  final Color? color;
  final String? semanticsLabel;
  final double? fill;
  final double? weight;
  final double? grade;
  final double? opticalSize;

  @override
  Widget build(BuildContext context) {
    if (_assetPath != null) {
      return _buildAssetIcon(context);
    }

    final effectiveSize = size ?? 24;
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;

    final icon = Icon(
      iconData,
      size: effectiveSize,
      color: effectiveColor,
      fill: fill,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
    );

    if (semanticsLabel != null) {
      return Semantics(label: semanticsLabel, child: icon);
    }

    return icon;
  }

  Widget _buildAssetIcon(BuildContext context) {
    return Icon(
      Icons.image_outlined,
      size: size ?? 24,
      color: color ?? Colors.grey,
    );
  }
}
