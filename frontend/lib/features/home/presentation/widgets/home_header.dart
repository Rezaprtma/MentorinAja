//**
// frontend/features/home/presentation/widgets/home_header.dart
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
import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.displayName,
    this.onNotificationsPressed,
  });

  final String displayName;

  final VoidCallback? onNotificationsPressed;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Selamat siang',
                style: AppTypeScale.labelMedium.copyWith(
                  color: ext.textSecondary,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '$displayName, siap lanjut belajar?',
                style: AppTypeScale.headlineMedium.copyWith(
                  color: ext.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        AppIconButton(
          icon: Icons.notifications_none,
          tooltip: 'Notifikasi',
          onPressed: onNotificationsPressed,
        ),
      ],
    );
  }
}
