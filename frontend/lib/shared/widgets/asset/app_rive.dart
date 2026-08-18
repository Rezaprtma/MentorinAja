//**
// frontend/shared/widgets/asset/app_rive.dart
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

class AppRive extends StatelessWidget {
  const AppRive(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.artboard,
    this.stateMachineName,
    this.autoplay = true,
    this.onInit,
  });

  final String assetPath;

  final double? width;
  final double? height;
  final BoxFit fit;

  final String? artboard;

  final String? stateMachineName;

  final bool autoplay;

  final void Function(dynamic controller)? onInit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: const Center(child: Icon(Icons.animation, color: Colors.grey)),
    );
  }
}
