//**
// frontend/shared/widgets/asset/app_svg.dart
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
import 'package:flutter_svg/flutter_svg.dart';

class AppSvg extends StatelessWidget {
  const AppSvg(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticsLabel,
  });

  final String assetPath;

  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final widget = SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      semanticsLabel: semanticsLabel,
    );

    if (semanticsLabel == null) {
      return widget;
    }
    return Semantics(label: semanticsLabel, image: true, child: widget);
  }
}
