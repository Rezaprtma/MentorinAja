import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Progress tab placeholder.
///
/// Scaffold for the learning-stats surface. Content will be built by the
/// progress feature owner; for now it renders an oriented empty state so the
/// tab shell has a stable, theme-aware page.
class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppSafeArea(
        child: AppEmptyState(
          icon: Icons.bar_chart_rounded,
          title: 'Track your progress',
          message: 'Your learning stats will show up here.',
        ),
      ),
    );
  }
}
