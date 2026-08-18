//**
// frontend/features/profile/mock_profile_photos.dart
//
// frontend:
// Source file. Bagian dari MentorinAja frontend.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi file behavior sesuai dengan purpose.
//**
library;

import 'package:flutter/foundation.dart';

@immutable
class ProfilePhoto {
  const ProfilePhoto({required this.id});

  final String id;
}

abstract final class MockProfilePhotos {
  static const ProfilePhoto gallery = ProfilePhoto(id: 'gallery');
  static const ProfilePhoto camera = ProfilePhoto(id: 'camera');

  static const List<ProfilePhoto> all = [gallery, camera];

  static ProfilePhoto? fromId(String? id) {
    for (final photo in all) {
      if (photo.id == id) return photo;
    }
    return null;
  }
}
