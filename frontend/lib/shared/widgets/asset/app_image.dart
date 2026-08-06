import 'package:flutter/material.dart';

/// Unified image widget that handles asset, network, and memory images.
///
/// [AppImage] wraps Flutter's built-in image rendering with consistent
/// error handling, placeholder support, and accessibility. When future
/// image packages are added (cached_network_image, etc.), only this
/// widget's internals change — screens continue using [AppImage].
///
/// ```dart
/// AppImage.asset(AppImages.hero, width: 200);
/// AppImage.network(url, semanticLabel: 'Course thumbnail');
/// ```
class AppImage extends StatelessWidget {
  const AppImage(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode,
    this.semanticsLabel,
    this.cacheWidth,
    this.cacheHeight,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.low,
    this.isAntiAlias = false,
    this.placeholder,
    this.errorWidget,
  }) : _source = _ImageSource.asset;

  /// Creates an image from a local asset path.
  const AppImage.asset(
    String assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode,
    this.semanticsLabel,
    this.cacheWidth,
    this.cacheHeight,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.low,
    this.isAntiAlias = false,
    this.placeholder,
    this.errorWidget,
  }) : path = assetPath,
       _source = _ImageSource.asset;

  /// Creates an image from a network URL.
  const AppImage.network(
    String url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode,
    this.semanticsLabel,
    this.cacheWidth,
    this.cacheHeight,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.low,
    this.isAntiAlias = false,
    this.placeholder,
    this.errorWidget,
  }) : path = url,
       _source = _ImageSource.network;

  /// The image path or URL.
  final String path;

  final _ImageSource _source;

  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final String? semanticsLabel;
  final int? cacheWidth;
  final int? cacheHeight;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final AlignmentGeometry alignment;
  final FilterQuality filterQuality;
  final bool isAntiAlias;

  /// Widget shown while the image loads.
  final Widget? placeholder;

  /// Widget shown when the image fails to load.
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final image = _buildImage(context);

    if (semanticsLabel != null) {
      return Semantics(label: semanticsLabel, child: image);
    }

    return image;
  }

  Widget _buildImage(BuildContext context) {
    final placeholderWidget = placeholder ?? const SizedBox.shrink();
    final errorWidgetDefault =
        errorWidget ??
        const Icon(Icons.broken_image_outlined, color: Colors.grey);

    switch (_source) {
      case _ImageSource.asset:
        return Image.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          color: color,
          colorBlendMode: colorBlendMode,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          repeat: repeat,
          centerSlice: centerSlice,
          alignment: alignment,
          filterQuality: filterQuality,
          isAntiAlias: isAntiAlias,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) return child;
            return placeholderWidget;
          },
          errorBuilder: (context, error, stackTrace) => errorWidgetDefault,
        );
      case _ImageSource.network:
        return Image.network(
          path,
          width: width,
          height: height,
          fit: fit,
          color: color,
          colorBlendMode: colorBlendMode,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          repeat: repeat,
          centerSlice: centerSlice,
          alignment: alignment,
          filterQuality: filterQuality,
          isAntiAlias: isAntiAlias,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) return child;
            return placeholderWidget;
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return placeholderWidget;
          },
          errorBuilder: (context, error, stackTrace) => errorWidgetDefault,
        );
    }
  }
}

enum _ImageSource { asset, network }
