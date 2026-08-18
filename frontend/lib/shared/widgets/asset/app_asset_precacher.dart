//**
// frontend/shared/widgets/asset/app_asset_precacher.dart
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

import 'package:frontend/core/assets/asset_config.dart';

class AssetPrecacher extends StatefulWidget {
  const AssetPrecacher({
    super.key,
    required this.child,
    this.precacheOnStartup = const [],
    this.precacheAfterBuild = const [],
  });

  final Widget child;

  final List<String> precacheOnStartup;

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
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
