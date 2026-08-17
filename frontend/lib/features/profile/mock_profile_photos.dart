/// Mock profile photo catalog for the Edit Profil flow.
///
/// Frontend-only stand-ins for real uploaded photos. Each entry carries an id
/// that is stored as the profile's `photoUrl` so a real upload endpoint can
/// later supply actual URLs through the same seam.
library;

import 'package:flutter/foundation.dart';

/// A mock profile photo value type.
@immutable
class ProfilePhoto {
  const ProfilePhoto({required this.id});

  /// Stable identifier stored in [ProfileController.photoUrl].
  final String id;
}

/// The two mock photos offered by the picker.
abstract final class MockProfilePhotos {
  static const ProfilePhoto gallery = ProfilePhoto(id: 'gallery');
  static const ProfilePhoto camera = ProfilePhoto(id: 'camera');

  static const List<ProfilePhoto> all = [gallery, camera];

  /// Resolves a stored photo id back to its mock photo.
  static ProfilePhoto? fromId(String? id) {
    for (final photo in all) {
      if (photo.id == id) return photo;
    }
    return null;
  }
}
