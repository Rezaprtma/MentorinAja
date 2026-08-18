//**
// frontend/features/onboarding/presentation/widgets/onboarding_illustration.dart
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
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:frontend/shared/widgets/widgets.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key, required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(
          constraints.maxWidth * 0.82,
          constraints.maxHeight * 0.85,
        );

        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: AppSvg(
              assetPath,
              fit: BoxFit.contain,
              semanticsLabel: 'Onboarding illustration',
            ),
          ),
        );
      },
    );
  }
}
