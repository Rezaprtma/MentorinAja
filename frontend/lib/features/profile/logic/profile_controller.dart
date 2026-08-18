//**
// frontend/features/profile/logic/profile_controller.dart
//
// frontend:
// Controller. Mengelola state dan business logic untuk feature.
//
// backend:
// Future: akan membutuhkan backend persistence dan API integration.
//
// api:
// Future: akan melakukan API calls melalui repositories.
//
// qa:
// QA perlu memvalidasi state transitions dan edge cases.
//**
import 'package:flutter/material.dart';

import '../mock_profile_data.dart';

class ProfileController extends ChangeNotifier {
  ProfileController._();

  static final ProfileController instance = ProfileController._();

  String _username = MockProfileData.displayName;
  String? _photoUrl;

  String get username => _username;

  String get email => MockProfileData.email;

  bool get isMentor => true;

  String? get photoUrl => _photoUrl;

  void updateProfile({String? username, String? photoUrl}) {
    final nextUsername = username?.trim();
    final usernameChanged =
        nextUsername != null &&
        nextUsername.isNotEmpty &&
        nextUsername != _username;
    final photoChanged = photoUrl != null && photoUrl != _photoUrl;
    if (!usernameChanged && !photoChanged) return;

    if (usernameChanged) _username = nextUsername;
    if (photoChanged) _photoUrl = photoUrl;
    notifyListeners();
  }

  void reset() {
    _username = MockProfileData.displayName;
    _photoUrl = null;
    notifyListeners();
  }
}
