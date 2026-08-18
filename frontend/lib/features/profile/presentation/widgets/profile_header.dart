//**
// frontend/features/profile/presentation/widgets/profile_header.dart
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
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Profil',
          style: AppTypeScale.headlineLarge.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'Kelola akun dan preferensi belajarmu.',
          style: AppTypeScale.bodyMedium.copyWith(color: ext.textSecondary),
        ),
      ],
    );
  }
}
