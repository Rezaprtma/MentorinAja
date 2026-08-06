import 'package:flutter/material.dart';

import 'package:frontend/core/assets/asset_config.dart';

/// Widget that precaches assets at specific points in the app lifecycle.
///
/// Wrap the MaterialApp (or specific screens) with [AssetPrecacher] to
/// ensure critical assets are loaded into memory before they're needed.
/// This eliminates first-render jank for frequently accessed images.
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => AssetPrecacher(
///     child: AppShell(child: child!),
///   ),
/// )
/// ```
class AssetPrecacher extends StatefulWidget {
  const AssetPrecacher({
    super.key,
    required this.child,
    this.precacheOnStartup = const [],
    this.precacheAfterBuild = const [],
  });

  final Widget child;

  /// Assets to precache immediately when the widget mounts.
  final List<String> precacheOnStartup;

  /// Assets to precache after the first frame renders.
  final List<String> precacheAfterBuild;

  @override
  State<AssetPrecacher> createState() => _AssetPrecacherState();
}

class _AssetPrecacherState extends State<AssetPrecacher> {
  @override
  void initState() {
    super.initState();
    _precacheStartupAssets();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheAfterBuildAssets();
  }

  void _precacheStartupAssets() {
    final assets = [
      ...AssetConfig.precacheOnStartup,
      ...widget.precacheOnStartup,
    ];
    for (final asset in assets) {
      _precacheAsset(asset);
    }
  }

  void _precacheAfterBuildAssets() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final assets = [
        ...AssetConfig.precacheAfterAuth,
        ...widget.precacheAfterBuild,
      ];
      for (final asset in assets) {
        _precacheAsset(asset);
      }
    });
  }

  void _precacheAsset(String assetPath) {
    try {
      precacheImage(AssetImage(assetPath), context);
    } catch (_) {
      // Asset doesn't exist yet — silently ignore. Once the asset file
      // is added to the project, precaching will work automatically.
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
