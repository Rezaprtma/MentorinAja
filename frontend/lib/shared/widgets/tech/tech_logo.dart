//**
// frontend/shared/widgets/tech/tech_logo.dart
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

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

class TechLogo extends StatelessWidget {
  const TechLogo({
    super.key,
    required this.assetPath,
    this.background,
    this.size = AppIconSizes.xxxxl,
  });

  final String assetPath;

  final Color? background;

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final iconSize = size - AppSpacing.sm * 2;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: AppSvg(
        assetPath,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
      ),
    );
  }
}
