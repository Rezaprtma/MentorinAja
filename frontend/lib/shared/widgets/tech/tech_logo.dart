import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

/// Logo tile for a programming technology.
///
/// Renders a recognizable technology logo (for example Python or MySQL) at its
/// original vendor colors on a subtle square tile. Artwork keeps its true brand
/// palette so vendor gradients and multi-color marks stay recognizable instead
/// of collapsing into a flat silhouette.
class TechLogo extends StatelessWidget {
  const TechLogo({
    super.key,
    required this.assetPath,
    this.background,
    this.size = AppIconSizes.xxxxl,
  });

  /// SVG asset path of the technology logo.
  final String assetPath;

  /// Tile fill; defaults to the primary container.
  final Color? background;

  /// Edge length of the square tile.
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
