import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../mock_profile_photos.dart';

/// Profile avatar that falls back to the initial circle when no photo is set.
class ProfilePhotoAvatar extends StatelessWidget {
  const ProfilePhotoAvatar({
    super.key,
    required this.username,
    this.photoUrl,
    this.size = 96,
    this.borderWidth = 0,
    this.borderColor,
  });

  final String username;
  final String? photoUrl;
  final double size;
  final double borderWidth;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final photo = MockProfilePhotos.fromId(photoUrl);
    if (photo == null) {
      return KeyedSubtree(
        key: const ValueKey('profile-photo-initial'),
        child: AppAvatar.initial(
          name: username,
          size: size,
          borderWidth: borderWidth,
          borderColor: borderColor,
        ),
      );
    }
    return KeyedSubtree(
      key: ValueKey('profile-photo-${photo.id}'),
      child: _PhotoAvatar(
        photo: photo,
        size: size,
        borderWidth: borderWidth,
        borderColor: borderColor,
      ),
    );
  }
}

class _PhotoAvatar extends StatelessWidget {
  const _PhotoAvatar({
    required this.photo,
    required this.size,
    required this.borderWidth,
    required this.borderColor,
  });

  final ProfilePhoto photo;
  final double size;
  final double borderWidth;
  final Color? borderColor;

  List<Color> _palette(ColorScheme scheme) {
    if (photo.id == MockProfilePhotos.camera.id) {
      return [scheme.secondary, scheme.secondaryContainer];
    }
    return [scheme.primary, scheme.primaryContainer];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Foto profil',
      image: true,
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _palette(scheme),
          ),
          border: borderWidth > 0
              ? Border.all(
                  color: borderColor ?? context.appColors.border,
                  width: borderWidth,
                )
              : null,
        ),
        child: Icon(
          Icons.person_rounded,
          size: size * 0.42,
          color: Colors.white,
        ),
      ),
    );
  }
}
