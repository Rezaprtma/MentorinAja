import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Explore tab placeholder.
///
/// Scaffold for the course discovery surface. Content will be built by the
/// explore feature owner; for now it renders an oriented empty state so the
/// tab shell has a stable, theme-aware page.
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppSafeArea(
        child: AppEmptyState(
          icon: Icons.search_rounded,
          title: 'Explore courses',
          message: 'Discover new courses and mentor guidance here.',
        ),
      ),
    );
  }
}
